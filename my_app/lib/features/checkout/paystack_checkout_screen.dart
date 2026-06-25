import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/supabase/paystack_payment_service.dart';

/// Opens the Paystack hosted checkout in a WebView. The server is the
/// source of truth for amount + seller — the client only declares which
/// products are being bought.
///
/// Pass via go_router:
/// ```dart
/// context.go('/checkout/paystack', extra: {
///   'items': [CheckoutItem(productId: '<uuid>', quantity: 2), ...],
///   'landmark': 'Opp. Nnebisi Junction',
/// });
/// ```
class PaystackCheckoutScreen extends ConsumerStatefulWidget {
  final List<CheckoutItem> items;
  final String landmark;

  const PaystackCheckoutScreen({
    super.key,
    required this.items,
    required this.landmark,
  });

  @override
  ConsumerState<PaystackCheckoutScreen> createState() =>
      _PaystackCheckoutScreenState();
}

class _PaystackCheckoutScreenState
    extends ConsumerState<PaystackCheckoutScreen> {
  final _paystack = PaystackPaymentService();
  WebViewController? _controller;
  String _status = 'Preparing secure checkout...';
  bool _isError = false;
  bool _verifying = false;
  String? _reference;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    if (widget.items.isEmpty) {
      setState(() {
        _isError = true;
        _status = 'Cart is empty';
      });
      return;
    }

    final init = await _paystack.initializeTransaction(
      items: widget.items,
      landmark: widget.landmark,
    );

    if (init['success'] != true) {
      setState(() {
        _isError = true;
        _status = init['message'] as String? ?? 'Could not start payment';
      });
      return;
    }

    final url = init['authorization_url'] as String;
    _reference = init['reference'] as String;

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.darkBg)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final u = request.url;
            if (u.contains('paystack.co/close') ||
                u.contains('martorax://payment-complete') ||
                u.contains('checkout.paystack.com/close')) {
              _verify();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _status = 'Awaiting payment...');
          },
          onWebResourceError: (err) {
            if (mounted) {
              setState(() {
                _isError = true;
                _status = 'Could not load checkout: ${err.description}';
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    setState(() => _controller = controller);
  }

  Future<void> _verify() async {
    if (_verifying || _reference == null) return;
    setState(() {
      _verifying = true;
      _status = 'Verifying payment...';
    });

    final result = await _paystack.verifyAndHold(
      reference: _reference!,
      items: widget.items,
      landmark: widget.landmark,
    );

    if (!mounted) return;
    if (result['success'] == true) {
      // Clear the just-purchased vendor's items from the cart, then reset
      // the in-flight vendor so the next checkout starts fresh.
      final vendor = ref.read(checkoutVendorProvider);
      if (vendor != null) {
        ref.read(cartProvider.notifier).removeVendorItems(vendor);
      } else {
        ref.read(cartProvider.notifier).clearCart();
      }
      ref.read(checkoutVendorProvider.notifier).state = null;
      context.go('/order/confirmation');
    } else {
      setState(() {
        _isError = true;
        _status = result['message'] as String? ?? 'Verification failed';
        _verifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.go('/checkout/payment'),
        ),
        title: Text(ref.tr('btn_pay_now'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: _controller == null || _verifying
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isError)
                      const CircularProgressIndicator(
                          color: AppColors.emerald600),
                    if (_isError)
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.red500, size: 48),
                    const SizedBox(height: 20),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: _isError
                              ? AppColors.red500
                              : AppColors.slate400),
                    ),
                    if (_isError) ...[
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.go('/checkout/payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(ref.tr('btn_go_back'),
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : WebViewWidget(controller: _controller!),
    );
  }
}
