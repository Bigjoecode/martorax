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

/// Service provider dashboard: bookings assigned to the signed-in provider.
class ProviderDashboardData {
  final int totalBookings;
  final int pendingCount;
  final int completedCount;
  final double earnings;
  final List<Map<String, dynamic>> recent;
  const ProviderDashboardData({
    this.totalBookings = 0,
    this.pendingCount = 0,
    this.completedCount = 0,
    this.earnings = 0,
    this.recent = const [],
  });
}

final providerDashboardProvider =
    FutureProvider.autoDispose<ProviderDashboardData>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const ProviderDashboardData();
  try {
    final rows = List<Map<String, dynamic>>.from(await SupabaseConfig.client
        .from('service_bookings')
        .select('id, shopper_id, service_category, description, amount, status, scheduled_for, created_at')
        .eq('provider_id', user.id)
        .order('created_at', ascending: false));

    final completed = rows.where((b) => (b['status'] as String?) == 'completed');
    final pending = rows.where((b) =>
        (b['status'] as String?) == 'requested' ||
        (b['status'] as String?) == 'accepted');
    final earnings =
        completed.fold<double>(0, (s, b) => s + (b['amount'] as num? ?? 0).toDouble());

    return ProviderDashboardData(
      totalBookings: rows.length,
      pendingCount: pending.length,
      completedCount: completed.length,
      earnings: earnings,
      recent: rows.take(6).toList(),
    );
  } catch (_) {
    return const ProviderDashboardData();
  }
});

/// Rider dashboard: orders assigned to the signed-in rider for delivery.
class RiderDashboardData {
  final int totalDeliveries;
  final int activeCount;
  final int completedCount;
  final double earnings;
  final List<Map<String, dynamic>> recent;
  const RiderDashboardData({
    this.totalDeliveries = 0,
    this.activeCount = 0,
    this.completedCount = 0,
    this.earnings = 0,
    this.recent = const [],
  });
}

/// Flat delivery fee a rider earns per completed drop (Naira).
const double kRiderFeePerDelivery = 800;

final riderDashboardProvider =
    FutureProvider.autoDispose<RiderDashboardData>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const RiderDashboardData();
  try {
    final rows = List<Map<String, dynamic>>.from(await SupabaseConfig.client
        .from('orders')
        .select('id, total_amount, delivery_status, landmark_destination, created_at')
        .eq('rider_id', user.id)
        .order('created_at', ascending: false));

    final completed =
        rows.where((o) => (o['delivery_status'] as String?) == 'delivered');
    final active = rows.where((o) => (o['delivery_status'] as String?) != 'delivered');

    return RiderDashboardData(
      totalDeliveries: rows.length,
      activeCount: active.length,
      completedCount: completed.length,
      earnings: completed.length * kRiderFeePerDelivery,
      recent: rows.take(6).toList(),
    );
  } catch (_) {
    return const RiderDashboardData();
  }
});

/// The signed-in user's KYC verification status (unverified/pending/verified/rejected).
final kycStatusProvider = Provider<String>((ref) {
  final profile = ref.watch(currentProfileProvider).valueOrNull;
  return (profile?['kyc_status'] as String?) ?? 'unverified';
});

/// The signed-in user's in-app notifications, newest first.
final notificationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  try {
    final rows = await SupabaseConfig.client
        .from('notifications')
        .select('id, title, body, type, is_read, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(rows);
  } catch (_) {
    return const [];
  }
});
