import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/localization/app_localizations.dart';
import 'auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      _showSnack(ref.tr('login_enter_creds'), isError: true);
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).signInWithEmail(
            email: email,
            password: password,
          );
      if (!mounted) return;
      // Route based on role from profiles
      final profile = await ref.read(currentProfileProvider.future);
      if (!mounted) return;
      _routeByRole(profile?['active_role'] as String? ?? 'shopper');
    } on AuthException catch (e) {
      _showSnack(e.message, isError: true);
    } catch (e) {
      _showSnack(ref.tr('login_failed'), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _routeByRole(String role) {
    switch (role) {
      case 'vendor':
        context.go('/vendor/dashboard');
        break;
      case 'provider':
        context.go('/provider/dashboard');
        break;
      case 'rider':
        context.go('/rider/dashboard');
        break;
      default:
        context.go('/home');
    }
  }

  Future<void> _oauth(OAuthProvider provider) async {
    try {
      await ref.read(authServiceProvider).signInWithOAuth(provider);
      // The auth-state listener in the router redirects once the OAuth
      // round-trip completes.
    } catch (e) {
      if (!mounted) return;
      _showSnack(
          '${provider.name[0].toUpperCase()}${provider.name.substring(1)} sign-in is not configured yet.',
          isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade700 : AppColors.emerald600,
    ));
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
          onPressed: () => context.go('/get-started'),
        ),
        title: Text(ref.tr('app_title'),
            style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.emerald600.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shield_rounded,
                      color: AppColors.emerald600, size: 28),
                ),
              ),
              const SizedBox(height: 24),
              Text(ref.tr('login_welcome'),
                  style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 6),
              Text(ref.tr('login_subtitle'),
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.slate400)),
              const SizedBox(height: 32),
              FieldLabel(ref.tr('login_email')),
              const SizedBox(height: 8),
              InputField(
                controller: _emailCtrl,
                hint: ref.tr('login_email_hint'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              FieldLabel(ref.tr('login_password')),
              const SizedBox(height: 8),
              InputField(
                controller: _passCtrl,
                hint: ref.tr('login_password_hint'),
                obscure: _obscurePass,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.slate400,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePass = !_obscurePass),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.go('/forgot-password'),
                  child: Text(ref.tr('login_forgot'),
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.emerald600,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.emerald600)),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white))
                      : Text(ref.tr('login_btn'),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.slate700)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(ref.tr('or_continue_with'),
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.slate400)),
                  ),
                  const Expanded(child: Divider(color: AppColors.slate700)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Google',
                          onTap: () => _oauth(OAuthProvider.google))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: SocialButton(
                          icon: Icons.apple_rounded,
                          label: 'Apple',
                          onTap: () => _oauth(OAuthProvider.apple))),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/register'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.slate400),
                      children: [
                        TextSpan(text: ref.tr('login_no_account')),
                        TextSpan(
                            text: ref.tr('login_create_account'),
                            style: TextStyle(
                                color: AppColors.emerald600,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
