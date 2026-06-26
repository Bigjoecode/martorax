import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_config.dart';

class VendorGoLiveScreen extends ConsumerStatefulWidget {
  const VendorGoLiveScreen({super.key});

  @override
  ConsumerState<VendorGoLiveScreen> createState() => _VendorGoLiveScreenState();
}

class _VendorGoLiveScreenState extends ConsumerState<VendorGoLiveScreen> {
  int _pinnedProduct = 0;
  bool _goingLive = false;

  Future<void> _startLive() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _goingLive = true);
    try {
      await SupabaseConfig.client.from('profiles').update({
        'is_live': true,
        'live_started_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You are now LIVE! Shoppers can see your stream.'),
        backgroundColor: AppColors.emerald600,
      ));
      context.go('/vendor/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not go live: $e'),
        backgroundColor: Colors.red.shade700,
      ));
    } finally {
      if (mounted) setState(() => _goingLive = false);
    }
  }

  static const _products = [
    _Product('Fresh Tomatoes', '₦2,500 / basket', Icons.eco_rounded),
    _Product('Yellow Garri', '₦1,800 / paint', Icons.grass_rounded),
    _Product('Chili Peppers', '₦500 / bowl', Icons.local_fire_department_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_vendor_go_live'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded,
                color: AppColors.emerald600, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camera preview
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 2),
                      ),
                      child: Stack(
                        children: [
                          // Grid painter background
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CustomPaint(
                              painter: _CameraGridPainter(),
                              child: const SizedBox.expand(),
                            ),
                          ),
                          // Top overlays
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text('PREVIEW MODE',
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 1.5)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Column(
                              children: [
                                _CamBtn(Icons.flip_camera_ios_rounded),
                                const SizedBox(height: 8),
                                _CamBtn(Icons.flash_on_rounded),
                              ],
                            ),
                          ),
                          // Bottom hint
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                    'Position your products in the center',
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Colors.white
                                            .withValues(alpha: 0.7))),
                              ),
                            ),
                          ),
                          // Framing guide lines
                          Positioned.fill(
                            child: CustomPaint(painter: _FramingGuidePainter()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Deal title input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("WHAT'S THE DEAL TODAY?",
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.6),
                              letterSpacing: 1.5)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.slate700),
                        ),
                        child: TextField(
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'e.g., Ogbogonogo Tomato Slash!',
                            hintStyle: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.slate400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: InputBorder.none,
                          ),
                          controller: TextEditingController(
                              text: 'Ogbogonogo Tomato Slash!'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Featured products
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Featured Products',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('View All',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _products.length + 1,
                    itemBuilder: (context, i) {
                      if (i == _products.length) {
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.slate700,
                                width: 2,
                                style: BorderStyle.solid),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline_rounded,
                                  color: AppColors.slate400, size: 32),
                              const SizedBox(height: 8),
                              Text('Add From\nInventory',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.slate400)),
                            ],
                          ),
                        );
                      }
                      final p = _products[i];
                      final isPinned = _pinnedProduct == i;
                      return GestureDetector(
                        onTap: () => setState(() => _pinnedProduct = i),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isPinned
                                  ? AppColors.emerald600
                                  : AppColors.slate700,
                              width: isPinned ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(p.icon,
                                        color: AppColors.emerald600, size: 42),
                                  ),
                                  if (isPinned)
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.emerald600,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.push_pin_rounded,
                                            color: Colors.white, size: 12),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text(p.price,
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isPinned
                                          ? AppColors.emerald600
                                          : AppColors.slate400)),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: isPinned
                                      ? AppColors.emerald600
                                      : AppColors.slate700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                      isPinned ? 'PINNED' : 'PIN PRODUCT',
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkBg.withValues(alpha: 0),
                    AppColors.darkBg,
                    AppColors.darkBg,
                  ],
                ),
              ),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _goingLive ? null : _startLive,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(_goingLive ? 'Going live…' : 'Start Live Deal',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _Product {
  final String name;
  final String price;
  final IconData icon;
  const _Product(this.name, this.price, this.icon);
}

class _CamBtn extends StatelessWidget {
  final IconData icon;
  const _CamBtn(this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0D1B2A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);
    final g = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 7; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
                i * size.width / 5 + 6,
                j * size.height / 7 + 6,
                size.width / 5 - 12,
                size.height / 7 - 12),
            const Radius.circular(4),
          ),
          g,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CameraGridPainter o) => false;
}

class _FramingGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width / 3, 0),
        Offset(size.width / 3, size.height), p);
    canvas.drawLine(Offset(size.width * 2 / 3, 0),
        Offset(size.width * 2 / 3, size.height), p);
    canvas.drawLine(Offset(0, size.height / 3),
        Offset(size.width, size.height / 3), p);
    canvas.drawLine(Offset(0, size.height * 2 / 3),
        Offset(size.width, size.height * 2 / 3), p);
  }

  @override
  bool shouldRepaint(_FramingGuidePainter o) => false;
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
