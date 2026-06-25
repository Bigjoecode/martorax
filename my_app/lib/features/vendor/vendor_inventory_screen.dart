import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class VendorInventoryScreen extends ConsumerStatefulWidget {
  const VendorInventoryScreen({super.key});

  @override
  ConsumerState<VendorInventoryScreen> createState() => _VendorInventoryScreenState();
}

class _VendorInventoryScreenState extends ConsumerState<VendorInventoryScreen> {
  int _filterIdx = 0;
  final _searchCtrl = TextEditingController();

  static const _filters = ['All', 'In Stock', 'Out of Stock', 'Low Stock'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 22),
          onPressed: () => context.go('/vendor/dashboard'),
        ),
        title: Column(
          children: [
            Text(ref.tr('st_vendor_inventory'),
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            Text('124 PRODUCTS',
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald600,
                    letterSpacing: 1.0)),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.emerald600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.cardBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search_rounded, color: AppColors.slate400, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.slate400),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Filter chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => setState(() => _filterIdx = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _filterIdx == i
                            ? AppColors.emerald600
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[i],
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _filterIdx == i
                                  ? Colors.white
                                  : AppColors.slate400)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Quick action dashboard
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickAction(
                    icon: Icons.payments_rounded,
                    label: 'Quick Price',
                  ),
                  Container(width: 1, height: 32, color: AppColors.slate700.withValues(alpha: 0.4)),
                  _QuickAction(
                    icon: Icons.inventory_2_rounded,
                    label: 'Quick Stock',
                  ),
                  Container(width: 1, height: 32, color: AppColors.slate700.withValues(alpha: 0.4)),
                  _QuickAction(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan',
                  ),
                ],
              ),
            ),
          ),

          // Product list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                _ProductCard(
                  name: 'Leather Artisan Handbag',
                  price: '₦45,000',
                  stockStatus: _StockStatus.inStock,
                  stockLabel: '12 units in stock',
                  icon: Icons.shopping_bag_rounded,
                ),
                const SizedBox(height: 10),
                _ProductCard(
                  name: 'Ceramic Dining Set (4pcs)',
                  price: '₦18,500',
                  stockStatus: _StockStatus.lowStock,
                  stockLabel: 'Only 2 left!',
                  icon: Icons.kitchen_rounded,
                ),
                const SizedBox(height: 10),
                _ProductCard(
                  name: 'Wireless Pro Headphones',
                  price: '₦120,000',
                  stockStatus: _StockStatus.outOfStock,
                  stockLabel: 'Sold Out',
                  icon: Icons.headphones_rounded,
                  dimmed: true,
                ),
                const SizedBox(height: 10),
                _ProductCard(
                  name: 'Organic Surface Cleaner',
                  price: '₦3,500',
                  stockStatus: _StockStatus.inStock,
                  stockLabel: '45 units in stock',
                  icon: Icons.cleaning_services_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

enum _StockStatus { inStock, lowStock, outOfStock }

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.emerald600.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.emerald600, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(),
            style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 0.3)),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final _StockStatus stockStatus;
  final String stockLabel;
  final IconData icon;
  final bool dimmed;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.stockStatus,
    required this.stockLabel,
    required this.icon,
    this.dimmed = false,
  });

  Color get _dotColor {
    switch (stockStatus) {
      case _StockStatus.inStock:
        return Colors.green;
      case _StockStatus.lowStock:
        return AppColors.amber500;
      case _StockStatus.outOfStock:
        return Colors.red;
    }
  }

  Color get _badgeColor {
    switch (stockStatus) {
      case _StockStatus.inStock:
        return Colors.green;
      case _StockStatus.lowStock:
        return AppColors.amber500;
      case _StockStatus.outOfStock:
        return Colors.red;
    }
  }

  bool get _isRestock => stockStatus == _StockStatus.lowStock;
  bool get _isPrimary => stockStatus == _StockStatus.outOfStock;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.8 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon,
                          color: AppColors.slate400, size: 36),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _dotColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.darkBg, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(price,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emerald600)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(stockLabel,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _badgeColor)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionBtn(
                      icon: Icons.edit_note_rounded,
                      label: 'Edit Price',
                      primary: false),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionBtn(
                    icon: Icons.add_box_rounded,
                    label: _isRestock
                        ? 'Restock'
                        : 'Add Stock',
                    primary: _isRestock || _isPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool primary;
  const _ActionBtn(
      {required this.icon, required this.label, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: primary
            ? AppColors.emerald600.withValues(alpha: 0.2)
            : AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(8),
        border: primary
            ? Border.all(color: AppColors.emerald600.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: primary ? AppColors.emerald600 : AppColors.slate400,
              size: 16),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primary ? AppColors.emerald600 : AppColors.slate400)),
        ],
      ),
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
          _NavItem(Icons.space_dashboard_rounded, 'Dashboard', false,
              () => ctx.go('/vendor/dashboard')),
          _NavItem(Icons.inventory_2_rounded, 'Inventory', true, () {}),
          _NavItem(Icons.receipt_long_rounded, 'Orders', false,
              () => ctx.go('/vendor/orders')),
          _NavItem(Icons.account_circle_rounded, 'Profile', false, () {}),
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
