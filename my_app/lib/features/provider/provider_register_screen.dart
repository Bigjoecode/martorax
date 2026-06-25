import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_config.dart';
import '../auth/auth_widgets.dart';

class ProviderRegisterScreen extends ConsumerStatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  ConsumerState<ProviderRegisterScreen> createState() =>
      _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends ConsumerState<ProviderRegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _selectedCategory = '';
  bool _loading = false;

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final yearsText = _experienceCtrl.text.trim();
    final years = int.tryParse(yearsText);

    if (name.isEmpty || _selectedCategory.isEmpty) {
      _showSnack('Name and service category are required', isError: true);
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
        'full_name': name,
        'service_category': _selectedCategory,
        if (years != null) 'service_experience_years': years,
        if (phone.isNotEmpty) 'phone_number': '+234$phone',
        'onboarding_completed': true,
      }).eq('id', user.id);

      if (!mounted) return;
      _showSnack('Profile saved!');
      context.go('/kyc/verify');
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

  static const _categories = [
    'Plumber',
    'Electrician',
    'Tailor / Fashion Designer',
    'Makeup Artist',
    'Photographer / Videographer',
    'Private Tutor',
    'Carpenter',
    'Welder / Fabricator',
    'AC Technician',
    'Generator Technician',
    'House Cleaner',
    'Event Decorator',
    'Graphic Designer',
    'Web / App Developer',
    'Other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _experienceCtrl.dispose();
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
        title: Text(ref.tr('st_provider_register'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Join as a Professional',
                  style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 6),
              Text('Help Asaba find your expertise.',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.slate400)),
              const SizedBox(height: 28),
              const FieldLabel('Full Name'),
              const SizedBox(height: 8),
              InputField(
                controller: _nameCtrl,
                hint: 'e.g. John Doe',
              ),
              const SizedBox(height: 20),
              const FieldLabel('Service Category'),
              const SizedBox(height: 8),
              _CategoryDropdown(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                items: _categories,
                onChanged: (v) =>
                    setState(() => _selectedCategory = v ?? ''),
              ),
              const SizedBox(height: 20),
              const FieldLabel('Years of Experience'),
              const SizedBox(height: 8),
              InputField(
                controller: _experienceCtrl,
                hint: 'Years',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const FieldLabel('Phone Number'),
              const SizedBox(height: 8),
              _ProviderPhoneField(controller: _phoneCtrl),
              const SizedBox(height: 20),
              _ProTipCard(),
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
                            Text(ref.tr('continue'),
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 18),
                          ],
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

class _CategoryDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _CategoryDropdown({
    required this.value,
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
          hint: Text('Select category',
              style: GoogleFonts.inter(
                  fontSize: 15, color: AppColors.slate400)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.slate400),
          dropdownColor: AppColors.cardBg,
          isExpanded: true,
          style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
          items: items
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ProviderPhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _ProviderPhoneField({required this.controller});

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

class _ProTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emerald600.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.emerald600.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded,
              color: AppColors.emerald600, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pro Tip',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600)),
                const SizedBox(height: 2),
                Text(
                  'Providers with a complete profile and verified ID get 3x more booking requests.',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: Colors.white, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
