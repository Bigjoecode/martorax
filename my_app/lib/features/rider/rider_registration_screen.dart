import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class RiderRegistrationScreen extends ConsumerStatefulWidget {
  const RiderRegistrationScreen({super.key});

  @override
  ConsumerState<RiderRegistrationScreen> createState() =>
      _RiderRegistrationScreenState();
}

class _RiderRegistrationScreenState extends ConsumerState<RiderRegistrationScreen> {
  int _vehicleIdx = 0;

  static const _vehicles = [
    _Vehicle('Bike', Icons.moped_rounded),
    _Vehicle('Keke', Icons.electric_rickshaw_rounded),
    _Vehicle('Car/Van', Icons.directions_car_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(ref.tr('st_rider_register'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text('Join as a Rider',
                style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5)),
            const SizedBox(height: 10),
            Text('Start earning today by delivering products across Asaba.',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.slate400,
                    height: 1.5)),
            const SizedBox(height: 36),
            // Full Name
            _fieldLabel('FULL NAME'),
            const SizedBox(height: 8),
            _TextField(
              hint: 'Enter your full name',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 24),
            // Vehicle type
            _fieldLabel('VEHICLE TYPE'),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_vehicles.length, (i) {
                final v = _vehicles[i];
                final isSelected = _vehicleIdx == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _vehicleIdx = i),
                    child: Container(
                      margin: i < _vehicles.length - 1
                          ? const EdgeInsets.only(right: 10)
                          : EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.emerald600.withValues(alpha: 0.1)
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.emerald600
                              : AppColors.slate700,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(v.icon,
                              color: isSelected
                                  ? AppColors.emerald600
                                  : AppColors.slate400,
                              size: 26),
                          const SizedBox(height: 6),
                          Text(v.label,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.emerald600
                                      : Colors.white)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Phone number
            _fieldLabel('PHONE NUMBER'),
            const SizedBox(height: 8),
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.slate700),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text('+234',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate400)),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '803 000 0000',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.slate400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Referral code
            _fieldLabel('REFERRAL CODE (OPTIONAL)'),
            const SizedBox(height: 8),
            _TextField(
              hint: 'Enter code',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 48),
            // Continue button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/kyc/verify'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Continue to verification',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.slate400),
                  children: [
                    const TextSpan(text: 'Already a rider? '),
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: AppColors.emerald600,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'By continuing, you agree to the MartoraX Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.slate400.withValues(alpha: 0.6),
                    height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Vehicle {
  final String label;
  final IconData icon;
  const _Vehicle(this.label, this.icon);
}

Widget _fieldLabel(String text) {
  return Text(text,
      style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.slate400,
          letterSpacing: 1.5));
}

class _TextField extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  const _TextField({required this.hint, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.slate700),
      ),
      child: TextField(
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.inter(fontSize: 14, color: AppColors.slate400),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}
