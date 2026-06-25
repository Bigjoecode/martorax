import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class AiPersonalizedFeedScreen extends ConsumerStatefulWidget {
  const AiPersonalizedFeedScreen({super.key});

  @override
  ConsumerState<AiPersonalizedFeedScreen> createState() =>
      _AiPersonalizedFeedScreenState();
}

class _AiPersonalizedFeedScreenState
    extends ConsumerState<AiPersonalizedFeedScreen> {
  int _chipIdx = 0;
  static const _chips = [
    'For You',
    'Home Maintenance',
    'Auto Care',
    'Wellness'
  ];

  @override
  Widget build(BuildContext context) {
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
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.emerald600
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.auto_awesome_rounded,
                      color: AppColors.emerald600, size: 22),
                ),
                title: Text(ref.tr('st_ai_feed'),
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.notifications_rounded,
                            color: AppColors.slate400,
                            size: 24),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _chips.length,
                    itemBuilder: (_, i) {
                      final selected = _chipIdx == i;
                      return GestureDetector(
                        onTap: () => setState(() => _chipIdx = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          height: 40,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.emerald600
                                : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: selected
                                ? null
                                : Border.all(
                                    color: AppColors.slate700),
                          ),
                          child: Row(
                            children: [
                              if (selected) ...[
                                Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 16),
                                const SizedBox(width: 6),
                              ],
                              Center(
                                child: Text(_chips[i],
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: selected
                                            ? Colors.white
                                            : AppColors.slate400)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recommended for You',
                          style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Based on your activity and location',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.slate400)),
                    ],
                  ),
                ),
              ),
              // Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    children: [
                      _AiSuggestionCard(
                        badge: 'BASED ON HISTORY',
                        badgeIcon: Icons.history_rounded,
                        badgeColor: AppColors.emerald600,
                        bgIcon: Icons.dry_cleaning_rounded,
                        title: 'Need a Dry Cleaner?',
                        subtitle:
                            'Since you booked a Tailor last month, we thought you might need these garments professionally cleaned.',
                        avatars: 3,
                        ctaLabel: 'View Pros',
                      ),
                      _AiSuggestionCard(
                        badge: 'TIMELY SUGGESTION',
                        badgeIcon: Icons.thunderstorm_rounded,
                        badgeColor: const Color(0xFFF59E0B),
                        bgIcon: Icons.roofing_rounded,
                        title: 'Rainy Season is Coming',
                        subtitle:
                            'Top-rated Roof Repairers are booking up fast near your location. Secure a check-up before the storms hit.',
                        rating: '4.9',
                        reviews: '(240+ reviews)',
                        ctaLabel: 'Get Quotes',
                      ),
                      _AiSuggestionCard(
                        badge: 'ROUTINE CARE',
                        badgeIcon: Icons.event_repeat_rounded,
                        badgeColor: const Color(0xFF3B82F6),
                        bgIcon: Icons.directions_car_rounded,
                        title: 'Time for a Car Detail?',
                        subtitle:
                            "It's been 3 months since your last wash. Your usual pro has an opening tomorrow morning.",
                        topRated: true,
                        ctaLabel: 'Book Now',
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
                  _NavItem(Icons.home_rounded, 'Home', false,
                      () => context.go('/home')),
                  _NavItem(Icons.auto_awesome_rounded, 'For You',
                      true, () {}),
                  _NavItem(Icons.search_rounded, 'Search', false,
                      () => context.go('/search')),
                  _NavItem(Icons.calendar_month_rounded,
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

class _AiSuggestionCard extends StatelessWidget {
  final String badge;
  final IconData badgeIcon;
  final Color badgeColor;
  final IconData bgIcon;
  final String title;
  final String subtitle;
  final int? avatars;
  final String? rating;
  final String? reviews;
  final bool topRated;
  final String ctaLabel;

  const _AiSuggestionCard({
    required this.badge,
    required this.badgeIcon,
    required this.badgeColor,
    required this.bgIcon,
    required this.title,
    required this.subtitle,
    this.avatars,
    this.rating,
    this.reviews,
    this.topRated = false,
    required this.ctaLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate700),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      badgeColor.withValues(alpha: 0.3),
                      AppColors.surfaceBg,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(bgIcon,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 80),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(badge,
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.slate400,
                        height: 1.5)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    if (avatars != null)
                      _avatarStack(avatars!)
                    else if (rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFF59E0B),
                              size: 18),
                          const SizedBox(width: 4),
                          Text(rating!,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(width: 4),
                          Text(reviews!,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.slate400)),
                        ],
                      )
                    else if (topRated)
                      Row(
                        children: [
                          Icon(Icons.verified_rounded,
                              color: AppColors.emerald600,
                              size: 18),
                          const SizedBox(width: 4),
                          Text('Top Rated Pro',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600)),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Text(ctaLabel,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarStack(int count) {
    final avatars = <Widget>[];
    for (int i = 0; i < 2; i++) {
      avatars.add(
        Container(
          width: 32,
          height: 32,
          margin: EdgeInsets.only(left: i * 22.0),
          decoration: BoxDecoration(
            color: i == 0
                ? AppColors.emerald600.withValues(alpha: 0.3)
                : const Color(0xFFF59E0B).withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.cardBg, width: 2),
          ),
          child: Icon(Icons.person_rounded,
              color: Colors.white, size: 16),
        ),
      );
    }
    avatars.add(
      Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.only(left: 44),
        decoration: BoxDecoration(
          color: AppColors.slate700,
          shape: BoxShape.circle,
          border:
              Border.all(color: AppColors.cardBg, width: 2),
        ),
        child: Center(
          child: Text('+12',
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ),
    );
    return SizedBox(
      width: 90,
      height: 32,
      child: Stack(children: avatars),
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
