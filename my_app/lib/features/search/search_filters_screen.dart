import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SearchFiltersScreen extends StatefulWidget {
  const SearchFiltersScreen({super.key});

  @override
  State<SearchFiltersScreen> createState() =>
      _SearchFiltersScreenState();
}

class _SearchFiltersScreenState extends State<SearchFiltersScreen> {
  int _tabIdx = 0;
  int _filterIdx = 0;
  bool _isList = true;
  static const _tabs = ['Vendors', 'Products', 'Services', 'Markets'];
  static const _filters = [
    'Filters',
    'Nearest',
    'Open Now',
    'Trusted',
    'Bargain'
  ];

  static const _vendors = [
    _Vendor(
      name: "Chidi's Electronics Hub",
      location: 'Ogbogonogo Market, Asaba',
      rating: '4.9',
      distance: '1.2km away • Active 5m ago',
      live: true,
      pro: true,
      trusted: true,
      cta: 'Visit Store',
      icon: Icons.electrical_services_rounded,
    ),
    _Vendor(
      name: 'Elite Stitches Asaba',
      location: 'Nnebisi Road, Asaba',
      rating: '4.7',
      distance: '0.8km away • Active now',
      pro: true,
      cta: 'Message',
      icon: Icons.content_cut_rounded,
    ),
    _Vendor(
      name: 'Mama B Fresh Veggies',
      location: 'Cable Point, Asaba',
      rating: '4.5',
      distance: '2.5km away • Open now',
      trusted: true,
      cta: 'Order Now',
      icon: Icons.local_florist_rounded,
    ),
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
                    AppColors.darkBg.withValues(alpha: 0.9),
                pinned: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 12),
                              child: Icon(Icons.search_rounded,
                                  color: AppColors.slate400,
                                  size: 20),
                            ),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search in Asaba...',
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.slate400),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.dark_mode_rounded,
                          color: AppColors.slate400, size: 20),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ToggleButton(
                            label: 'List',
                            active: _isList,
                            onTap: () =>
                                setState(() => _isList = true),
                          ),
                          _ToggleButton(
                            label: 'Map',
                            active: !_isList,
                            onTap: () =>
                                setState(() => _isList = false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Tabs
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: AppColors.slate700)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children:
                          _tabs.asMap().entries.map((e) {
                        final i = e.key;
                        final selected = _tabIdx == i;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _tabIdx = i),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 32, bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  color: selected
                                      ? AppColors.emerald600
                                      : Colors.transparent,
                                  width: 2,
                                )),
                              ),
                              padding: const EdgeInsets.only(
                                  bottom: 8),
                              child: Text(e.value,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: selected
                                          ? AppColors.emerald600
                                          : AppColors.slate400)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Filter chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _filters.length,
                    itemBuilder: (_, i) {
                      final selected = _filterIdx == i;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _filterIdx = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
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
                              if (i == 0) ...[
                                Icon(Icons.tune_rounded,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.slate400,
                                    size: 14),
                                const SizedBox(width: 6),
                              ],
                              Center(
                                child: Text(_filters[i],
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w500,
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
              // Vendor list
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    children: _vendors
                        .map((v) => _VendorCard(vendor: v))
                        .toList(),
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
              color: AppColors.darkBg,
              padding: EdgeInsets.only(
                left: 32,
                right: 32,
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
                  _NavItem(Icons.home_rounded, 'Home', false,
                      () => context.go('/home')),
                  _NavItem(Icons.explore_rounded, 'Discover',
                      true, () {}),
                  _NavItem(Icons.local_mall_rounded, 'Bookings',
                      false, () => context.go('/bookings')),
                  _NavItem(Icons.person_outline_rounded,
                      'Profile', false,
                      () => context.go('/profile')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.surfaceBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active
                    ? Colors.white
                    : AppColors.slate400)),
      ),
    );
  }
}

class _Vendor {
  final String name;
  final String location;
  final String rating;
  final String distance;
  final bool live;
  final bool pro;
  final bool trusted;
  final String cta;
  final IconData icon;
  const _Vendor({
    required this.name,
    required this.location,
    required this.rating,
    required this.distance,
    this.live = false,
    this.pro = false,
    this.trusted = false,
    required this.cta,
    required this.icon,
  });
}

class _VendorCard extends StatelessWidget {
  final _Vendor vendor;
  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.slate700.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
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
                      AppColors.emerald600.withValues(alpha: 0.2),
                      AppColors.surfaceBg,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(vendor.icon,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 80),
                ),
              ),
              if (vendor.pro || vendor.trusted)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      if (vendor.pro)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600
                                .withValues(alpha: 0.9),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text('PRO',
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.0)),
                        ),
                      if (vendor.pro && vendor.trusted)
                        const SizedBox(width: 6),
                      if (vendor.trusted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_rounded,
                                  color: Colors.black, size: 12),
                              const SizedBox(width: 4),
                              Text('TRUSTED STALL',
                                  style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                      letterSpacing: 1.0)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              if (vendor.live)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('LIVE',
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(vendor.name,
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: AppColors.slate400,
                                  size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(vendor.location,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: AppColors.slate400)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFBBF24),
                              size: 14),
                          const SizedBox(width: 2),
                          Text(vendor.rating,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                    height: 1,
                    color: AppColors.slate700
                        .withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_rounded,
                              color: AppColors.slate400, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(vendor.distance,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.slate400)),
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
                            horizontal: 16, vertical: 10),
                      ),
                      child: Text(vendor.cta,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
                  fontWeight: active
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
