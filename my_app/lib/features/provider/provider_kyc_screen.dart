import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

/// Placeholder shown to providers who deep-link to /provider/kyc.
///
/// Real KYC (document upload to Supabase Storage + admin review queue)
/// is a follow-up engineering project. Until then, provider verification
/// is handled out-of-band by the operator. This screen sets expectations.
class ProviderKycScreen extends ConsumerWidget {
  const ProviderKycScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.go('/provider/dashboard'),
        ),
        title: Text(ref.tr('st_provider_kyc'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.amber500.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppColors.amber500.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(Icons.hourglass_top_rounded,
                      color: AppColors.amber500, size: 44),
                ),
                const SizedBox(height: 24),
                Text('Verification Pending',
                    style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 12),
                Text(
                  "Your service profile is live. Our team will reach out "
                  "within 24 hours to confirm your identity and credentials.\n\n"
                  "You can start accepting bookings now — every booking is "
                  "protected by SafePay escrow.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.slate400, height: 1.5),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.go('/provider/dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                    child: Text('Go to Dashboard',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
