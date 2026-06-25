import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          Column(
            children: [
              // Map area (top 55%)
              Expanded(
                flex: 55,
                child: Stack(
                  children: [
                    // Map background
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF1A2E3A),
                      child: CustomPaint(
                        painter: _CityMapPainter(),
                      ),
                    ),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.darkBg.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Rider marker
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.33,
                      top: MediaQuery.of(context).size.height * 0.55 * 0.45,
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.emerald600,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.emerald600.withValues(alpha: 0.6),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.electric_rickshaw_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.darkBg.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppColors.emerald600.withValues(alpha: 0.3)),
                            ),
                            child: Text('Chidi is here',
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),

                    // Destination marker
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.25,
                      bottom: MediaQuery.of(context).size.height * 0.55 * 0.25,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.emerald600, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8)
                          ],
                        ),
                        child: Icon(Icons.home_rounded,
                            color: AppColors.emerald600, size: 16),
                      ),
                    ),

                    // SOS button
                    Positioned(
                      bottom: 24,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3), width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.5),
                                blurRadius: 25,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.emergency_rounded,
                                  color: Colors.white, size: 24),
                              Text('SOS',
                                  style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom info panel
              Expanded(
                flex: 45,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    border: Border(
                        top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.05))),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 30,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.emerald600.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Rider info
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors.emerald600.withValues(
                                            alpha: 0.2),
                                        width: 2),
                                  ),
                                  child: Icon(Icons.person_rounded,
                                      color: AppColors.slate400, size: 32),
                                ),
                                Positioned(
                                  bottom: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.amber500,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('4.8',
                                            style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.darkBg)),
                                        Icon(Icons.star_rounded,
                                            color: AppColors.darkBg, size: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Chidi K.',
                                      style: GoogleFonts.inter(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                  Text('Yellow Keke • ASB-123-XY',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors.emerald600
                                              .withValues(alpha: 0.8))),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _ActionBtn(
                                    icon: Icons.call_rounded,
                                    onTap: () {}),
                                const SizedBox(width: 8),
                                _ActionBtn(
                                    icon: Icons.chat_bubble_rounded,
                                    onTap: () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 24),

                      // Mini timeline
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _TrackRow(
                              icon: Icons.check_rounded,
                              title: 'Order Picked up',
                              subtitle: '10:15 AM • Summit Road',
                              done: true,
                            ),
                            _TrackRow(
                              icon: Icons.local_shipping_rounded,
                              title: 'On the way',
                              subtitle: 'Approaching your location',
                              active: true,
                              badge: 'LIVE',
                            ),
                            _TrackRow(
                              icon: Icons.location_on_rounded,
                              title: 'Arriving',
                              subtitle: 'Estimated 10:30 AM',
                              last: true,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Share button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share_location_rounded,
                                color: Colors.white, size: 20),
                            label: Text('Share Trip Progress',
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald600,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Top nav overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _OverlayBtn(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => context.go('/order/status'),
                    ),
                    Column(
                      children: [
                        Text('Live Tracking',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.emerald600,
                                letterSpacing: 1.0)),
                        Text('Order #MX-72841',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                    _OverlayBtn(
                      icon: Icons.help_outline_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _OverlayBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.darkBg.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.emerald600.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.emerald600.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: AppColors.emerald600, size: 22),
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool done;
  final bool active;
  final String? badge;
  final bool last;

  const _TrackRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.done = false,
    this.active = false,
    this.badge,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: done
                    ? AppColors.emerald600.withValues(alpha: 0.2)
                    : active
                        ? AppColors.emerald600
                        : AppColors.surfaceBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: done || active ? AppColors.emerald600 : AppColors.slate700,
                ),
              ),
              child: Icon(icon,
                  color: done
                      ? AppColors.emerald600
                      : active
                          ? Colors.white
                          : AppColors.slate400,
                  size: 16),
            ),
            if (!last)
              Container(
                width: 2,
                height: 32,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: done
                    ? AppColors.emerald600.withValues(alpha: 0.5)
                    : AppColors.slate700.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: last ? 0 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.emerald600
                              : last
                                  ? AppColors.slate400.withValues(alpha: 0.5)
                                  : Colors.white)),
                  if (badge != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(badge!,
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emerald600)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: active
                          ? Colors.white
                          : AppColors.slate400.withValues(
                              alpha: last ? 0.4 : 1.0))),
            ],
          ),
        ),
      ],
    );
  }
}

class _CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0F1F2A);
    canvas.drawRect(Offset.zero & size, bg);
    final road = Paint()
      ..color = const Color(0xFF1E3040)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final route = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), road);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6), road);
    canvas.drawLine(Offset(0, size.height * 0.8), Offset(size.width, size.height * 0.8), road);
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), road);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.6, size.height), road);
    canvas.drawLine(Offset(size.width * 0.85, 0), Offset(size.width * 0.85, size.height), road);

    // Route path
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.3);
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(_CityMapPainter old) => false;
}
