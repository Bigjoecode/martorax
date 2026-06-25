import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.emerald600.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.person_rounded,
                  color: AppColors.emerald600, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.slate400)),
                Text("Chief's Electronics",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded,
                color: Colors.white, size: 22),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded,
                    color: Colors.white, size: 22),
                onPressed: () => context.go('/notifications'),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.emerald600,
                      const Color(0xFF048A60),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald600.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Balance',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9))),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('₦1,240,500.00',
                            style: GoogleFonts.manrope(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.emerald600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: Text('Withdraw',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Next payout in 2 days',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ),

            // Quick stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.shopping_bag_rounded,
                      iconColor: AppColors.emerald600,
                      label: 'ORDERS',
                      value: '12',
                      change: '+15%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.local_shipping_rounded,
                      iconColor: AppColors.amber500,
                      label: 'PENDING',
                      value: '5',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.warning_rounded,
                      iconColor: Colors.red,
                      label: 'ALERTS',
                      value: '3',
                      valueColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Market Price Board
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Market Price Board (Asaba)',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate400,
                          letterSpacing: 0.8)),
                  GestureDetector(
                    onTap: () => context.go('/vendor/analytics'),
                    child: Text('Live Updates',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.emerald600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _MarketCard(
                    market: 'Ogbogonogo Market',
                    item: 'Rice (50kg Bag)',
                    price: '₦65,000',
                    change: '↑ 2.4% Today',
                    changeColor: Colors.red,
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.emerald600,
                  ),
                  _MarketCard(
                    market: 'Cable Point',
                    item: 'Palm Oil (25L)',
                    price: '₦28,500',
                    change: '↓ 1.2% Today',
                    changeColor: AppColors.emerald600,
                    icon: Icons.trending_down_rounded,
                    iconColor: AppColors.blue500,
                  ),
                  _MarketCard(
                    market: 'Koka Market',
                    item: 'Garri (Paint)',
                    price: '₦1,800',
                    change: 'Stable',
                    changeColor: AppColors.slate400,
                    icon: Icons.remove_rounded,
                    iconColor: AppColors.slate400,
                  ),
                ],
              ),
            ),

            // Recent orders
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Orders',
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  GestureDetector(
                    onTap: () => context.go('/vendor/orders'),
                    child: Text('See All',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _OrderRow(
                    name: 'Chukwudi Onuoha',
                    orderId: 'MX-8921',
                    time: '12:45 PM',
                    amount: '₦42,000',
                    status: 'Processing',
                    statusColor: AppColors.amber500,
                  ),
                  const SizedBox(height: 10),
                  _OrderRow(
                    name: 'Blessing Amadi',
                    orderId: 'MX-8919',
                    time: '10:20 AM',
                    amount: '₦12,500',
                    status: 'Shipped',
                    statusColor: AppColors.emerald600,
                  ),
                  const SizedBox(height: 10),
                  _OrderRow(
                    name: 'Emeka Okafor',
                    orderId: 'MX-8918',
                    time: '09:15 AM',
                    amount: '₦85,000',
                    status: 'Delivered',
                    statusColor: AppColors.slate400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? change;
  final Color? valueColor;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.change,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate400,
                  letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? Colors.white)),
              if (change != null) ...[
                const SizedBox(width: 4),
                Text(change!,
                    style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final String market;
  final String item;
  final String price;
  final String change;
  final Color changeColor;
  final IconData icon;
  final Color iconColor;

  const _MarketCard({
    required this.market,
    required this.item,
    required this.price,
    required this.change,
    required this.changeColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(market,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate400)),
                    Text(item,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.emerald600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(change,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: changeColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String name;
  final String orderId;
  final String time;
  final String amount;
  final String status;
  final Color statusColor;

  const _OrderRow({
    required this.name,
    required this.orderId,
    required this.time,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person_rounded, color: AppColors.slate400, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text('Order #$orderId • $time',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.slate400)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor)),
              ),
            ],
          ),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(Icons.grid_view_rounded, 'Home', true, () {}),
              _NavItem(Icons.inventory_2_rounded, 'Inventory', false,
                  () => ctx.go('/vendor/inventory')),
              const SizedBox(width: 56),
              _NavItem(Icons.receipt_long_rounded, 'Orders', false,
                  () => ctx.go('/vendor/orders')),
              _NavItem(Icons.account_circle_rounded, 'Profile', false,
                  () => ctx.go('/profile')),
            ],
          ),
          Positioned(
            top: -28,
            child: GestureDetector(
              onTap: () => ctx.go('/vendor/go-live'),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkBg, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald600.withValues(alpha: 0.4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
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
