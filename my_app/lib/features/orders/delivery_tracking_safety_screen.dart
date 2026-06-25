import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/supabase/gps_tracking_service.dart';
import '../../core/widgets/martorax_map.dart';
import '../../core/utils/app_actions.dart';

class DeliveryTrackingSafetyScreen extends StatefulWidget {
  const DeliveryTrackingSafetyScreen({super.key});

  @override
  State<DeliveryTrackingSafetyScreen> createState() =>
      _DeliveryTrackingSafetyScreenState();
}

class _DeliveryTrackingSafetyScreenState
    extends State<DeliveryTrackingSafetyScreen> {
  final _gps = GpsTrackingService();
  StreamSubscription<Map<String, double>>? _sub;
  GoogleMapController? _mapController;
  static const LatLng _destination = LatLng(6.1950, 6.7150);
  LatLng _rider = kAsabaCenter;

  @override
  void initState() {
    super.initState();
    _sub = _gps.streamRiderLocation('MX-72841').listen((pos) {
      final next = LatLng(pos['latitude']!, pos['longitude']!);
      if (!mounted) return;
      setState(() => _rider = next);
      _mapController?.animateCamera(CameraUpdate.newLatLng(next));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F231D),
      body: Stack(
        children: [
          Column(
            children: [
              // Map section (55%)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MartoraxMap(
                      initialTarget: kAsabaCenter,
                      initialZoom: 14.5,
                      markers: {
                        Marker(
                          markerId: const MarkerId('rider'),
                          position: _rider,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          infoWindow: const InfoWindow(
                              title: 'Chidi K.', snippet: 'Your rider'),
                        ),
                        Marker(
                          markerId: const MarkerId('destination'),
                          position: _destination,
                          infoWindow: const InfoWindow(title: 'Drop-off'),
                        ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('route'),
                          color: AppColors.emerald600,
                          width: 4,
                          points: const [
                            LatLng(6.2054, 6.7291),
                            LatLng(6.2030, 6.7260),
                            LatLng(6.2005, 6.7225),
                            LatLng(6.1975, 6.7180),
                            LatLng(6.1950, 6.7150),
                          ],
                        ),
                      },
                      onMapCreated: (c) => _mapController = c,
                    ),
                    // Top app bar
                    Positioned(
                      top: MediaQuery.of(context).padding.top +
                          8,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F231D)
                                    .withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white
                                        .withValues(alpha: 0.1)),
                              ),
                              child: const Icon(
                                  Icons
                                      .arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ),
                          Column(
                            children: [
                              Text('LIVE TRACKING',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.w700,
                                      color:
                                          AppColors.emerald600,
                                      letterSpacing: 1.5)),
                              const SizedBox(height: 2),
                              Text('Order #MX-72841',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w700,
                                      color: Colors.white)),
                            ],
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F231D)
                                  .withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: 0.1)),
                            ),
                            child: const Icon(
                                Icons.help_outline_rounded,
                                color: Colors.white,
                                size: 20),
                          ),
                        ],
                      ),
                    ),
                    // SOS button
                    Positioned(
                      right: 16,
                      bottom: 24,
                      child: GestureDetector(
                        onTap: () => triggerSos(context),
                        child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  Colors.red.withValues(alpha: 0.3),
                              width: 4),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.red.withValues(alpha: 0.5),
                              blurRadius: 25,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(
                                Icons.emergency_rounded,
                                color: Colors.white,
                                size: 24),
                            Text('SOS',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5)),
                          ],
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom panel
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F231D),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                    border: Border(
                        top: BorderSide(
                            color: Colors.white
                                .withValues(alpha: 0.05))),
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 48,
                        height: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600
                              .withValues(alpha: 0.3),
                          borderRadius:
                              BorderRadius.circular(2),
                        ),
                      ),
                      // Rider profile
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            24, 8, 24, 16),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .surfaceBg,
                                        borderRadius:
                                            BorderRadius
                                                .circular(12),
                                        border: Border.all(
                                            color: AppColors
                                                .emerald600
                                                .withValues(
                                                    alpha:
                                                        0.2),
                                            width: 2),
                                      ),
                                      child: Icon(
                                          Icons.person_rounded,
                                          color: AppColors
                                              .slate400,
                                          size: 32),
                                    ),
                                    Positioned(
                                      bottom: -4,
                                      right: -4,
                                      child: Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 6,
                                                vertical: 2),
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                              0xFFFBBF24),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            Text('4.8',
                                                style: GoogleFonts
                                                    .inter(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  color: Colors
                                                      .black,
                                                )),
                                            const Icon(
                                                Icons.star_rounded,
                                                color: Colors
                                                    .black,
                                                size: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Chidi K.',
                                        style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white)),
                                    Text(
                                        'Yellow Keke • ASB-123-XY',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: const Color(
                                                0xFF8FCCB8))),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _ActionButton(
                                    icon: Icons.call_rounded),
                                const SizedBox(width: 8),
                                _ActionButton(
                                    icon: Icons
                                        .chat_bubble_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24),
                        height: 1,
                        color: Colors.white
                            .withValues(alpha: 0.05),
                      ),
                      // Timeline
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Column(
                          children: [
                            _TimelineStep(
                              icon: Icons.check_rounded,
                              title: 'Order Picked up',
                              subtitle: '10:15 AM • Summit Road',
                              completed: true,
                              showLine: true,
                            ),
                            _TimelineStep(
                              icon: Icons.local_shipping_rounded,
                              title: 'On the way',
                              subtitle:
                                  'Approaching your location',
                              active: true,
                              badge: 'LIVE',
                              showLine: true,
                            ),
                            _TimelineStep(
                              icon: Icons.location_on_rounded,
                              title: 'Arriving',
                              subtitle: 'Estimated 10:30 AM',
                              isItalic: true,
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
          // Footer share button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom:
                    MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F231D)
                        .withValues(alpha: 0),
                    const Color(0xFF0F231D),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => shareText(
                          'Track my MartoraX delivery — order #MX-72841 is on the way! 🛵'),
                      icon: const Icon(
                          Icons.share_location_rounded,
                          color: Colors.white,
                          size: 20),
                      label: Text('Share Trip Progress',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'MartoraX Secure Delivery • Asaba, Delta State',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white
                              .withValues(alpha: 0.4))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  const _ActionButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.emerald600.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
            color: AppColors.emerald600.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: AppColors.emerald600, size: 20),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool completed;
  final bool active;
  final bool isItalic;
  final bool showLine;
  final String? badge;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.completed = false,
    this.active = false,
    this.isItalic = false,
    this.showLine = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor;
    final Color iconBg;
    final Color titleColor;

    if (completed) {
      iconColor = AppColors.emerald600;
      iconBg = AppColors.emerald600.withValues(alpha: 0.2);
      titleColor = Colors.white;
    } else if (active) {
      iconColor = Colors.white;
      iconBg = AppColors.emerald600;
      titleColor = AppColors.emerald600;
    } else {
      iconColor = Colors.white.withValues(alpha: 0.3);
      iconBg = Colors.white.withValues(alpha: 0.05);
      titleColor = Colors.white.withValues(alpha: 0.3);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                  border: !completed && !active
                      ? Border.all(
                          color: Colors.white
                              .withValues(alpha: 0.1))
                      : null,
                  boxShadow: active
                      ? [
                          BoxShadow(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.4),
                              blurRadius: 10),
                        ]
                      : null,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 4),
                    color: completed
                        ? AppColors.emerald600
                            .withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: titleColor)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(4),
                          ),
                          child: Text(badge!,
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600,
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontStyle: isItalic
                              ? FontStyle.italic
                              : FontStyle.normal,
                          color: active
                              ? Colors.white
                              : (completed
                                  ? const Color(0xFF8FCCB8)
                                  : Colors.white
                                      .withValues(alpha: 0.2)))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

