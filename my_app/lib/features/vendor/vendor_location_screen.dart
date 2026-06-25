import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import 'vendor_widgets.dart';

class VendorLocationScreen extends ConsumerStatefulWidget {
  const VendorLocationScreen({super.key});

  @override
  ConsumerState<VendorLocationScreen> createState() => _VendorLocationScreenState();
}

class _VendorLocationScreenState extends ConsumerState<VendorLocationScreen> {
  final _landmarkCtrl = TextEditingController();

  @override
  void dispose() {
    _landmarkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.go('/vendor/kyc'),
        ),
        title: Text(ref.tr('st_vendor_location'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            StepIndicator(current: 2, total: 3),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pin Your Location',
                              style: GoogleFonts.manrope(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          const SizedBox(height: 6),
                          Text(
                            'Drag the map to place the pin exactly on your stall. Then, provide a well-known landmark nearby to help customers find you easily.',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.slate400,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _MapWidget(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nearby Landmark',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _landmarkCtrl,
                            style: GoogleFonts.inter(
                                fontSize: 14, color: Colors.white),
                            decoration: InputDecoration(
                              hintText:
                                  'e.g., Opp. Nnebisi Junction, behind XYZ filling station',
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.slate400),
                              filled: true,
                              fillColor: AppColors.cardBg,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.slate700),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.slate700),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.emerald600, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () => context.go('/vendor/dashboard'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.emerald600,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text('Confirm Location',
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
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
      ),
    );
  }
}

class _MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 280,
          color: const Color(0xFF1A2E3A),
          child: CustomPaint(
            size: const Size(double.infinity, 280),
            painter: _MapGridPainter(),
          ),
        ),
        // Map pin
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Icon(Icons.location_on_rounded,
                  color: AppColors.emerald600, size: 48),
            ],
          ),
        ),
        // Location button
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.my_location_rounded,
                color: AppColors.emerald600, size: 20),
          ),
        ),
        // Map label
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.touch_app_rounded,
                    color: AppColors.slate400, size: 14),
                const SizedBox(width: 4),
                Text('Drag to reposition pin',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.slate400)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3040)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some fake road lines
    final roadPaint = Paint()
      ..color = const Color(0xFF243548)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.4),
        Offset(size.width * 0.9, size.height * 0.4),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.2, size.height * 0.7),
        Offset(size.width * 0.8, size.height * 0.7),
        roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
