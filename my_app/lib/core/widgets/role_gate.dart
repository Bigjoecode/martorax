import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

/// Wrap a role-specific screen so it is only shown if the signed-in user's
/// `active_role` matches [requiredRole]. While the profile is loading we show
/// a spinner; on mismatch we render a friendly access-denied panel.
class RoleGate extends ConsumerWidget {
  final String requiredRole;
  final Widget child;

  const RoleGate({
    super.key,
    required this.requiredRole,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    return profileAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.emerald600),
        ),
      ),
      error: (_, __) => _DeniedScreen(
        requiredRole: requiredRole,
        actualRole: 'unknown',
      ),
      data: (profile) {
        final role = (profile?['active_role'] as String?) ?? 'shopper';
        if (role == requiredRole) return child;
        return _DeniedScreen(requiredRole: requiredRole, actualRole: role);
      },
    );
  }
}

class _DeniedScreen extends StatelessWidget {
  final String requiredRole;
  final String actualRole;
  const _DeniedScreen({required this.requiredRole, required this.actualRole});

  String get _requiredLabel => switch (requiredRole) {
        'vendor' => 'Vendor',
        'provider' => 'Service Provider',
        'rider' => 'Rider',
        _ => 'Shopper',
      };

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
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.slate700),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.amber500, size: 38),
              ),
              const SizedBox(height: 22),
              Text('$_requiredLabel area',
                  style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                'This dashboard is for $_requiredLabel accounts. '
                'Your account is signed in as "$actualRole".',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.slate400, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                  ),
                  child: Text('Back to Home',
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
    );
  }
}
