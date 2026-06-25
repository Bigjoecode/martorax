import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class MarketHubsScreen extends ConsumerWidget {
  const MarketHubsScreen({super.key});

  static const _prices = [
    _Price(Icons.grass_rounded, 'Rice (50kg)', 'Local Long Grain',
        '₦55,000', '+2.5%', true),
    _Price(Icons.breakfast_dining_rounded, 'Garri (Paint)', 'White Fine',
        '₦2,800', '-1.2%', false),
    _Price(Icons.eco_rounded, 'Tomatoes', 'Large Basket',
        '₦42,000', '+5.8%', true),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.hub_rounded, color: AppColors.emerald600, size: 28),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MartoraX',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            Text(ref.tr('st_market_hubs').toUpperCase(),
                style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppColors.slate400,
                    letterSpacing: 2.0)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 24),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.slate700),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search_rounded,
                        color: AppColors.slate400, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search markets or commodities',
                          hintStyle: GoogleFonts.inter(
                              fontSize: 14, color: AppColors.slate400),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(Icons.tune_rounded,
                          color: AppColors.slate400, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Major markets header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Major Markets',
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5)),
                  Text('See All',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emerald600)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Market cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _MarketCard(
                    name: 'Ogbogonogo Market',
                    location: 'Asaba, Delta State',
                    liveCount: '12 Live',
                    onTap: () => context.go('/market/ogbogonogo'),
                  ),
                  const SizedBox(height: 12),
                  _MarketCard(
                    name: 'Main Market',
                    location: 'Onitsha, Anambra',
                    liveCount: '8 Live',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Daily price board
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daily Price Board',
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emerald600.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Updated 2m ago',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald600,
                            letterSpacing: 0.3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBg.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text('COMMODITY',
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate400,
                                    letterSpacing: 1.0)),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text('PRICE (₦)',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate400,
                                    letterSpacing: 1.0)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('TREND',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate400,
                                    letterSpacing: 1.0)),
                          ),
                        ],
                      ),
                    ),
                    // Price rows
                    ..._prices.asMap().entries.map((e) {
                      final p = e.value;
                      final isLast = e.key == _prices.length - 1;
                      return _PriceRow(price: p, isLast: isLast);
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Market activity banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MARKET ACTIVITY',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 1.0)),
                        const SizedBox(height: 4),
                        Text('2.4k Trades',
                            style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                    Container(
                      width: 96,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(painter: _SparklinePainter()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _Price {
  final IconData icon;
  final String name;
  final String sub;
  final String price;
  final String change;
  final bool up;
  const _Price(this.icon, this.name, this.sub, this.price, this.change,
      this.up);
}

class _MarketCard extends StatelessWidget {
  final String name;
  final String location;
  final String liveCount;
  final VoidCallback onTap;
  const _MarketCard(
      {required this.name,
      required this.location,
      required this.liveCount,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.emerald700.withValues(alpha: 0.3),
                AppColors.darkBg,
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                CustomPaint(
                  painter: _MarketBgPainter(),
                  child: const SizedBox.expand(),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
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
                        const SizedBox(width: 6),
                        Text(liveCount,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: Colors.white60, size: 14),
                          const SizedBox(width: 4),
                          Text(location,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final _Price price;
  final bool isLast;
  const _PriceRow({required this.price, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final trendColor =
        price.up ? AppColors.amber500 : AppColors.emerald600;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: price.up
                            ? Colors.orange.withValues(alpha: 0.15)
                            : Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(price.icon,
                          color: price.up ? Colors.orange : Colors.red,
                          size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(price.name,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text(price.sub,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.slate400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(price.price,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trendColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            price.up
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: trendColor,
                            size: 13),
                        const SizedBox(width: 2),
                        Text(price.change.replaceAll('+', '').replaceAll('-', ''),
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: trendColor)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.05)),
      ],
    );
  }
}

class _MarketBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0D1B2A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);
    final g = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 4; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
                i * size.width / 6 + 4,
                j * size.height / 4 + 4,
                size.width / 6 - 8,
                size.height / 4 - 8),
            const Radius.circular(4),
          ),
          g,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_MarketBgPainter o) => false;
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final pts = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.4, size.height * 0.625),
      Offset(size.width * 0.6, size.height * 0.125),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width, size.height * 0.25),
    ];
    path.moveTo(pts[0].dx, pts[0].dy);
    for (final pt in pts.skip(1)) {
      path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_SparklinePainter o) => false;
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
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.home_rounded, 'Home', true, () => ctx.go('/home')),
          _NavItem(Icons.search_rounded, 'Search', false,
              () => ctx.go('/search')),
          _NavItem(
              Icons.calendar_today_rounded, 'Bookings', false, () {}),
          _NavItem(Icons.person_rounded, 'Profile', false,
              () => ctx.go('/profile')),
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
