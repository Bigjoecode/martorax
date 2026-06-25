import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ServiceDiscoveryScreen extends ConsumerStatefulWidget {
  const ServiceDiscoveryScreen({super.key});

  @override
  ConsumerState<ServiceDiscoveryScreen> createState() =>
      _ServiceDiscoveryScreenState();
}

class _ServiceDiscoveryScreenState extends ConsumerState<ServiceDiscoveryScreen> {
  int _categoryIdx = 0;

  static const _categories = [
    ('All', null),
    ('Plumbers', Icons.plumbing_rounded),
    ('Tailors', Icons.content_cut_rounded),
    ('Electricians', Icons.bolt_rounded),
    ('Makeup', Icons.face_rounded),
  ];

  static const _estimates = [
    ('AC Repair', '₦5k - 15k'),
    ('Tailoring', '₦3k - 10k'),
    ('Plumbing', '₦4k - 12k'),
  ];

  static const _providers = [
    _Provider("Chioma's Stitches", 'Master Tailor', '4.9', '1.2km away',
        '₦4,500', Icons.content_cut_rounded),
    _Provider('Obi Electricals', 'Electrician', '4.8', '2.4km away',
        '₦6,000', Icons.electrical_services_rounded),
    _Provider('Dave the Plumber', 'Plumbing expert', '5.0', '0.8km away',
        '₦3,000', Icons.plumbing_rounded),
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
                pinned: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: AppColors.emerald600, size: 22),
                    const SizedBox(width: 6),
                    Text('Asaba, Delta State',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 20),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
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
                  ),
                ],
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 8, 16, 12),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(Icons.search_rounded,
                            color: AppColors.slate400, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.inter(
                                fontSize: 14, color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Find a plumber, tailor...',
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.slate400),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Category chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (_, i) {
                      final (label, icon) = _categories[i];
                      final selected = _categoryIdx == i;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _categoryIdx = i),
                        child: Container(
                          margin:
                              const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          height: 36,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.emerald600
                                : AppColors.cardBg,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              if (icon != null) ...[
                                Icon(icon,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.slate400,
                                    size: 16),
                                const SizedBox(width: 6),
                              ],
                              Center(
                                child: Text(label,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: selected
                                            ? Colors.white
                                            : Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 20, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's Estimates",
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _estimates.length,
                          itemBuilder: (_, i) {
                            final (name, range) = _estimates[i];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(
                                  right: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.emerald600
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppColors.emerald600
                                        .withValues(alpha: 0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(name.toUpperCase(),
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: AppColors
                                              .emerald600,
                                          letterSpacing: 1.0)),
                                  const Spacer(),
                                  Text(range,
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: -0.3)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ref.tr('st_service_discovery'),
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text('See All',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.emerald600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._providers.map((p) => _ProviderCard(
                          provider: p,
                          onBook: () =>
                              context.go('/service/booking'),
                          onTap: () =>
                              context.go('/provider/public-profile'))),
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
              color: AppColors.darkBg.withValues(alpha: 0.9),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom:
                    MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.slate700)),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(Icons.home_rounded, 'Home', true,
                      () => context.go('/home')),
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

class _Provider {
  final String name;
  final String role;
  final String rating;
  final String distance;
  final String price;
  final IconData icon;
  const _Provider(this.name, this.role, this.rating, this.distance,
      this.price, this.icon);
}

class _ProviderCard extends StatelessWidget {
  final _Provider provider;
  final VoidCallback onBook;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.provider,
    required this.onBook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate700),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.emerald600
                            .withValues(alpha: 0.3),
                        width: 2),
                  ),
                  child: Icon(provider.icon,
                      color: AppColors.emerald600, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(provider.name,
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24)
                                  .withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded,
                                    color:
                                        const Color(0xFFFBBF24),
                                    size: 14),
                                const SizedBox(width: 2),
                                Text(provider.rating,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: const Color(
                                            0xFFFBBF24))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(provider.role,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.slate400)),
                          const SizedBox(width: 6),
                          Icon(Icons.verified_rounded,
                              color: AppColors.emerald600,
                              size: 14),
                          const SizedBox(width: 2),
                          Text('VERIFIED PRO',
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.emerald600,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.near_me_rounded,
                                  color: AppColors.slate400,
                                  size: 14),
                              const SizedBox(width: 4),
                              Text(provider.distance,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color:
                                          AppColors.slate400)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text('STARTING FROM',
                                  style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight:
                                          FontWeight.w800,
                                      color: AppColors.slate400,
                                      letterSpacing: 1.0)),
                              Text(provider.price,
                                  style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.w700,
                                      color: AppColors
                                          .emerald600)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.go('/provider/chat'),
                      icon: const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 16),
                      label: Text('Message',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: onBook,
                      icon: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 16),
                      label: Text('Book Now',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20)),
                      ),
                    ),
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
              size: 24),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight:
                      active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
