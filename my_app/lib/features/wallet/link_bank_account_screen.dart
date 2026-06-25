import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class LinkBankAccountScreen extends ConsumerStatefulWidget {
  const LinkBankAccountScreen({super.key});

  @override
  ConsumerState<LinkBankAccountScreen> createState() => _LinkBankAccountScreenState();
}

class _LinkBankAccountScreenState extends ConsumerState<LinkBankAccountScreen> {
  String? _selectedBank;
  bool _isPrimary = true;
  final _accountCtrl = TextEditingController();

  static const _banks = [
    'Guaranty Trust Bank (GTB)',
    'Zenith Bank',
    'Access Bank',
    'Kuda Bank',
    'First Bank of Nigeria',
    'United Bank for Africa (UBA)',
  ];

  @override
  void dispose() {
    _accountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_wallet_link_bank'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Connect your local Nigerian bank account to receive vendor payouts securely and automatically.',
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.slate400,
                      height: 1.6),
                ),
                const SizedBox(height: 32),
                // Select Bank
                _Label('Select Bank'),
                const SizedBox(height: 8),
                _DropdownField(
                  hint: 'Choose a Nigerian bank',
                  value: _selectedBank,
                  items: _banks,
                  onChanged: (v) => setState(() => _selectedBank = v),
                ),
                const SizedBox(height: 24),
                // Account Number
                _Label('Account Number'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _accountCtrl,
                  hint: 'e.g. 0123456789',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                const SizedBox(height: 24),
                // Account Name (verified)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Label('Account Name'),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded,
                            color: AppColors.emerald600, size: 14),
                        const SizedBox(width: 4),
                        Text('VERIFIED',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.emerald600,
                                letterSpacing: 0.5)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.slate700, style: BorderStyle.solid),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('OLAWALE ADEBAYO CHUKWUMA',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate400)),
                  ),
                ),
                const SizedBox(height: 24),
                // Info box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.emerald600.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.emerald600.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppColors.emerald600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ensure account name matches your registered MartoraX name for fast, hassle-free payouts.',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Set as primary toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Set as Primary',
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text('Use this for all future payouts',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.slate400)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isPrimary = !_isPrimary),
                      child: _ToggleSwitch(value: _isPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.link_rounded,
                          color: Colors.black, size: 20),
                      label: Text('Link Account',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          color: AppColors.slate400, size: 12),
                      const SizedBox(width: 4),
                      Text('Secure bank-grade 256-bit encryption',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.slate400)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.75)));
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  const _InputField(
      {required this.controller,
      required this.hint,
      required this.keyboardType,
      required this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.inter(fontSize: 14, color: AppColors.slate400),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField(
      {required this.hint,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
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
                  fontSize: 14, color: AppColors.slate400)),
          dropdownColor: AppColors.cardBg,
          isExpanded: true,
          icon: Icon(Icons.expand_more_rounded,
              color: AppColors.slate400, size: 20),
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
          items: items
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  const _ToggleSwitch({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: value ? AppColors.emerald600 : AppColors.slate700,
        borderRadius: BorderRadius.circular(14),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 150),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
