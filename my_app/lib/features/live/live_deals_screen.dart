import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class LiveDealsScreen extends ConsumerWidget {
  const LiveDealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: live stream canvas
          CustomPaint(painter: _StreamBgPainter()),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          // Progress bar at top
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.emerald600,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emerald600.withValues(alpha: 0.8),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: 44,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      Text(ref.tr('st_live_deals'),
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.search_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 16),
                      Icon(Icons.more_vert_rounded, color: Colors.white, size: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Top chips
          Positioned(
            top: 100,
            left: 16,
            child: Row(
              children: [
                // LIVE badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('LIVE',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.0)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.visibility_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text('1.2k',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right sidebar interactions
          Positioned(
            right: 16,
            bottom: 180,
            child: Column(
              children: [
                _SideAction(
                    icon: Icons.favorite_rounded,
                    count: '12.4k',
                    color: Colors.red),
                const SizedBox(height: 24),
                _SideAction(
                    icon: Icons.chat_bubble_rounded,
                    count: '856',
                    color: Colors.white),
                const SizedBox(height: 24),
                _SideAction(
                    icon: Icons.share_rounded,
                    count: 'Share',
                    color: Colors.white),
              ],
            ),
          ),
          // Bottom content
          Positioned(
            bottom: 100,
            left: 16,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor profile
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.emerald600, width: 2),
                      ),
                      child: Icon(Icons.person_rounded,
                          color: AppColors.slate400, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Okafor's Electronics",
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              const SizedBox(width: 4),
                              Icon(Icons.verified_rounded,
                                  color: AppColors.emerald600, size: 16),
                            ],
                          ),
                          Text('Trusted Vendor • Asaba',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.emerald600
                                      .withValues(alpha: 0.9))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Follow',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    'Flash Sale! Get the latest wireless earbuds at 30% off. Limited stock remaining for our Asaba customers. 🎧✨',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5)),
                const SizedBox(height: 14),
                // Quick buy card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.headphones_rounded,
                            color: AppColors.emerald600, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Flash Deal',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.white
                                        .withValues(alpha: 0.7))),
                            Text('Wireless Beats Pro',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            Text('₦24,500',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.emerald600)),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/cart'),
                        icon: const Icon(Icons.shopping_cart_rounded,
                            color: Colors.white, size: 14),
                        label: Text('Quick Buy',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ticker
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            height: 36,
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _tickerItem('Obinna just bought 5kg Rice!'),
                      const SizedBox(width: 32),
                      _tickerItem('Chioma just ordered Suya!'),
                      const SizedBox(width: 32),
                      _tickerItem('Emeka is viewing this item'),
                      const SizedBox(width: 32),
                      _tickerItem('Adaeze just added to cart'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg.withValues(alpha: 0.95),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(Icons.home_rounded, 'Home', false,
                      () => context.go('/home')),
                  _NavItem(Icons.live_tv_rounded, 'Live', true, () {}),
                  _NavItem(Icons.explore_rounded, 'Discover', false, () {}),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _NavItem(Icons.shopping_cart_rounded, 'Orders', false,
                          () => context.go('/cart')),
                      Positioned(
                        top: -2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.emerald600,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _NavItem(Icons.person_rounded, 'Profile', false,
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

class _SideAction extends StatelessWidget {
  final IconData icon;
  final String count;
  final Color color;
  const _SideAction(
      {required this.icon, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 4),
        Text(count,
            style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}

Widget _tickerItem(String text) {
  return Row(
    children: [
      Icon(Icons.shopping_bag_rounded, color: const Color(0xFF059669), size: 14),
      const SizedBox(width: 6),
      Text(text,
          style: GoogleFonts.inter(
              fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
    ],
  );
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

class _StreamBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0A1A12)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);
    final g = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(i * size.width / 8 + 2, j * size.height / 12 + 2,
                size.width / 8 - 4, size.height / 12 - 4),
            const Radius.circular(4),
          ),
          g,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_StreamBgPainter o) => false;
}
