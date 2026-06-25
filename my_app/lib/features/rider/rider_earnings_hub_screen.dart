import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class RiderEarningsHubScreen extends ConsumerWidget {
  const RiderEarningsHubScreen({super.key});

  static const _trips = [
    _TripItem('Asaba Mall Delivery', 'Today, 14:20 • Order #8421', '₦850.00'),
    _TripItem('Nnebisi Rd Dropoff', 'Today, 13:45 • Order #8418', '₦1,200.00'),
    _TripItem('Summit Junction P/U', 'Today, 12:10 • Order #8405', '₦1,050.00'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor:
                    AppColors.darkBg.withValues(alpha: 0.8),
                floating: true,
                pinned: true,
                elevation: 0,
                leading: const SizedBox.shrink(),
                title: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.delivery_dining_rounded,
                            color: AppColors.emerald600,
                            size: 22),
                        const SizedBox(width: 8),
                        Text('MartoraX',
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(Icons.notifications_rounded,
                                color: AppColors.slate400,
                                size: 22),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.darkBg,
                                      width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_rounded,
                              color: AppColors.slate400, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                titleSpacing: 16,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                  child: Column(
                    children: [
                      // Balance hero
                      Column(
                        children: [
                          Text(ref.tr('st_rider_earnings').toUpperCase(),
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.slate400,
                                  letterSpacing: 1.5)),
                          const SizedBox(height: 8),
                          Text('₦12,450.00',
                              style: GoogleFonts.inter(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -1)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_rounded,
                                  color: AppColors.emerald600,
                                  size: 14),
                              const SizedBox(width: 4),
                              Text('Verified Asaba Rider',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.emerald600)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Withdraw button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 20),
                          label: Text('Withdraw to Bank',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.emerald600,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Daily goal
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg
                              .withValues(alpha: 0.5),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Daily Goal',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white)),
                                    Text('Keep it up, Champ!',
                                        style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color:
                                                AppColors.slate400)),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '₦8,500',
                                        style: GoogleFonts.inter(
                                            fontSize: 17,
                                            fontWeight:
                                                FontWeight.w700,
                                            color:
                                                AppColors.emerald600),
                                      ),
                                      TextSpan(
                                        text: ' / ₦15,000',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color:
                                                AppColors.slate400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: 0.56,
                                backgroundColor:
                                    AppColors.slate700,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        AppColors.emerald600),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.slate400),
                                  children: [
                                    const TextSpan(
                                        text: 'You need '),
                                    TextSpan(
                                        text: '₦6,500',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: Colors.white)),
                                    const TextSpan(
                                        text:
                                            ' more to reach your goal.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Recent trips
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Trips',
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text('View All',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.emerald600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._trips.map((t) => _TripCard(trip: t)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg.withValues(alpha: 0.95),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom:
                    MediaQuery.of(context).padding.bottom + 12,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(Icons.dashboard_rounded, 'Dashboard',
                      false,
                      () => context.go('/rider/dashboard')),
                  _NavItem(
                      Icons.account_balance_wallet_rounded,
                      'Earnings',
                      true,
                      () {}),
                  _NavItem(Icons.history_rounded, 'History',
                      false, () {}),
                  _NavItem(Icons.person_rounded, 'Profile',
                      false, () => context.go('/profile')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripItem {
  final String title;
  final String subtitle;
  final String amount;
  const _TripItem(this.title, this.subtitle, this.amount);
}

class _TripCard extends StatelessWidget {
  final _TripItem trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.emerald600.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_shipping_rounded,
                color: AppColors.emerald600, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text(trip.subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.slate400)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+${trip.amount}',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981))),
              Text('Completed',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.slate400)),
            ],
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
              color: active
                  ? AppColors.emerald600
                  : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
