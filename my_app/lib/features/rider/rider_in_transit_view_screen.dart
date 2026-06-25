import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class RiderInTransitViewScreen extends ConsumerStatefulWidget {
  const RiderInTransitViewScreen({super.key});

  @override
  ConsumerState<RiderInTransitViewScreen> createState() =>
      _RiderInTransitViewScreenState();
}

class _RiderInTransitViewScreenState
    extends ConsumerState<RiderInTransitViewScreen> {
  bool _statusUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          Column(
            children: [
              // Map section (45% height)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(painter: _TransitMapPainter()),
                    // Route SVG overlay
                    CustomPaint(
                        painter: _RoutePainter()),
                    // Top app bar overlay
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.darkBg
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(ref.tr('st_rider_in_transit').toUpperCase(),
                                    style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            AppColors.emerald600,
                                        letterSpacing: 1.0)),
                                Text(
                                    'Behind XYZ filling station',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom panel
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D1B2A),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 48,
                        height: 4,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color:
                              Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                              24, 16, 24, 180),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // Customer info
                              Container(
                                padding:
                                    const EdgeInsets.only(
                                        bottom: 20),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white
                                              .withValues(
                                                  alpha: 0.05))),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text('Chidi K.',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 24,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  color:
                                                      Colors.white,
                                                )),
                                            Text('Customer',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  color: AppColors
                                                      .emerald600,
                                                )),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 16,
                                              vertical: 10),
                                          decoration:
                                              BoxDecoration(
                                            color: AppColors
                                                .emerald600
                                                .withValues(
                                                    alpha: 0.1),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(12),
                                            border: Border.all(
                                                color: AppColors
                                                    .emerald600
                                                    .withValues(
                                                        alpha:
                                                            0.2)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .end,
                                            children: [
                                              Text('8 mins',
                                                  style: GoogleFonts
                                                      .inter(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                    color: AppColors
                                                        .emerald600,
                                                  )),
                                              Text('REMAINING',
                                                  style: GoogleFonts
                                                      .inter(
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                    color: AppColors
                                                        .emerald600
                                                        .withValues(
                                                            alpha:
                                                                0.7),
                                                    letterSpacing:
                                                        0.5,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                            Icons
                                                .location_on_rounded,
                                            color:
                                                AppColors.emerald600,
                                            size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                            'Behind XYZ filling station, Asaba',
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w500,
                                                color: Colors.white
                                                    .withValues(
                                                        alpha:
                                                            0.8))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Status update card
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withValues(alpha: 0.05),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text('Status Update',
                                                style:
                                                    GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color:
                                                      Colors.white,
                                                )),
                                            Text(
                                                'Traffic or Rain delay?',
                                                style:
                                                    GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: Colors.white
                                                      .withValues(
                                                          alpha: 0.5),
                                                )),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => setState(() =>
                                              _statusUpdating =
                                                  !_statusUpdating),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width: 51,
                                            height: 31,
                                            padding:
                                                const EdgeInsets
                                                    .all(2),
                                            decoration: BoxDecoration(
                                              color: _statusUpdating
                                                  ? AppColors
                                                      .emerald600
                                                  : AppColors
                                                      .surfaceBg,
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(16),
                                            ),
                                            child: AnimatedAlign(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              alignment:
                                                  _statusUpdating
                                                      ? Alignment
                                                          .centerRight
                                                      : Alignment
                                                          .centerLeft,
                                              child: Container(
                                                width: 26,
                                                height: 26,
                                                decoration:
                                                    const BoxDecoration(
                                                  color: Colors.white,
                                                  shape:
                                                      BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _DelayButton(
                                            icon: Icons
                                                .water_drop_rounded,
                                            label: 'Heavy Rain',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _DelayButton(
                                            icon: Icons
                                                .traffic_rounded,
                                            label: 'Jammed',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Mark as arrived
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.white
                                            .withValues(alpha: 0.1)),
                                    backgroundColor: Colors.white
                                        .withValues(alpha: 0.05),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                16)),
                                  ),
                                  child: Text('MARK AS ARRIVED',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom action buttons + nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.darkBg.withValues(alpha: 0),
                        AppColors.darkBg,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.call_rounded,
                                color: Colors.white, size: 18),
                            label: Text('Call Customer',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.emerald600,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                                Icons.chat_bubble_rounded,
                                color: Colors.white,
                                size: 18),
                            label: Text('Send Message',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.surfaceBg,
                              side: BorderSide(
                                  color: Colors.white
                                      .withValues(alpha: 0.1)),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.darkBg
                      .withValues(alpha: 0.95),
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 12,
                    bottom:
                        MediaQuery.of(context).padding.bottom +
                            12,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _NavItem(Icons.dashboard_rounded,
                          'Dashboard', true, () {}),
                      _NavItem(
                          Icons.account_balance_wallet_rounded,
                          'Earnings',
                          false,
                          () => context.go('/history')),
                      _NavItem(Icons.history_rounded, 'History',
                          false, () {}),
                      _NavItem(Icons.person_rounded, 'Profile',
                          false,
                          () => context.go('/profile')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DelayButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DelayButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: Colors.white.withValues(alpha: 0.7),
              size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7))),
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

class _TransitMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0A1A10)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFF1A3020)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4),
        road);
    canvas.drawLine(
        Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7),
        road);
    canvas.drawLine(
        Offset(size.width * 0.25, 0),
        Offset(size.width * 0.25, size.height),
        road);
    canvas.drawLine(
        Offset(size.width * 0.65, 0),
        Offset(size.width * 0.65, size.height),
        road);

    final block = Paint()
      ..color = const Color(0xFF122018)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.28, size.height * 0.1,
                size.width * 0.34, size.height * 0.28),
            const Radius.circular(4)),
        block);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.02, size.height * 0.43,
                size.width * 0.2, size.height * 0.24),
            const Radius.circular(4)),
        block);
  }

  @override
  bool shouldRepaint(_TransitMapPainter o) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.75)
      ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.6,
          size.width * 0.65,
          size.height * 0.35)
      ..quadraticBezierTo(
          size.width * 0.75,
          size.height * 0.2,
          size.width * 0.88,
          size.height * 0.12);

    // Draw dashed path manually
    final pathMetric = path.computeMetrics();
    for (final metric in pathMetric) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final segLen = draw ? 6.0 : 14.0;
        final next =
            (distance + segLen).clamp(0.0, metric.length);
        if (draw) {
          canvas.drawPath(
              metric.extractPath(distance, next), dashPaint);
        }
        distance = next;
        draw = !draw;
      }
    }

    // Destination dot (pulsing green)
    final destDot = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.88, size.height * 0.12), 9,
        destDot);

    // Start dot (white)
    final startDot = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.12, size.height * 0.75), 10,
        startDot);
    final startBorder = Paint()
      ..color = const Color(0xFF0A1A10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
        Offset(size.width * 0.12, size.height * 0.75), 10,
        startBorder);
  }

  @override
  bool shouldRepaint(_RoutePainter o) => false;
}
