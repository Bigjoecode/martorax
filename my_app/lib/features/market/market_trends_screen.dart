import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class MarketTrendsScreen extends ConsumerWidget {
  const MarketTrendsScreen({super.key});

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
                    AppColors.darkBg.withValues(alpha: 0.9),
                pinned: true,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 20),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ogbogonogo Market',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text('Asaba, Delta State',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.slate400)),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.emerald600
                                .withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.emerald600,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('LIVE NOW',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600,
                                  letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(0, 16, 0, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Daily Price Board
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daily Price Board',
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            Text('Last updated 5m ago',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color:
                                        AppColors.emerald600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          children: const [
                            _PriceCard(
                              label: 'Rice (50kg Bag)',
                              price: '₦45,000',
                              change: '+2.4%',
                              isUp: true,
                            ),
                            SizedBox(height: 12),
                            _PriceCard(
                              label: 'Tomatoes (Big Basket)',
                              price: '₦12,000',
                              change: '-5.1%',
                              isUp: false,
                            ),
                            SizedBox(height: 12),
                            _PriceCard(
                              label: 'Garri (Yellow Paint)',
                              price: '₦1,500',
                              change: 'STABLE',
                              isStable: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Trending Stalls
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Trending Stalls',
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            Text('Highest activity today',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          children: const [
                            _StallTile(
                                name: 'Mama Nkechi',
                                icon: Icons.local_grocery_store_rounded,
                                live: true),
                            _StallTile(
                                name: 'Chidi Tools',
                                icon: Icons.hardware_rounded,
                                live: false),
                            _StallTile(
                                name: 'Fruit Hub',
                                icon: Icons.local_florist_rounded,
                                live: true),
                            _StallTile(
                                name: 'Auchi Spices',
                                icon: Icons.spa_rounded,
                                live: false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Best Deals
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Text('Best Deals Today',
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Row(
                          children: const [
                            Expanded(
                              child: _DealCard(
                                title: 'Vegetable Oil (5L)',
                                price: '₦7,200',
                                oldPrice: '₦9,000',
                                discount: '-20%',
                                location: 'Stall B22 • 400m away',
                                icon: Icons.water_drop_rounded,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _DealCard(
                                title: 'Live Chicken (Large)',
                                price: '₦5,500',
                                oldPrice: '₦6,500',
                                discount: '-15%',
                                location: 'Ibo Section • 250m away',
                                icon: Icons.egg_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Market Sentiment
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Text(ref.tr('st_market_trends'),
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.cardBg,
                                AppColors.darkBg,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.slate700),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.speed_rounded,
                                          color: Color(0xFFF59E0B),
                                          size: 20),
                                      const SizedBox(width: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    'Activity Level: ',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  color:
                                                      Colors.white,
                                                )),
                                            TextSpan(
                                                text: 'BUSY',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  color: const Color(
                                                      0xFFF59E0B),
                                                  letterSpacing:
                                                      0.5,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text('10:45 AM',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors
                                              .slate400)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Activity bar
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF10B981),
                                      Color(0xFFF59E0B),
                                      Color(0xFFEF4444),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.55,
                                      child: Container(
                                        width: 4,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.white
                                                    .withValues(
                                                        alpha:
                                                            0.5),
                                                blurRadius: 8),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('QUIET',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w700,
                                          color:
                                              AppColors.slate400,
                                          letterSpacing: 1.5)),
                                  Text('MODERATE',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w700,
                                          color:
                                              AppColors.slate400,
                                          letterSpacing: 1.5)),
                                  Text('HUSTLING',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 1.5)),
                                  Text('PEAK',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w700,
                                          color:
                                              AppColors.slate400,
                                          letterSpacing: 1.5)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  'High foot traffic reported in the meat and poultry section. Pricing remains competitive but negotiation times are longer than usual.',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.slate400,
                                      height: 1.5)),
                            ],
                          ),
                        ),
                      ),
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
                  _NavItem(Icons.home_rounded, 'Home', true,
                      () => context.go('/home')),
                  _NavItem(Icons.search_rounded, 'Search', false,
                      () => context.go('/search')),
                  _NavItem(Icons.receipt_long_rounded,
                      'Bookings', false,
                      () => context.go('/bookings')),
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

class _PriceCard extends StatelessWidget {
  final String label;
  final String price;
  final String change;
  final bool isUp;
  final bool isStable;
  const _PriceCard({
    required this.label,
    required this.price,
    required this.change,
    this.isUp = false,
    this.isStable = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isStable
        ? AppColors.slate400
        : (isUp
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate400)),
                const SizedBox(height: 4),
                Text(price,
                    style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                      isStable
                          ? null
                          : (isUp
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded),
                      color: color,
                      size: 16),
                  if (!isStable) const SizedBox(width: 4),
                  Text(change,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: isStable ? 1.0 : 0)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: isStable
                      ? AppColors.slate700
                      : color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StallTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool live;
  const _StallTile({
    required this.name,
    required this.icon,
    required this.live,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: live
                          ? AppColors.emerald600
                          : AppColors.slate700,
                      width: 2),
                ),
                child: Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      color: live
                          ? AppColors.emerald600
                          : AppColors.slate400,
                      size: 40),
                ),
              ),
              if (live)
                Positioned(
                  bottom: -8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('LIVE',
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: live
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: live ? Colors.white : AppColors.slate400)),
        ],
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final String title;
  final String price;
  final String oldPrice;
  final String discount;
  final String location;
  final IconData icon;
  const _DealCard({
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.location,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                color: AppColors.surfaceBg,
                child: Center(
                  child: Icon(icon,
                      color: AppColors.emerald600,
                      size: 48),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(discount,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(price,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald600)),
                    const SizedBox(width: 6),
                    Text(oldPrice,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            decoration:
                                TextDecoration.lineThrough,
                            color: AppColors.slate400)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(location,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.slate400)),
              ],
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
              color: active
                  ? AppColors.emerald600
                  : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
