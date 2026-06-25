import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/data_providers.dart';

String _naira(num v) =>
    '₦${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

class RiderServiceDashboardScreen extends ConsumerWidget {
  const RiderServiceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data =
        ref.watch(riderDashboardProvider).valueOrNull ?? const RiderDashboardData();
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final fullName = (profile?['full_name'] as String?)?.trim();
    final greetName = (fullName != null && fullName.isNotEmpty) ? fullName : 'Rider';
    final rating = (profile?['rating'] as num?)?.toStringAsFixed(1) ?? '5.0';
    final verified = (profile?['kyc_status'] as String?) == 'verified';
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                color: AppColors.darkBg,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: AppColors.slate700)),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.emerald600
                                      .withValues(alpha: 0.5),
                                  width: 2),
                            ),
                            child: Icon(Icons.person_rounded,
                                color: AppColors.slate400, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(ref.tr('st_rider_dashboard'),
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text(verified ? 'Verified Rider' : 'Verification pending',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: verified
                                          ? AppColors.emerald600
                                          : AppColors.amber500)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('Go Online',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        AppColors.emerald600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 24, 16, 8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back,',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate400)),
                            Text('Welcome, $greetName!',
                                style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      // Stats grid
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Row(
                          children: [
                            _StatCard(
                              icon: Icons.payments_rounded,
                              label: 'Earnings',
                              value: _naira(data.earnings),
                              valueColor: AppColors.emerald600,
                            ),
                            const SizedBox(width: 12),
                            _StatCard(
                              icon: Icons.directions_bike_rounded,
                              label: 'Completed',
                              value: '${data.completedCount}',
                            ),
                            const SizedBox(width: 12),
                            _StatCard(
                              icon: Icons.star_rounded,
                              label: 'Rating',
                              value: rating,
                              valueSuffix: '/5',
                            ),
                          ],
                        ),
                      ),
                      // New Order header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 24, 16, 0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('New Order Nearby',
                                style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.red
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                              child: Text('EXPIRES IN 45s',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                      // Order card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.emerald600,
                                width: 2),
                          ),
                          child: Column(
                            children: [
                              // Map preview
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                child: SizedBox(
                                  height: 160,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CustomPaint(
                                        painter:
                                            _MapPreviewPainter(),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8,
                                                  vertical: 4),
                                          decoration:
                                              BoxDecoration(
                                            color: Colors.white
                                                .withValues(
                                                    alpha: 0.9),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(4),
                                          ),
                                          child: Text(
                                              '2.4 KM AWAY',
                                              style:
                                                  GoogleFonts
                                                      .inter(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  color: Colors
                                                      .black)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '₦1,200 ',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  color: AppColors
                                                      .emerald600,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    'Delivery Fee',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      FontStyle
                                                          .italic,
                                                  color: AppColors
                                                      .slate400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(8),
                                          decoration:
                                              BoxDecoration(
                                            color: AppColors
                                                .surfaceBg,
                                            borderRadius:
                                                BorderRadius
                                                    .circular(8),
                                          ),
                                          child: Icon(
                                              Icons
                                                  .local_mall_rounded,
                                              color: AppColors
                                                  .slate400,
                                              size: 22),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                                Icons
                                                    .radio_button_checked_rounded,
                                                color: AppColors
                                                    .emerald600,
                                                size: 18),
                                            Container(
                                              width: 1,
                                              height: 28,
                                              color:
                                                  AppColors
                                                      .slate700,
                                            ),
                                            const Icon(
                                                Icons
                                                    .location_on_rounded,
                                                color: Colors.red,
                                                size: 18),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text('PICKUP',
                                                    style: GoogleFonts
                                                        .inter(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight
                                                              .w700,
                                                      color: AppColors
                                                          .slate400,
                                                      letterSpacing:
                                                          1.5,
                                                    )),
                                                Text(
                                                    'Ogbogonogo Stall 4',
                                                    style: GoogleFonts
                                                        .inter(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight
                                                              .w700,
                                                      color: Colors
                                                          .white,
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                    'DROPOFF LANDMARK',
                                                    style: GoogleFonts
                                                        .inter(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight
                                                              .w700,
                                                      color: AppColors
                                                          .slate400,
                                                      letterSpacing:
                                                          1.5,
                                                    )),
                                                Text(
                                                    'Near Federal Medical Centre',
                                                    style: GoogleFonts
                                                        .inter(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight
                                                              .w700,
                                                      color: Colors
                                                          .white,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 52,
                                            child:
                                                ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton
                                                  .styleFrom(
                                                backgroundColor:
                                                    AppColors
                                                        .surfaceBg,
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              12),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                  'Decline',
                                                  style: GoogleFonts
                                                      .inter(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                    color: AppColors
                                                        .slate400,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 52,
                                            child:
                                                ElevatedButton(
                                              onPressed: () =>
                                                  context.go(
                                                      '/rider/in-transit'),
                                              style: ElevatedButton
                                                  .styleFrom(
                                                backgroundColor:
                                                    AppColors
                                                        .emerald600,
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              12),
                                                ),
                                              ),
                                              child: Text(
                                                  'Accept Order',
                                                  style: GoogleFonts
                                                      .inter(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                    color: Colors
                                                        .white,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Today's activity
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text("TODAY'S ACTIVITY",
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate400,
                                    letterSpacing: 1.5)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBg
                                    .withValues(alpha: 0.5),
                                borderRadius:
                                    BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.slate700),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.emerald600
                                          .withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                        Icons
                                            .check_circle_rounded,
                                        color:
                                            AppColors.emerald600,
                                        size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                            data.recent.isEmpty
                                                ? 'No deliveries yet'
                                                : 'Delivery',
                                            style:
                                                GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Text(
                                            data.recent.isEmpty
                                                ? 'Completed deliveries appear here'
                                                : ((data.recent.first['landmark_destination']
                                                        as String?) ??
                                                    'Asaba'),
                                            style:
                                                GoogleFonts.inter(
                                              fontSize: 11,
                                              color: AppColors
                                                  .slate400,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Text(
                                      data.recent.isEmpty
                                          ? ''
                                          : _naira(kRiderFeePerDelivery),
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
              color: AppColors.darkBg,
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
                  _NavItem(Icons.dashboard_rounded, 'Dashboard',
                      true, () {}),
                  _NavItem(Icons.account_balance_wallet_rounded,
                      'Earnings', false,
                      () => context.go('/history')),
                  _NavItem(Icons.history_rounded, 'History',
                      false, () {}),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? valueSuffix;
  final Color? valueColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueSuffix,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate700),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.slate400, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate400)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: valueColor ?? Colors.white),
                  ),
                  if (valueSuffix != null)
                    TextSpan(
                      text: valueSuffix,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.slate400),
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
              color:
                  active ? AppColors.emerald600 : AppColors.slate400,
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

class _MapPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0D2010)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFF1E3A28)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        road);
    canvas.drawLine(
        Offset(size.width * 0.3, 0),
        Offset(size.width * 0.3, size.height),
        road);
    canvas.drawLine(
        Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height),
        road);

    final route = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.8)
      ..quadraticBezierTo(
          size.width * 0.3,
          size.height * 0.5,
          size.width * 0.85,
          size.height * 0.2);
    canvas.drawPath(path, route);

    final dot = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.2), 8, dot);

    final start = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.8), 7, start);
  }

  @override
  bool shouldRepaint(_MapPreviewPainter o) => false;
}
