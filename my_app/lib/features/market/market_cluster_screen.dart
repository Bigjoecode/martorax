import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class MarketClusterScreen extends StatelessWidget {
  const MarketClusterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ogbogonogo Market',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.emerald600,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text('Asaba, Nigeria',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald600)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.emerald700.withValues(alpha: 0.4),
                          AppColors.darkBg,
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomPaint(painter: _MarketPainter()),
                    ),
                  ),
                  // LIVE badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sensors_rounded,
                              color: AppColors.darkBg, size: 14),
                          const SizedBox(width: 4),
                          Text('LIVE NOW',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkBg)),
                        ],
                      ),
                    ),
                  ),
                  // Caption
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Morning Rush',
                            style: GoogleFonts.manrope(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        Text(
                            'Peak shopping hours: 8:00 AM - 12:00 PM',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price Board
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Price Board",
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('Updated 10m ago',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emerald600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _PriceCard(
                      commodity: 'Tomatoes',
                      price: '₦2,500',
                      change: '+12%',
                      up: true),
                  _PriceCard(
                      commodity: 'Garri (Paint)',
                      price: '₦1,800',
                      change: '-5%',
                      up: false),
                  _PriceCard(
                      commodity: 'Yam (Large)',
                      price: '₦4,200',
                      change: 'Stable',
                      up: null),
                  _PriceCard(
                      commodity: 'Palm Oil (L)',
                      price: '₦1,200',
                      change: '+3%',
                      up: true),
                ],
              ),
            ),

            // What's Trending
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
              child: Text("What's Trending",
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _TrendingCard(
                      name: 'Fresh Tomatoes',
                      price: '₦2,500/paint',
                      icon: Icons.eco_rounded),
                  _TrendingCard(
                      name: 'Ubiaja Yam',
                      price: '₦4,200/tuber',
                      icon: Icons.grass_rounded),
                  _TrendingCard(
                      name: 'Pure Red Oil',
                      price: '₦1,200/litre',
                      icon: Icons.water_drop_rounded),
                ],
              ),
            ),

            // Top Stalls
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('Top Trusted Stalls',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _StallCard(
                    name: 'Mama Chinedu Provisions',
                    category: 'Wholesale Oils & Grains',
                    rating: '4.9',
                    badge: 'Fast Delivery',
                  ),
                  const SizedBox(height: 12),
                  _StallCard(
                    name: 'Ogbogonogo Butchers',
                    category: 'Premium Beef & Poultry',
                    rating: '4.7',
                    badge: 'Certified Health',
                  ),
                  const SizedBox(height: 12),
                  _StallCard(
                    name: 'Aunty Joy Textiles',
                    category: 'Quality Ankara & Lace',
                    rating: '4.8',
                    badge: 'Bulk Orders',
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

class _PriceCard extends StatelessWidget {
  final String commodity;
  final String price;
  final String change;
  final bool? up;
  const _PriceCard(
      {required this.commodity,
      required this.price,
      required this.change,
      required this.up});

  @override
  Widget build(BuildContext context) {
    final changeColor = up == null
        ? AppColors.slate400
        : up!
            ? AppColors.emerald600
            : Colors.red;

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(commodity.toUpperCase(),
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.6),
                  letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(price,
              style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Row(
            children: [
              if (up != null)
                Icon(
                  up! ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: changeColor,
                  size: 13,
                ),
              Text(change,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: changeColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final String name;
  final String price;
  final IconData icon;
  const _TrendingCard(
      {required this.name, required this.price, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.emerald700.withValues(alpha: 0.3),
                    AppColors.cardBg,
                  ],
                ),
              ),
              child: Center(
                  child: Icon(icon, color: AppColors.emerald600, size: 48)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text(price,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.emerald600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StallCard extends StatelessWidget {
  final String name;
  final String category;
  final String rating;
  final String badge;
  const _StallCard(
      {required this.name,
      required this.category,
      required this.rating,
      required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.storefront_rounded,
                color: AppColors.emerald600, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(name,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                    Icon(Icons.verified_rounded,
                        color: AppColors.amber500, size: 16),
                  ],
                ),
                Text(category,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppColors.amber500, size: 14),
                    const SizedBox(width: 2),
                    Text(rating,
                        style: GoogleFonts.inter(
                            fontSize: 12, fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(badge,
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.8))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.emerald600.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chevron_right_rounded,
                color: AppColors.emerald600, size: 20),
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
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 28),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.95),
        border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.home_rounded, 'Home', true, () => ctx.go('/home')),
          _NavItem(Icons.search_rounded, 'Search', false,
              () => ctx.go('/search')),
          _NavItem(Icons.shopping_bag_rounded, 'Orders', false, () {}),
          _NavItem(Icons.calendar_today_rounded, 'Bookings', false, () {}),
          _NavItem(Icons.person_rounded, 'Profile', false, () {}),
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
              size: 24),
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

class _MarketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1A3528)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, p);
    final g = Paint()
      ..color = const Color(0xFF0D5C3A).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 4; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
                i * size.width / 8 + 4, j * size.height / 4 + 4,
                size.width / 8 - 8, size.height / 4 - 8),
            const Radius.circular(4),
          ),
          g,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_MarketPainter o) => false;
}
