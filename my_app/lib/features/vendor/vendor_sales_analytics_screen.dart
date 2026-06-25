import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class VendorSalesAnalyticsScreen extends ConsumerWidget {
  const VendorSalesAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.emerald600, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ref.tr('st_vendor_analytics'),
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            Text('Asaba • MartoraX Vendor',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.emerald600.withValues(alpha: 0.8))),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.emerald600.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.emerald600.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded,
                    color: AppColors.emerald600, size: 14),
                const SizedBox(width: 4),
                Text('7 DAYS',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            // Revenue chart card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Revenue Overview',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.6))),
                    const SizedBox(height: 4),
                    Text('₦1,250,000',
                        style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.trending_up_rounded,
                            color: AppColors.emerald600, size: 16),
                        const SizedBox(width: 4),
                        Text('+12.4%',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.emerald600)),
                        Text(' vs last week',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.4))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 120,
                      child: CustomPaint(
                        painter: _ChartPainter(),
                        size: const Size(double.infinity, 120),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                          .map((d) => Text(d,
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  letterSpacing: 0.5)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Stats grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.shopping_bag_rounded,
                      label: 'ORDERS',
                      value: '342',
                      change: '+5%',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.groups_rounded,
                      label: 'REPEAT RATE',
                      value: '24%',
                      change: '+2%',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Sales by market
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sales by Market',
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('VIEW MAP',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald600,
                          letterSpacing: 0.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    _marketBar('Ogbeogonogo Market', '₦620k', 0.75, 1.0),
                    const SizedBox(height: 16),
                    _marketBar('Canning Market', '₦410k', 0.50, 0.6),
                    const SizedBox(height: 16),
                    _marketBar('Cable Point', '₦220k', 0.25, 0.3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Top selling products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Selling Products',
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('UNITS SOLD',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 0.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ProductRow(
                    name: 'Pure Groundnut Oil (5L)',
                    unitsSold: '92 units sold',
                    revenue: '₦450,000',
                    icon: Icons.water_drop_rounded,
                  ),
                  const SizedBox(height: 12),
                  _ProductRow(
                    name: 'Parboiled Rice (25kg)',
                    unitsSold: '64 units sold',
                    revenue: '₦320,000',
                    icon: Icons.grass_rounded,
                  ),
                  const SizedBox(height: 12),
                  _ProductRow(
                    name: 'Refined Table Salt',
                    unitsSold: '140 units sold',
                    revenue: '₦185,000',
                    icon: Icons.science_rounded,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String change;
  const _StatCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.change});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.emerald600, size: 22),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.6),
                  letterSpacing: 1.0)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text(change,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emerald600)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _marketBar(String name, String amount, double fraction, double opacity) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8))),
          Text(amount,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ],
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: fraction,
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.emerald600.withValues(alpha: opacity)),
          minHeight: 8,
        ),
      ),
    ],
  );
}

class _ProductRow extends StatelessWidget {
  final String name;
  final String unitsSold;
  final String revenue;
  final IconData icon;
  const _ProductRow(
      {required this.name,
      required this.unitsSold,
      required this.revenue,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.emerald600, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text(unitsSold,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.emerald600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(revenue,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text('REVENUE',
                  style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 1.0)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF059669).withValues(alpha: 0.3),
          const Color(0xFF059669).withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.14, size.height * 0.73),
      Offset(size.width * 0.28, size.height * 0.93),
      Offset(size.width * 0.43, size.height * 0.53),
      Offset(size.width * 0.57, size.height * 0.13),
      Offset(size.width * 0.71, size.height * 0.40),
      Offset(size.width * 0.85, size.height * 0.33),
      Offset(size.width, size.height * 0.07),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp = Offset(
          (points[i].dx + points[i + 1].dx) / 2, points[i].dy);
      final cp2 = Offset(
          (points[i].dx + points[i + 1].dx) / 2, points[i + 1].dy);
      path.cubicTo(
          cp.dx, cp.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(_ChartPainter o) => false;
}

class _BottomNav extends StatelessWidget {
  final BuildContext ctx;
  const _BottomNav(this.ctx);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.space_dashboard_rounded, 'Dashboard', true,
              () => ctx.go('/vendor/dashboard')),
          _NavItem(Icons.inventory_2_rounded, 'Inventory', false,
              () => ctx.go('/vendor/inventory')),
          _NavItem(Icons.receipt_long_rounded, 'Orders', false,
              () => ctx.go('/vendor/orders')),
          _NavItem(Icons.account_circle_rounded, 'Profile', false, () {}),
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
              size: 22),
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
