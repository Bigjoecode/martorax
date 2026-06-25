import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/localization/app_localizations.dart';
import 'auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final password = _passCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack(ref.tr('reg_required'), isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnack(ref.tr('reg_password_short'), isError: true);
      return;
    }

    final role = ref.read(pendingSignupRoleProvider);

    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).signUpWithEmail(
            email: email,
            password: password,
            fullName: name,
            phoneNumber: phone.isEmpty ? null : '+234$phone',
            role: role,
          );
      if (!mounted) return;
      _showSnack(ref.tr('reg_success'));
      _routeByRole(role);
    } on AuthException catch (e) {
      _showSnack(e.message, isError: true);
    } catch (e) {
      _showSnack(ref.tr('reg_failed'), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _routeByRole(String role) {
    switch (role) {
      case 'vendor':
        // Business info first; KYC handled out-of-band for the pilot.
        context.go('/vendor/register');
        break;
      case 'provider':
        context.go('/provider/register');
        break;
      case 'rider':
        context.go('/rider/register');
        break;
      default:
        context.go('/home');
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.go('/role'),
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
              const SizedBox(height: 24),
              Text(ref.tr('reg_title'),
                  style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Text(ref.tr('reg_subtitle'),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.slate400,
                      height: 1.4)),
              const SizedBox(height: 28),
              FieldLabel(ref.tr('reg_full_name')),
              const SizedBox(height: 8),
              InputField(controller: _nameCtrl, hint: ref.tr('reg_full_name_hint')),
              const SizedBox(height: 20),
              FieldLabel(ref.tr('login_email')),
              const SizedBox(height: 8),
              InputField(
                controller: _emailCtrl,
                hint: ref.tr('login_email_hint'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              FieldLabel(ref.tr('reg_phone')),
              const SizedBox(height: 8),
              _PhoneField(controller: _phoneCtrl),
              const SizedBox(height: 20),
              FieldLabel(ref.tr('login_password')),
              const SizedBox(height: 8),
              InputField(
                controller: _passCtrl,
                hint: '••••••••',
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
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleSignup,
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
                      : Text(ref.tr('reg_btn'),
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
                          onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(
                      child: SocialButton(
                          icon: Icons.apple_rounded,
                          label: 'Apple',
                          onTap: () {})),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/login'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.slate400),
                      children: [
                        TextSpan(text: ref.tr('reg_already_have_account')),
                        TextSpan(
                            text: ref.tr('reg_login'),
                            style: TextStyle(
                                color: AppColors.emerald600,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
      decoration: InputDecoration(
        hintText: '803 000 0000',
        hintStyle:
            GoogleFonts.inter(fontSize: 15, color: AppColors.slate400),
        filled: true,
        fillColor: AppColors.cardBg,
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('+234',
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              const SizedBox(width: 8),
              Container(width: 1, height: 20, color: AppColors.slate700),
            ],
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.slate700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.slate700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.emerald600, width: 1.5),
        ),
      ),
    );
  }
}
