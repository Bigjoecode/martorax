import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/martorax_map.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showMap = false;
  String _activeFilterKey = 'search_filter_nearest';

  // (stable key, ref.tr key) — UI label comes from ref.tr
  static const _filterKeys = [
    'search_filter_nearest',
    'search_filter_open',
    'search_filter_cheap',
    'search_filter_trusted',
  ];
  static const _tabKeys = [
    'search_tab_vendors',
    'search_tab_services',
    'search_tab_markets',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabKeys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = _filterKeys.map((k) => ref.tr(k)).toList();
    final tabs = _tabKeys.map((k) => ref.tr(k)).toList();
    final activeFilter = ref.tr(_activeFilterKey);
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(onBack: () => context.go('/home')),
            _FilterChips(
              filters: filters,
              active: activeFilter,
              onSelect: (label) {
                final idx = filters.indexOf(label);
                if (idx >= 0) {
                  setState(() => _activeFilterKey = _filterKeys[idx]);
                }
              },
            ),
            _TabRow(
              controller: _tabController,
              tabs: tabs,
              showMap: _showMap,
              onToggleMap: () => setState(() => _showMap = !_showMap),
            ),
            Expanded(
              child: _showMap
                  ? const _MapPlaceholder()
                  : TabBarView(
                      controller: _tabController,
                      children: tabs
                          .map((_) => const _VendorList())
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends ConsumerWidget {
  final VoidCallback onBack;
  const _SearchHeader({required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate700),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search_rounded,
                      color: AppColors.slate400, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: ref.tr('search_placeholder'),
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.slate400),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.emerald600.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mic_rounded,
                        color: AppColors.emerald600, size: 18),
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

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final String active;
  final ValueChanged<String> onSelect;
  const _FilterChips(
      {required this.filters,
      required this.active,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final isActive = f == active;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.emerald600
                    : AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.emerald600
                      : AppColors.slate700,
                ),
              ),
              child: Text(f,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? Colors.white
                          : AppColors.slate400)),
            ),
          );
        },
      ),
    );
  }
}

class _TabRow extends ConsumerWidget {
  final TabController controller;
  final List<String> tabs;
  final bool showMap;
  final VoidCallback onToggleMap;
  const _TabRow(
      {required this.controller,
      required this.tabs,
      required this.showMap,
      required this.onToggleMap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: controller,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.emerald600,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.slate400,
              labelStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  GoogleFonts.inter(fontSize: 14),
              tabs: tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          GestureDetector(
            onTap: onToggleMap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: showMap
                    ? AppColors.emerald600.withValues(alpha: 0.15)
                    : AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: showMap
                      ? AppColors.emerald600
                      : AppColors.slate700,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    showMap ? Icons.list_rounded : Icons.map_rounded,
                    color: showMap
                        ? AppColors.emerald600
                        : AppColors.slate400,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(showMap ? ref.tr('search_list') : ref.tr('search_map'),
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: showMap
                              ? AppColors.emerald600
                              : AppColors.slate400)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorList extends StatelessWidget {
  const _VendorList();

  static const _vendors = [
    _VendorData(
      name: "Chidi's Electronics Hub",
      location: 'Ogbogonogo Road, Asaba',
      rating: 4.9,
      tag: 'PRO',
      tagColor: AppColors.blue500,
      isLive: true,
    ),
    _VendorData(
      name: 'Elite Stitches Asaba',
      location: 'Nnebisi Road, Asaba',
      rating: 4.7,
      tag: 'TRUSTED',
      tagColor: AppColors.amber500,
      isLive: false,
    ),
    _VendorData(
      name: 'Mama B Fresh Veggies',
      location: 'Ogbogonogo Market',
      rating: 4.5,
      tag: 'BARGAIN',
      tagColor: AppColors.emerald600,
      isLive: false,
    ),
    _VendorData(
      name: 'Uche Provisions Store',
      location: 'Cable Point, Asaba',
      rating: 4.3,
      tag: 'TRUSTED',
      tagColor: AppColors.amber500,
      isLive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _vendors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _VendorCard(vendor: _vendors[i]),
    );
  }
}

class _VendorData {
  final String name;
  final String location;
  final double rating;
  final String tag;
  final Color tagColor;
  final bool isLive;
  const _VendorData({
    required this.name,
    required this.location,
    required this.rating,
    required this.tag,
    required this.tagColor,
    required this.isLive,
  });
}

class _VendorCard extends ConsumerWidget {
  final _VendorData vendor;
  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.go('/product'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.slate700),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: AppColors.emerald600, size: 30),
                ),
                if (vendor.isLive)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: AppColors.red500, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(vendor.name,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: vendor.tagColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(vendor.tag,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: vendor.tagColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.slate400, size: 12),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(vendor.location,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.slate400),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.amber500, size: 14),
                      const SizedBox(width: 3),
                      Text('${vendor.rating}',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(ref.tr('search_visit_store'),
                            style: GoogleFonts.inter(
                                fontSize: 12,
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
      ),
    );
  }
}

class _MapPlaceholder extends ConsumerWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: const MartoraxMap(initialZoom: 13.5),
      ),
    );
  }
}
