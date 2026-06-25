import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/localization/app_localizations.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String _selected = 'Shopper';

  // (canonical English label used as the selection key, role enum, icon, name-key, desc-key)
  static const _roles = [
    ('Shopper', 'shopper', Icons.shopping_bag_rounded, 'role_shopper', 'role_shopper_desc'),
    ('Vendor', 'vendor', Icons.storefront_rounded, 'role_vendor', 'role_vendor_desc'),
    ('Service Provider', 'provider', Icons.build_rounded, 'role_provider', 'role_provider_desc'),
    ('Rider', 'rider', Icons.delivery_dining_rounded, 'role_rider', 'role_rider_desc'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/get-started'),
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
                  const SizedBox(height: 28),
                  Text(
                    ref.tr('role_title'),
                    style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ref.tr('role_subtitle'),
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppColors.slate400, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Scrollable role list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...(_roles.map((role) {
                final (key, _, icon, nameKey, descKey) = role;
                final name = ref.tr(nameKey);
                final desc = ref.tr(descKey);
                final isSelected = _selected == key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.emerald600.withValues(alpha: 0.1)
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.emerald600
                              : AppColors.slate700,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.emerald600.withValues(alpha: 0.2)
                                  : AppColors.surfaceBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon,
                                color: isSelected
                                    ? AppColors.emerald600
                                    : AppColors.slate400,
                                size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                Text(desc,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.slate400,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.emerald600
                                    : AppColors.slate400,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.emerald600
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 14)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
                  ],
                ),
              ),
            ),
            // Pinned footer
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        final roleEnum = _roles
                            .firstWhere((r) => r.$1 == _selected,
                                orElse: () => _roles.first)
                            .$2;
                        ref.read(pendingSignupRoleProvider.notifier).state =
                            roleEnum;
                        context.go('/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(ref.tr('continue'),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.slate400),
                        children: [
                          TextSpan(text: ref.tr('gs_already_have_account')),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text(ref.tr('gs_log_in'),
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.emerald600,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
