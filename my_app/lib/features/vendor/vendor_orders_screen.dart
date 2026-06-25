import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class VendorOrdersScreen extends ConsumerStatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  ConsumerState<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends ConsumerState<VendorOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.go('/vendor/dashboard'),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.storefront_rounded,
                  color: AppColors.emerald600, size: 20),
            ),
            const SizedBox(width: 10),
            Text(ref.tr('st_vendor_orders'),
                style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded,
                    color: Colors.white, size: 22),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.emerald600,
          labelColor: AppColors.emerald600,
          unselectedLabelColor: AppColors.slate400,
          labelStyle:
              GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          tabs: [
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('New'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.emerald600.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('12',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.emerald600)),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Preparing'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('5',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.slate400)),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Shipped'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('48',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.slate400)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _NewOrdersTab(),
          _PreparingTab(),
          _ShippedTab(),
        ],
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _NewOrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('INCOMING ORDERS',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate400,
                      letterSpacing: 0.8)),
              Text('Live Updates',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emerald600)),
            ],
          ),
          const SizedBox(height: 16),
          _NewOrderCard(
            orderId: '1204',
            amount: '₦12,500.00',
            timeAgo: '2 mins ago',
            address: 'Opp. Nnebisi Junction',
            area: 'Asaba, Delta State',
            items: '2x Special Fried Rice, 1x Coca Cola (50cl)',
            showDecline: true,
          ),
          const SizedBox(height: 14),
          _NewOrderCard(
            orderId: '1203',
            amount: '₦8,200.00',
            timeAgo: '5 mins ago',
            address: 'Near Central Mosque',
            area: 'Main Market Area',
            items: '1x Family Bucket, 2x Large Fries, 2x Sides',
            showDecline: false,
          ),
        ],
      ),
    );
  }
}

class _NewOrderCard extends StatelessWidget {
  final String orderId;
  final String amount;
  final String timeAgo;
  final String address;
  final String area;
  final String items;
  final bool showDecline;

  const _NewOrderCard({
    required this.orderId,
    required this.amount,
    required this.timeAgo,
    required this.address,
    required this.area,
    required this.items,
    required this.showDecline,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/vendor/order-details'),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #$orderId',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.emerald600,
                            letterSpacing: 0.5)),
                    Text(amount,
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.amber500.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(timeAgo,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.amber500)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded,
                    color: AppColors.slate400, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text(area,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.slate400)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shopping_basket_rounded,
                    color: AppColors.slate400, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(items,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.slate400, height: 1.4)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.slate700, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 18),
                      label: Text('Accept & Prepare',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                if (showDecline) ...[
                  const SizedBox(width: 10),
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.slate700),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _PreparingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CURRENTLY PREPARING',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate400,
                  letterSpacing: 0.8)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: const BorderSide(color: Colors.blue, width: 4),
                top: BorderSide(color: AppColors.slate700.withValues(alpha: 0.5)),
                right:
                    BorderSide(color: AppColors.slate700.withValues(alpha: 0.5)),
                bottom:
                    BorderSide(color: AppColors.slate700.withValues(alpha: 0.5)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order #1198',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                  letterSpacing: 0.5)),
                          Text('₦15,000.00',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                      Text('KITCHEN',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: AppColors.slate400, size: 18),
                      const SizedBox(width: 6),
                      Text('Inter-Bau Flyover Foot',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call_rounded,
                              color: AppColors.emerald600, size: 18),
                          label: Text('Call Rider',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600)),
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: AppColors.emerald600),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardBg,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Ready',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShippedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No shipped orders yet',
          style: GoogleFonts.inter(
              fontSize: 15, color: AppColors.slate400)),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final BuildContext ctx;
  const _BottomNav(this.ctx);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.dashboard_rounded, 'Dashboard', false,
              () => ctx.go('/vendor/dashboard')),
          _NavItem(Icons.inventory_2_rounded, 'Inventory', false,
              () => ctx.go('/vendor/inventory')),
          _NavItem(Icons.list_alt_rounded, 'Orders', true, () {}),
          _NavItem(Icons.person_rounded, 'Profile', false, () {}),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(this.icon, this.label, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: active ? AppColors.emerald600 : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.emerald600 : AppColors.slate400)),
        ],
      ),
    );
  }
}
