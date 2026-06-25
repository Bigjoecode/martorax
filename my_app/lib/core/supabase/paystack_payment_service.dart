import 'dart:convert';
import 'package:http/http.dart' as http;
import 'supabase_config.dart';

/// Item payload used by both [PaystackPaymentService.initializeTransaction]
/// and [PaystackPaymentService.verifyAndHold]. The server is the source of
/// truth for price + vendor; the client only declares which product and how
/// many. Anything else (amount, vendor) is computed server-side.
class CheckoutItem {
  final String productId;
  final int quantity;
  const CheckoutItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
      };
}

/// Thin client for the Paystack flow.
///
/// All money flows through our `verify-payment-and-hold` Edge Function. The
/// client never sees the secret key and cannot influence the amount or which
/// vendor gets paid — both are derived from the products table on the server.
///
/// Two phases:
/// 1. [initializeTransaction] → server computes total from items, asks
///    Paystack to initialize a transaction for that exact amount, returns
///    the authorization URL to load in a WebView.
/// 2. [verifyAndHold] → once the WebView reports back, server re-fetches the
///    transaction from Paystack, re-quotes the cart, confirms amounts match,
///    creates `orders` + `order_items` + `escrow_ledger` atomically.
class PaystackPaymentService {
  /// Placeholder — swap to your real Paystack public test/live key before launch.
  /// (Only the public key ships in the client; the secret key lives on the
  /// Edge Function runtime.)
  static const String paystackPublicKey =
      'pk_test_bf9d7dd75a676e41e60ab6ff0b03197f531678f1';

  static const String _fnName = 'verify-payment-and-hold';
  static const String _paystackBase = 'https://api.paystack.co';

  /// Step 1: initialize Paystack for the given cart. Returns the hosted
  /// checkout URL to load in a WebView, the server-authoritative total,
  /// and the reference to verify against later.
  Future<Map<String, dynamic>> initializeTransaction({
    required List<CheckoutItem> items,
    required String landmark,
  }) async {
    try {
      final response = await SupabaseConfig.client.functions.invoke(
        _fnName,
        body: {
          'mode': 'init',
          'items': items.map((i) => i.toJson()).toList(),
          'landmark': landmark,
        },
      );

      final data = response.data;
      if (data is Map && data['authorization_url'] is String) {
        return {
          'success': true,
          'authorization_url': data['authorization_url'],
          'reference': data['reference'],
          'expected_total_naira':
              (data['expected_total_naira'] as num?)?.toDouble() ?? 0.0,
          'seller_id': data['seller_id'] as String?,
        };
      }
      return {
        'success': false,
        'message': data is Map ? (data['message'] ?? 'Init failed') : 'Init failed',
      };
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Step 2: confirm the WebView-reported transaction with the server.
  /// The server re-fetches the Paystack transaction, re-quotes the cart from
  /// the products table, and on a match creates the order + escrow row.
  Future<Map<String, dynamic>> verifyAndHold({
    required String reference,
    required List<CheckoutItem> items,
    required String landmark,
  }) async {
    try {
      final response = await SupabaseConfig.client.functions.invoke(
        _fnName,
        body: {
          'mode': 'verify',
          'reference': reference,
          'items': items.map((i) => i.toJson()).toList(),
          'landmark': landmark,
        },
      );

      final data = response.data;
      if (data is Map && data['success'] == true) {
        return {
          'success': true,
          'hold_code': data['hold_code'],
          'order_id': data['order_id'],
          'total_naira': (data['total_naira'] as num?)?.toDouble() ?? 0.0,
          'reference': reference,
        };
      }
      return {
        'success': false,
        'message': data is Map ? (data['message'] ?? 'Verify failed') : 'Verify failed',
      };
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Lightweight client-side check against Paystack's public verify endpoint.
  /// Useful only when the Edge Function isn't deployed yet. Do NOT rely on
  /// this in production — anyone can fake a successful response to the
  /// client. Real verification must happen server-side via [verifyAndHold].
  Future<bool> publicVerify(String reference) async {
    try {
      final resp = await http.get(
        Uri.parse('$_paystackBase/transaction/verify/$reference'),
        headers: {'Authorization': 'Bearer $paystackPublicKey'},
      );
      if (resp.statusCode != 200) return false;
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      return body['status'] == true && body['data']?['status'] == 'success';
    } catch (_) {
      return false;
    }
  }
}
