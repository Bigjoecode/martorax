import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class NearbyServicesMapScreen extends StatefulWidget {
  const NearbyServicesMapScreen({super.key});

  @override
  State<NearbyServicesMapScreen> createState() =>
      _NearbyServicesMapScreenState();
}

class _NearbyServicesMapScreenState
    extends State<NearbyServicesMapScreen> {
  int _categoryIdx = 0;
  static const _categories = [
    'All',
    'Plumbing',
    'Hairdressing',
    'Electrical'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10221C),
      body: Stack(
        children: [
          // Map background
          CustomPaint(
            size: Size.infinite,
            painter: _CityMapPainter(),
          ),
          // Map markers
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.2,
            child: _MarkerWithPulse(
                icon: Icons.location_on_rounded,
                color: const Color(0xFF09F6AB)),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45,
            left: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                _MarkerWithPulse(
                    icon: Icons.verified_user_rounded,
                    color: const Color(0xFFFFD700),
                    size: 40),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0xFFFFD700)),
                  ),
                  child: Text('TRUSTED',
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFD700))),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            right: MediaQuery.of(context).size.width * 0.2,
            child: _MarkerWithPulse(
                icon: Icons.location_on_rounded,
                color: const Color(0xFF09F6AB)),
          ),
          // Top search overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF10221C)
                        .withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155)
                                .withValues(alpha: 0.9),
                            borderRadius:
                                BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white
                                    .withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16),
                                child: Icon(Icons.search_rounded,
                                    color: Colors.white
                                        .withValues(alpha: 0.6),
                                    size: 20),
                              ),
                              Expanded(
                                child: TextField(
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search for service providers',
                                    hintStyle: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white
                                            .withValues(alpha: 0.4)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155)
                              .withValues(alpha: 0.9),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.1)),
                        ),
                        child: Icon(Icons.tune_rounded,
                            color: const Color(0xFF09F6AB),
                            size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (_, i) {
                        final selected = _categoryIdx == i;
                        return GestureDetector(
                          onTap: () => setState(
                              () => _categoryIdx = i),
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF09F6AB)
                                  : const Color(0xFF334155)
                                      .withValues(alpha: 0.9),
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: selected
                                  ? null
                                  : Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.1)),
                            ),
                            child: Center(
                              child: Text(_categories[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: selected
                                          ? const Color(
                                              0xFF10221C)
                                          : Colors.white)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155)
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white
                            .withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.add_rounded,
                            color: Colors.white, size: 20),
                      ),
                      Container(
                          height: 1,
                          color: Colors.white
                              .withValues(alpha: 0.1)),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.remove_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155)
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white
                            .withValues(alpha: 0.1)),
                  ),
                  child: Icon(Icons.near_me_rounded,
                      color: const Color(0xFF09F6AB), size: 20),
                ),
              ],
            ),
          ),
          // Bottom carousel + nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Provider cards carousel
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(
                        16, 0, 16, 12),
                    children: const [
                      _ProviderTile(
                          name: 'John Doe',
                          title: 'Plumbing Specialist',
                          rating: '4.8',
                          icon: Icons.plumbing_rounded),
                      _ProviderTile(
                          name: 'Elite Salon',
                          title: 'Hairdressing & Spa',
                          rating: '5.0',
                          icon: Icons.content_cut_rounded,
                          isTrusted: true),
                      _ProviderTile(
                          name: 'Power Fixers',
                          title: 'Electrical Repairs',
                          rating: '4.7',
                          icon:
                              Icons.electrical_services_rounded),
                    ],
                  ),
                ),
                // Bottom nav
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155)
                        .withValues(alpha: 0.95),
                    border: Border(
                        top: BorderSide(
                            color: Colors.white
                                .withValues(alpha: 0.05))),
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom:
                        MediaQuery.of(context).padding.bottom +
                            12,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(Icons.home_rounded, 'HOME',
                          false, () => context.go('/home')),
                      _NavItem(Icons.map_rounded, 'SEARCH',
                          true, () {}),
                      _NavItem(Icons.calendar_today_rounded,
                          'BOOKINGS', false,
                          () => context.go('/bookings')),
                      _NavItem(Icons.person_rounded, 'PROFILE',
                          false, () => context.go('/profile')),
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

class _MarkerWithPulse extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _MarkerWithPulse({
    required this.icon,
    required this.color,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        Icon(icon, color: color, size: size),
      ],
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final String name;
  final String title;
  final String rating;
  final IconData icon;
  final bool isTrusted;

  const _ProviderTile({
    required this.name,
    required this.title,
    required this.rating,
    required this.icon,
    this.isTrusted = false,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = const Color(0xFFFFD700);
    final primaryColor = const Color(0xFF09F6AB);
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF334155).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isTrusted
                ? goldColor
                : Colors.white.withValues(alpha: 0.05),
            width: isTrusted ? 2 : 1),
      ),
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
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isTrusted
                          ? goldColor
                          : primaryColor.withValues(alpha: 0.6),
                      width: 2),
                ),
                child: Icon(icon,
                    color: isTrusted ? goldColor : primaryColor,
                    size: 28),
              ),
              if (isTrusted)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: goldColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified_rounded,
                        color: const Color(0xFF10221C),
                        size: 12),
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
                    Expanded(
                      child: Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                    Icon(Icons.star_rounded,
                        color: isTrusted ? goldColor : primaryColor,
                        size: 14),
                    const SizedBox(width: 2),
                    Text(rating,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isTrusted
                                ? goldColor
                                : Colors.white)),
                  ],
                ),
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white
                            .withValues(alpha: 0.6))),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.go('/service/booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTrusted
                          ? goldColor
                          : primaryColor.withValues(alpha: 0.2),
                      side: isTrusted
                          ? null
                          : BorderSide(
                              color: primaryColor
                                  .withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                        isTrusted
                            ? 'PREMIUM BOOKING'
                            : 'BOOK NOW',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isTrusted
                                ? const Color(0xFF10221C)
                                : primaryColor,
                            letterSpacing: 1.0)),
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
                  ? const Color(0xFF09F6AB)
                  : Colors.white.withValues(alpha: 0.6),
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: active
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: active
                      ? const Color(0xFF09F6AB)
                      : Colors.white.withValues(alpha: 0.6),
                  letterSpacing: 1.0)),
        ],
      ),
    );
  }
}

class _CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0B1812)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFF1A2A20)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
          Offset(0, size.height * (i + 1) / 8),
          Offset(size.width, size.height * (i + 1) / 8),
          road);
    }
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
          Offset(size.width * (i + 1) / 5, 0),
          Offset(size.width * (i + 1) / 5, size.height),
          road);
    }

    final block = Paint()
      ..color = const Color(0xFF101F18)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 6; j++) {
        final x = (i * size.width / 5) + 8;
        final y = (j * size.height / 8) + 8;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(x, y, size.width / 5 - 16,
                    size.height / 8 - 16),
                const Radius.circular(3)),
            block);
      }
    }
  }

  @override
  bool shouldRepaint(_CityMapPainter o) => false;
}
