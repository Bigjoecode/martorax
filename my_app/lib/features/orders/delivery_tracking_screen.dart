import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/supabase/gps_tracking_service.dart';
import '../../core/widgets/martorax_map.dart';
import '../../core/utils/app_actions.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  final _gps = GpsTrackingService();
  StreamSubscription<Map<String, double>>? _sub;
  GoogleMapController? _mapController;

  // Destination = Nnebisi Junction (route end in GpsTrackingService).
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
    final markers = {
      Marker(
        markerId: const MarkerId('rider'),
        position: _rider,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Chidi K.', snippet: 'Your rider'),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: const InfoWindow(title: 'Drop-off'),
      ),
    };
    final route = {
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
    };

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
                    // Live Google Map
                    MartoraxMap(
                      initialTarget: kAsabaCenter,
                      initialZoom: 14.5,
                      markers: markers,
                      polylines: route,
                      onMapCreated: (c) => _mapController = c,
                    ),

                    // SOS button
                    Positioned(
                      bottom: 24,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => triggerSos(context),
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
                                    onTap: () => dialPhone(context, null)),
                                const SizedBox(width: 8),
                                _ActionBtn(
                                    icon: Icons.chat_bubble_rounded,
                                    onTap: () => context.go('/provider/chat')),
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
                            onPressed: () => shareText(
                                'Track my MartoraX delivery — order #MX-72841 is on the way! 🛵'),
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

