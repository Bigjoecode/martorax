import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_config.dart';
import '../auth/auth_widgets.dart';

class VendorRegisterScreen extends ConsumerStatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  ConsumerState<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends ConsumerState<VendorRegisterScreen> {
  final _businessNameCtrl = TextEditingController();
  final _stallCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _selectedMarket = '';
  String _vendorType = 'Retailer';
  bool _loading = false;

  Future<void> _submit() async {
    final name = _businessNameCtrl.text.trim();
    final stall = _stallCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || stall.isEmpty || _selectedMarket.isEmpty) {
      _showSnack('Business name, market and stall are required',
          isError: true);
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      _showSnack('You need to be signed in', isError: true);
      return;
    }

    setState(() => _loading = true);
    try {
      await SupabaseConfig.client.from('profiles').update({
        'business_name': name,
        'business_market': _selectedMarket,
        'business_stall': stall,
        'business_type': _vendorType,
        if (phone.isNotEmpty) 'phone_number': '+234$phone',
        'onboarding_completed': true,
      }).eq('id', user.id);

      if (!mounted) return;
      _showSnack('Stall created!');
      context.go('/vendor/dashboard');
    } catch (e) {
      _showSnack('Could not save: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade700 : AppColors.emerald600,
    ));
  }

  static const _markets = [
    'Ogbogonogo Market',
    'Coke Market',
    'Cable Point Market',
    'Abraka Market',
    'DBS Road Market',
  ];

  static const _vendorTypes = ['Retailer', 'Wholesaler', 'Manufacturer'];

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _stallCtrl.dispose();
    _phoneCtrl.dispose();
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
          onPressed: () => context.go('/role'),
        ),
        title: Text(ref.tr('st_vendor_register'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.manrope(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2),
                        children: [
                          const TextSpan(text: 'Open Your '),
                          TextSpan(
                              text: 'Digital Stall',
                              style: TextStyle(color: AppColors.emerald600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Join the largest commerce network in Asaba.',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.slate400)),
                    const SizedBox(height: 28),
                    const FieldLabel('Business Name'),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _businessNameCtrl,
                      hint: "e.g. Chioma's Textiles",
                    ),
                    const SizedBox(height: 20),
                    const FieldLabel('Vendor Type'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: _vendorTypes.map((type) {
                        final isSelected = _vendorType == type;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _vendorType = type),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.emerald600
                                  : AppColors.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.emerald600
                                    : AppColors.slate700,
                              ),
                            ),
                            child: Text(type,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.slate400)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const FieldLabel('Market Selection'),
                    const SizedBox(height: 8),
                    _DropdownField(
                      value: _selectedMarket.isEmpty
                          ? null
                          : _selectedMarket,
                      hint: 'Select your market location',
                      items: _markets,
                      onChanged: (v) =>
                          setState(() => _selectedMarket = v ?? ''),
                    ),
                    const SizedBox(height: 20),
                    const FieldLabel('Stall / Shop Number'),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _stallCtrl,
                      hint: 'e.g. Block B, Line 4, No. 22',
                    ),
                    const SizedBox(height: 20),
                    const FieldLabel('Phone Number'),
                    const SizedBox(height: 8),
                    _PhoneField(controller: _phoneCtrl),
                    const SizedBox(height: 20),
                    _InfoCard(
                      icon: Icons.lightbulb_outline_rounded,
                      color: AppColors.blue500,
                      text:
                          'Joining a market cluster helps local shoppers find you faster based on their proximity.',
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
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
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Create My Stall',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.storefront_rounded,
                                      color: Colors.white, size: 18),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'By creating a stall, you agree to MartoraX Vendor\nTerms and Community Guidelines.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.slate400),
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

class _DropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: GoogleFonts.inter(
                  fontSize: 15, color: AppColors.slate400)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.slate400),
          dropdownColor: AppColors.cardBg,
          isExpanded: true,
          style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
          items: items
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: onChanged,
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
    return Row(
      children: [
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate700),
          ),
          child: Center(
            child: Text('+234',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
            decoration: InputDecoration(
              hintText: '801 234 5678',
              hintStyle: GoogleFonts.inter(
                  fontSize: 15, color: AppColors.slate400),
              filled: true,
              fillColor: AppColors.cardBg,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
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
                borderSide: const BorderSide(
                    color: AppColors.emerald600, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _InfoCard(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter(
                    fontSize: 13, color: Colors.white, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
