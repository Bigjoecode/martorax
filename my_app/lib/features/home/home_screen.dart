import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/localization/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount =
        ref.watch(cartProvider.select((items) => items.fold<int>(0, (s, i) => s + i.quantity)));
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _TopBar(
                cartCount: cartCount,
                locationLabel: ref.tr('location_label'),
                locationValue: ref.tr('location_value'),
                onCart: () => context.go('/cart'),
                onNotifications: () => context.go('/notifications'),
              ),
              const SizedBox(height: 16),
              _SearchBar(hint: ref.tr('search_placeholder')),
              const SizedBox(height: 24),
              _SectionHeader(
                  title: ref.tr('market_clusters'),
                  seeAllLabel: ref.tr('see_all'),
                  onSeeAll: () => context.go('/market/hubs')),
              const SizedBox(height: 12),
              const _MarketClustersCarousel(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => context.go('/market/trends'),
                child: _PriceBoardCard(
                  title: ref.tr('market_price_board'),
                  updated: ref.tr('updated_today'),
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(
                  title: ref.tr('quick_services'),
                  seeAllLabel: ref.tr('see_all'),
                  onSeeAll: () => context.go('/services/map')),
              const SizedBox(height: 12),
              const _QuickServices(),
              const SizedBox(height: 20),
              _HotDealsHeader(title: ref.tr('hot_deals'), liveLabel: ref.tr('live')),
              const SizedBox(height: 12),
              const _HotDealsList(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int cartCount;
  final String locationLabel;
  final String locationValue;
  final VoidCallback onCart;
  final VoidCallback onNotifications;
  const _TopBar({
    required this.cartCount,
    required this.locationLabel,
    required this.locationValue,
    required this.onCart,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: AppColors.emerald600, size: 18),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locationLabel,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.slate400,
                          letterSpacing: 1)),
                  Text(locationValue,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.slate400, size: 18),
            ],
          ),
        ),
        _IconBtn(icon: Icons.auto_awesome_rounded, onTap: () => context.go('/ai/feed')),
        const SizedBox(width: 8),
        _IconBtn(
          icon: Icons.shopping_cart_outlined,
          onTap: onCart,
          badgeCount: cartCount,
        ),
        const SizedBox(width: 8),
        _IconBtn(icon: Icons.notifications_outlined, onTap: onNotifications),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;
  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.slate400, size: 20),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.darkBg, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  const _SearchBar({required this.hint});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.slate700),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: AppColors.slate400, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(hint,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.slate400)),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.mic_rounded,
                  color: AppColors.emerald600, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String seeAllLabel;
  final VoidCallback? onSeeAll;
  const _SectionHeader({
    required this.title,
    required this.seeAllLabel,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(seeAllLabel,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.emerald600,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

class _MarketClustersCarousel extends StatelessWidget {
  const _MarketClustersCarousel();

  static const _markets = [
    ('Ogbogonogo Market', 'Central Area, Asaba', true),
    ('Coke Market', '9 Ago, Asaba', false),
    ('Abraka Market', 'Abraka, Delta', false),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _markets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final (name, location, isLive) = _markets[i];
          return GestureDetector(
            onTap: () => context.go(i == 0 ? '/market/ogbogonogo' : '/market/hubs'),
            child: Container(
            width: 200,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.emerald700.withValues(alpha: 0.4),
                  AppColors.cardBg
                ],
              ),
              border: Border.all(color: AppColors.slate700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLive)
                  _LiveBadge()
                else
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.emerald600.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.storefront_rounded,
                        color: AppColors.emerald600, size: 16),
                  ),
                const Spacer(),
                Text(name,
                    style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.slate400, size: 12),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(location,
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.slate400),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  final String label;
  const _LiveBadge({this.label = 'LIVE'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.red500.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.red500.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  color: AppColors.red500, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.red500)),
        ],
      ),
    );
  }
}

class _PriceBoardCard extends StatelessWidget {
  final String title;
  final String updated;
  const _PriceBoardCard({required this.title, required this.updated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.amber500.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bar_chart_rounded,
                        color: AppColors.amber500, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3)),
                ],
              ),
              Text(updated,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.slate400)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                  child: _PriceItem(
                      name: 'Garri (Paint)', price: '₦2,500', isUp: true)),
              Container(width: 1, height: 40, color: AppColors.slate700),
              const Expanded(
                  child: _PriceItem(
                      name: 'Tomatoes', price: '₦1,200', isUp: false)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceItem extends StatelessWidget {
  final String name;
  final String price;
  final bool isUp;
  const _PriceItem(
      {required this.name, required this.price, required this.isUp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
                  GoogleFonts.inter(fontSize: 12, color: AppColors.slate400)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(price,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(width: 4),
              Icon(
                isUp
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: isUp ? AppColors.orange500 : AppColors.green500,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickServices extends StatelessWidget {
  const _QuickServices();

  static const _services = [
    (Icons.restaurant_rounded, 'FOOD', '/search'),
    (Icons.build_rounded, 'SERVICES', '/services/map'),
    (Icons.checkroom_rounded, 'FASHION', '/search'),
    (Icons.local_grocery_store_rounded, 'GROCERY', '/market/ogbogonogo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _services.map((s) {
        final (icon, label, route) = s;
        return GestureDetector(
          onTap: () => context.go(route),
          child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.slate700),
              ),
              child: Icon(icon, color: AppColors.emerald600, size: 28),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate400,
                    letterSpacing: 0.4)),
          ],
          ),
        );
      }).toList(),
    );
  }
}

class _HotDealsHeader extends StatelessWidget {
  final String title;
  final String liveLabel;
  const _HotDealsHeader({required this.title, required this.liveLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        const SizedBox(width: 8),
        _LiveBadge(label: liveLabel),
      ],
    );
  }
}

class _HotDealsList extends StatelessWidget {
  const _HotDealsList();

  static const _deals = [
    ('Fresh Tomatoes (Basket)', '₦4,500', '₦6,000', 'Ogbogonogo Farms', '25%'),
    ('Ankara Fabric (6yds)', '₦3,800', '₦5,500', 'Mama Chidi Fabrics', '31%'),
    ('Palm Oil (Gallon)', '₦2,200', '₦3,000', 'Uche Oil Depot', '27%'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _deals.map((deal) {
        final (name, price, oldPrice, vendor, discount) = deal;
        return GestureDetector(
          onTap: () => context.go('/product'),
          child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.slate700),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.emerald700.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_offer_rounded,
                    color: AppColors.emerald600, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(vendor,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.slate400)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(price,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        const SizedBox(width: 6),
                        Text(oldPrice,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.slate400,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.amber500.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('-$discount',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.amber500)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.emerald600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
          ),
        );
      }).toList(),
    );
  }
}

