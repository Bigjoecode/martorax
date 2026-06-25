import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class CheckoutDeliveryScreen extends ConsumerStatefulWidget {
  const CheckoutDeliveryScreen({super.key});

  @override
  ConsumerState<CheckoutDeliveryScreen> createState() => _CheckoutDeliveryScreenState();
}

class _CheckoutDeliveryScreenState extends ConsumerState<CheckoutDeliveryScreen> {
  bool _homeDelivery = true;
  final _addressCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();

  @override
  void dispose() {
    _addressCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/cart'),
        ),
        title: Text(ref.tr('st_checkout_delivery'),
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery mode toggle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _ModeTab(
                            label: ref.tr('co_home_delivery'),
                            active: _homeDelivery,
                            onTap: () => setState(() => _homeDelivery = true),
                          ),
                          _ModeTab(
                            label: ref.tr('co_market_pickup'),
                            active: !_homeDelivery,
                            onTap: () => setState(() => _homeDelivery = false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Address section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: AppColors.emerald600, size: 20),
                        const SizedBox(width: 8),
                        Text(ref.tr('co_address'),
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Landmark Address',
                            style: GoogleFonts.inter(
                                fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate400)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addressCtrl,
                          style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: ref.tr('co_address_hint'),
                            hintStyle: GoogleFonts.inter(fontSize: 15, color: AppColors.slate400),
                            filled: true,
                            fillColor: AppColors.cardBg,
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.slate700),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.slate700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.emerald600, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Map placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.slate700),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomPaint(
                              painter: _MapPainter(),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Icon(Icons.location_on_rounded,
                                color: AppColors.emerald600, size: 48),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.fullscreen_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text('Adjust Pin',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Instructions section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.notes_rounded, color: AppColors.emerald600, size: 20),
                        const SizedBox(width: 8),
                        Text(ref.tr('co_instructions'),
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _instructionsCtrl,
                      maxLines: 4,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: ref.tr('co_instructions_hint'),
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.slate400),
                        filled: true,
                        fillColor: AppColors.cardBg,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.slate700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.slate700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.emerald600, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _FooterButton(
            label: ref.tr('co_continue_to_pay'),
            icon: Icons.arrow_forward_rounded,
            onTap: () => context.go('/checkout/payment'),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ModeTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: double.infinity,
          decoration: BoxDecoration(
            color: active ? AppColors.surfaceBg : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.emerald600 : AppColors.slate400)),
          ),
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _FooterButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald600,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF1A2E3A);
    canvas.drawRect(Offset.zero & size, bg);
    final road = Paint()
      ..color = const Color(0xFF253545)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), road);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), road);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), road);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), road);
  }

  @override
  bool shouldRepaint(_MapPainter old) => false;
}
