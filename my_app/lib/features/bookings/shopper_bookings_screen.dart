import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ShopperBookingsScreen extends ConsumerStatefulWidget {
  const ShopperBookingsScreen({super.key});

  @override
  ConsumerState<ShopperBookingsScreen> createState() => _ShopperBookingsScreenState();
}

class _ShopperBookingsScreenState extends ConsumerState<ShopperBookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_bookings'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded,
                color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppColors.emerald600,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.slate400,
          labelStyle: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: ref.tr('bk_tab_upcoming')),
            Tab(text: ref.tr('bk_tab_completed')),
            Tab(text: ref.tr('bk_tab_cancelled')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _ActiveTab(),
          _EmptyTab(ref.tr('bk_empty')),
          _EmptyTab(ref.tr('bk_empty')),
        ],
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _BookingCard(
          statusLabel: 'In Progress',
          statusColor: AppColors.emerald600,
          statusIcon: null,
          pulsing: true,
          title: 'TechFlow Solutions',
          subtitle: 'Deep Home Cleaning',
          date: 'Today, 10:30 AM',
          icon: Icons.cleaning_services_rounded,
          primary: true,
        ),
        const SizedBox(height: 12),
        _BookingCard(
          statusLabel: 'Awaiting Delivery',
          statusColor: AppColors.amber500,
          statusIcon: Icons.local_shipping_rounded,
          pulsing: false,
          title: 'Organic Pantry',
          subtitle: 'Fresh Grocery Bundle',
          date: 'Oct 26, 2:00 PM',
          icon: Icons.shopping_basket_rounded,
          primary: false,
        ),
        const SizedBox(height: 12),
        _BookingCard(
          statusLabel: 'Pending Approval',
          statusColor: AppColors.slate400,
          statusIcon: Icons.schedule_rounded,
          pulsing: false,
          title: 'Gadget Hub',
          subtitle: 'MacBook Pro M3 Max',
          date: 'Nov 02, 09:00 AM',
          icon: Icons.laptop_rounded,
          primary: false,
        ),
        const SizedBox(height: 12),
        _BookingCard(
          statusLabel: 'Service Confirmed',
          statusColor: AppColors.emerald600,
          statusIcon: Icons.verified_rounded,
          pulsing: false,
          title: 'Lawn Masters',
          subtitle: 'Seasonal Landscaping',
          date: 'Nov 15, 11:30 AM',
          icon: Icons.grass_rounded,
          primary: false,
        ),
      ],
    );
  }
}

class _EmptyTab extends StatelessWidget {
  final String message;
  const _EmptyTab(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message,
          style: GoogleFonts.inter(
              fontSize: 14, color: AppColors.slate400)),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String statusLabel;
  final Color statusColor;
  final IconData? statusIcon;
  final bool pulsing;
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final bool primary;

  const _BookingCard({
    required this.statusLabel,
    required this.statusColor,
    required this.statusIcon,
    required this.pulsing,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (statusIcon != null)
                      Icon(statusIcon, color: statusColor, size: 14)
                    else
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(statusLabel.toUpperCase(),
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                            letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text(subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate400)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: AppColors.slate400, size: 12),
                    const SizedBox(width: 6),
                    Text(date,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.slate400)),
                  ],
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => context.go('/order/status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary
                        ? AppColors.emerald600
                        : AppColors.surfaceBg,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View Details',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.emerald600, size: 40),
          ),
        ],
      ),
    );
  }
}

