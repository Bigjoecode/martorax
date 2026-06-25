import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/localization/app_localizations.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(languageProvider);
  }

  static const _languages = [
    ('English', 'Standard English', Icons.language_rounded),
    ('Pidgin', 'Naija Pidgin', Icons.chat_bubble_outline_rounded),
    ('Igbo', 'Ásụ̀sụ̀ Ìgbò', Icons.public_rounded),
    ('Yoruba', 'Èdè Yorùbá', Icons.translate_rounded),
    ('Hausa', 'Harshen Hausa', Icons.menu_book_rounded),
  ];

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
          onPressed: () => context.go('/onboarding'),
        ),
        title: Text(ref.tr('lang_select_appbar'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ref.tr('lang_title'),
                  style: GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                ref.tr('lang_subtitle'),
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.slate400, height: 1.5),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final (name, subtitle, icon) = _languages[i];
                    final isSelected = _selected == name;
                    return GestureDetector(
                      onTap: () => setState(() => _selected = name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
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
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.emerald600.withValues(alpha: 0.2)
                                    : AppColors.surfaceBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(icon,
                                  color: isSelected
                                      ? AppColors.emerald600
                                      : AppColors.slate400,
                                  size: 20),
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
                                  Text(subtitle,
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.slate400)),
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(languageProvider.notifier).setLanguage(_selected);
                    if (!context.mounted) return;
                    context.go('/get-started');
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
            ],
          ),
        ),
      ),
    );
  }
}
