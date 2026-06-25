import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/supabase/supabase_config.dart';
import '../../core/localization/app_localizations.dart';

class EscrowDisputeScreen extends ConsumerStatefulWidget {
  const EscrowDisputeScreen({super.key});

  @override
  ConsumerState<EscrowDisputeScreen> createState() =>
      _EscrowDisputeScreenState();
}

class _EscrowDisputeScreenState extends ConsumerState<EscrowDisputeScreen> {
  int _selectedReason = 0;
  final TextEditingController _detailsController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  static const _reasons = [
    _Reason(Icons.inventory_2_rounded, 'Item not received'),
    _Reason(Icons.sentiment_dissatisfied_rounded, 'Poor quality'),
    _Reason(Icons.wrong_location_rounded, 'Wrong item'),
  ];

  @override
  Widget build(BuildContext context) {
    final activeLang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF0F172A),
                pinned: true,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 20),
                ),
                title: Text('${AppLocalizations.translate('raise_dispute', activeLang)} Wizard',
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Text('Help',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emerald600)),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(0, 0, 0, 200),
                  child: Column(
                    crossAxisAlignment:
                      CrossAxisAlignment.start,
                    children: [
                      // Step indicator
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.slate700,
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.slate700,
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SafePay banner
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF022C22)
                                .withValues(alpha: 0.8),
                            borderRadius:
                                BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    const Color(0xFF064E3B)
                                        .withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                  Icons.verified_user_rounded,
                                  color: Color(0xFF10B981),
                                  size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: const Color(
                                            0xFFD1FAE5)
                                            .withValues(alpha: 0.9),
                                        height: 1.5),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${AppLocalizations.translate('safepay_protection', activeLang)}: ',
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: const Color(
                                                  0xFF34D399))),
                                      TextSpan(
                                          text:
                                              AppLocalizations.translate('safepay_held_msg', activeLang)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // What is the problem
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.translate('what_is_problem', activeLang),
                                style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(
                                'Select the option that best describes your issue.',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate400)),
                            const SizedBox(height: 16),
                            ..._reasons.asMap().entries.map((e) {
                              final i = e.key;
                              final r = e.value;
                              final selected = _selectedReason == i;
                              return GestureDetector(
                                onTap: () => setState(
                                    () => _selectedReason = i),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10),
                                  padding: const EdgeInsets.all(
                                      15),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.emerald600
                                            .withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                        color: selected
                                            ? AppColors.emerald600
                                            : AppColors.slate700),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(r.icon,
                                          color: AppColors.slate400,
                                          size: 22),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(r.label,
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w500,
                                                color: Colors.white)),
                                      ),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: selected
                                                  ? AppColors
                                                      .emerald600
                                                  : AppColors
                                                      .slate700,
                                              width: 2),
                                          color: selected
                                              ? AppColors.emerald600
                                              : Colors.transparent,
                                        ),
                                        child: selected
                                            ? Center(
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors
                                                        .white,
                                                    shape: BoxShape
                                                        .circle,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Upload evidence
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.translate('upload_evidence', activeLang),
                                style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(
                                AppLocalizations.translate('evidence_hint', activeLang),
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate400)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 96,
                              child: Row(
                                children: [
                                  // Add media
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceBg
                                          .withValues(alpha: 0.4),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.slate700,
                                          width: 2,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            Icons.add_a_photo_rounded,
                                            color:
                                                AppColors.emerald600,
                                            size: 24),
                                        const SizedBox(height: 4),
                                        Text('ADD MEDIA',
                                            style: GoogleFonts.inter(
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color:
                                                    AppColors.emerald600)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Photo thumbnails
                                  ...[
                                    Icons.inventory_2_rounded,
                                    Icons.receipt_long_rounded
                                  ].map((ic) => Container(
                                        width: 96,
                                        height: 96,
                                        margin: const EdgeInsets.only(
                                            right: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceBg,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Icon(ic,
                                                  color: AppColors
                                                      .slate400,
                                                  size: 32),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets
                                                        .all(2),
                                                decoration:
                                                    BoxDecoration(
                                                  color: Colors.black
                                                      .withValues(
                                                          alpha: 0.6),
                                                  shape:
                                                      BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                    Icons.close_rounded,
                                                    color:
                                                        Colors.white,
                                                    size: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Additional details textarea
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.translate('details_optional', activeLang),
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate400)),
                            const SizedBox(height: 8),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBg
                                    .withValues(alpha: 0.4),
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.slate700),
                              ),
                              child: TextField(
                                controller: _detailsController,
                                maxLines: null,
                                expands: true,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      'Tell us more about what happened...',
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.slate400),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.all(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Fixed footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF0F172A)
                  .withValues(alpha: 0.9),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.slate700)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : () async {
                        setState(() => _isSubmitting = true);
                        final reason = _reasons[_selectedReason].label;
                        final details = _detailsController.text;
                        final success = await _dbService.initiateDispute('MTX-9921-ASB', reason, details);
                        if (!context.mounted) return;
                        setState(() => _isSubmitting = false);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(activeLang == 'Pidgin'
                                  ? 'We don hold your payment! We dey check the wahala.'
                                  : (activeLang == 'Igbo'
                                      ? 'Anyị ejidela ego gị! Anyị na-enyocha ya.'
                                      : 'SafePay has held the funds. We are reviewing the dispute.')),
                              backgroundColor: AppColors.emerald600,
                            ),
                          );
                          context.pop();
                        }
                      },
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.gavel_rounded,
                              color: Colors.white, size: 20),
                      label: Text(
                          _isSubmitting
                              ? 'Submitting...'
                              : AppLocalizations.translate('raise_dispute', activeLang),
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('CASE #MTX-9921-ASB',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate400,
                          letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Reason {
  final IconData icon;
  final String label;
  const _Reason(this.icon, this.label);
}
