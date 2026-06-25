import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';

class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => context.go('/language'),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.emerald700.withValues(alpha: 0.4),
                        AppColors.cardBg,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_city_rounded,
                      size: 90,
                      color: AppColors.emerald600.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    ref.tr('gs_title'),
                    style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.slate400,
                          height: 1.5),
                      children: [
                        TextSpan(text: ref.tr('gs_subtitle_prefix')),
                        TextSpan(
                            text: ref.tr('gs_city'),
                            style: TextStyle(
                                color: AppColors.emerald600,
                                fontWeight: FontWeight.w600)),
                        TextSpan(text: ref.tr('gs_subtitle_suffix')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      // Shopping requires an account. Send users through the
                      // role picker (default: shopper) which leads to /register.
                      onPressed: () {
                        ref.read(pendingSignupRoleProvider.notifier).state = 'shopper';
                        context.go('/role');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(ref.tr('gs_start_shopping'),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      // Pre-select vendor role, then create account via the
                      // unified /register flow. After signup the user lands
                      // on /vendor/kyc (already signed in, so no redirect).
                      onPressed: () {
                        ref.read(pendingSignupRoleProvider.notifier).state = 'vendor';
                        context.go('/register');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.emerald600),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(ref.tr('gs_register_vendor'),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(pendingSignupRoleProvider.notifier).state = 'provider';
                        context.go('/register');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.slate700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(ref.tr('gs_register_provider'),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.slate400),
                        children: [
                          TextSpan(text: ref.tr('gs_already_have_account')),
                          TextSpan(
                              text: ref.tr('gs_log_in'),
                              style: TextStyle(
                                  color: AppColors.emerald600,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
