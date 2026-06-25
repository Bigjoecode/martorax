import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../supabase/supabase_config.dart';
import 'auth_provider.dart';

/// ===========================================================================
/// Live data providers — these read the real Supabase tables (products,
/// orders, escrow_ledger) for the signed-in user. Each fails soft: on any
/// error it returns an empty result so the UI shows an empty state rather
/// than crashing (and still works offline / in the sandbox).
/// ===========================================================================

/// Shopper home + discovery: newest products across all vendors.
final productsFeedProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  try {
    final rows = await SupabaseConfig.client
        .from('products')
        .select('id, title, price, wholesale_price, image_url, location, stock, vendor_id')
        .order('created_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(rows);
  } catch (_) {
    return const [];
  }
});

/// Aggregated stats + lists for the signed-in vendor's dashboard.
class VendorDashboardData {
  final double totalSales;
  final int orderCount;
  final int productCount;
  final int pendingCount;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> recentOrders;

  const VendorDashboardData({
    this.totalSales = 0,
    this.orderCount = 0,
    this.productCount = 0,
    this.pendingCount = 0,
    this.products = const [],
    this.recentOrders = const [],
  });
}

final vendorDashboardProvider =
    FutureProvider.autoDispose<VendorDashboardData>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const VendorDashboardData();
  final db = SupabaseConfig.client;
  try {
    final products = List<Map<String, dynamic>>.from(await db
        .from('products')
        .select('id, title, price, stock, image_url, created_at')
        .eq('vendor_id', user.id)
        .order('created_at', ascending: false));

    final orders = List<Map<String, dynamic>>.from(await db
        .from('orders')
        .select('id, buyer_id, total_amount, delivery_status, created_at')
        .eq('seller_id', user.id)
        .order('created_at', ascending: false));

    final totalSales =
        orders.fold<double>(0, (s, o) => s + (o['total_amount'] as num? ?? 0).toDouble());
    final pending = orders
        .where((o) => (o['delivery_status'] as String? ?? 'pending') != 'delivered')
        .length;

    return VendorDashboardData(
      totalSales: totalSales,
      orderCount: orders.length,
      productCount: products.length,
      pendingCount: pending,
      products: products,
      recentOrders: orders.take(5).toList(),
    );
  } catch (_) {
    return const VendorDashboardData();
  }
});
