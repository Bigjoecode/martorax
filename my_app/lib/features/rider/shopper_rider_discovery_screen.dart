import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ShopperRiderDiscoveryScreen extends ConsumerStatefulWidget {
  const ShopperRiderDiscoveryScreen({super.key});

  @override
  ConsumerState<ShopperRiderDiscoveryScreen> createState() =>
      _ShopperRiderDiscoveryScreenState();
}

class _ShopperRiderDiscoveryScreenState
    extends ConsumerState<ShopperRiderDiscoveryScreen> {
  int _filterIdx = 0;
  static const _filters = ['All Riders', 'Keke', 'Bike'];

  static const _riders = [
    _Rider('Chidi Obi', 'Keke', '4.8', '240 rides',
        '400m away', true),
    _Rider('Emeka John', 'Bike', '4.9', '512 rides',
        '1.2km away', true),
    _Rider('Joy Silas', 'Keke', '4.7', '', '2.5km away',
        false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Map background
          CustomPaint(painter: _CityMapPainter()),
          // Top bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkBg.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.darkBg
                              .withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(ref.tr('st_rider_discovery'),
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
          // Search bar overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 64,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.darkBg.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      color: AppColors.emerald600, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PICKUP LOCATION',
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emerald600,
                              letterSpacing: 1.0)),
                      Text('Nnebisi Road, Asaba',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // User location marker
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.emerald600
                        .withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.emerald600,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 3),
                  ),
                  child: Icon(Icons.person_rounded,
                      color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
          // Rider markers
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.2,
            child: _mapMarker(
                Icons.electric_rickshaw_rounded, '4 min'),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.28,
            right: MediaQuery.of(context).size.width * 0.2,
            child:
                _mapMarker(Icons.motorcycle_rounded, '2 min'),
          ),
          // Bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                border: Border(
                    top: BorderSide(
                        color:
                            Colors.white.withValues(alpha: 0.05))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      itemCount: _filters.length,
                      itemBuilder: (_, i) {
                        final selected = _filterIdx == i;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _filterIdx = i),
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 10),
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.emerald600
                                  : Colors.white
                                      .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(12),
                              border: selected
                                  ? null
                                  : Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.05)),
                            ),
                            child: Center(
                              child: Text(_filters[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: Colors.white)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Section header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Closest Riders',
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text('See Map',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.emerald600)),
                      ],
                    ),
                  ),
                  // Rider list
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _riders.length,
                      itemBuilder: (_, i) =>
                          _RiderRow(rider: _riders[i]),
                    ),
                  ),
                  // Request button
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.send_rounded,
                            color: Colors.white, size: 18),
                        label: Text('Request for Pickup',
                            style: GoogleFonts.inter(
                                fontSize: 15,
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
                  // Bottom nav
                  Container(
                    color: AppColors.darkBg
                        .withValues(alpha: 0.95),
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 12,
                      bottom: MediaQuery.of(context)
                              .padding
                              .bottom +
                          8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _NavItem(Icons.explore_rounded,
                            'Discover', true, () {}),
                        _NavItem(Icons.history_rounded,
                            'History', false, () {}),
                        _NavItem(
                            Icons.notifications_rounded,
                            'Alerts',
                            false,
                            () => context.go('/notifications')),
                        _NavItem(Icons.person_rounded, 'Profile',
                            false,
                            () => context.go('/profile')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapMarker(IconData icon, String time) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8)
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black87, size: 14),
          const SizedBox(width: 4),
          Text(time,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}

class _Rider {
  final String name;
  final String type;
  final String rating;
  final String rides;
  final String distance;
  final bool available;
  const _Rider(this.name, this.type, this.rating, this.rides,
      this.distance, this.available);
}

class _RiderRow extends StatelessWidget {
  final _Rider rider;
  const _RiderRow({required this.rider});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: rider.available ? 1.0 : 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: rider.available
                            ? AppColors.emerald600
                                .withValues(alpha: 0.2)
                            : Colors.white
                                .withValues(alpha: 0.1),
                        width: 2),
                  ),
                  child: Icon(Icons.person_rounded,
                      color: AppColors.slate400, size: 28),
                ),
                if (rider.available)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.emerald600,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.darkBg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(rider.name,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: rider.available
                              ? AppColors.emerald600
                                  .withValues(alpha: 0.2)
                              : AppColors.slate700,
                          borderRadius:
                              BorderRadius.circular(4),
                        ),
                        child: Text(rider.type,
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: rider.available
                                    ? AppColors.emerald600
                                    : AppColors.slate400,
                                letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: rider.available
                              ? AppColors.emerald600
                              : AppColors.slate400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                          rider.available
                              ? 'Available Now • ${rider.distance}'
                              : 'Recently active • ${rider.distance}',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.slate400)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(rider.rating,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(width: 2),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFF59E0B), size: 14),
                  ],
                ),
                if (rider.rides.isNotEmpty)
                  Text(rider.rides,
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate400,
                          letterSpacing: 1.0)),
              ],
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

class _CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFF2D3F55)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
          Offset(0, size.height * i / 5),
          Offset(size.width, size.height * i / 5),
          road);
    }
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
          Offset(size.width * i / 4, 0),
          Offset(size.width * i / 4, size.height),
          road);
    }

    final block = Paint()
      ..color = const Color(0xFF243040)
      ..style = PaintingStyle.fill;
    final rects = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.05,
          size.width * 0.18, size.height * 0.16),
      Rect.fromLTWH(size.width * 0.27, size.height * 0.05,
          size.width * 0.18, size.height * 0.16),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.25,
          size.width * 0.18, size.height * 0.14),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.1,
          size.width * 0.2, size.height * 0.1),
      Rect.fromLTWH(size.width * 0.08, size.height * 0.45,
          size.width * 0.14, size.height * 0.12),
    ];
    for (final r in rects) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(4)),
          block);
    }
  }

  @override
  bool shouldRepaint(_CityMapPainter o) => false;
}
