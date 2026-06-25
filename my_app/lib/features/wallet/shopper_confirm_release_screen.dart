import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/supabase/supabase_config.dart';
import '../../core/localization/app_localizations.dart';

class ShopperConfirmReleaseScreen extends ConsumerStatefulWidget {
  const ShopperConfirmReleaseScreen({super.key});

  @override
  ConsumerState<ShopperConfirmReleaseScreen> createState() =>
      _ShopperConfirmReleaseScreenState();
}

class _ShopperConfirmReleaseScreenState
    extends ConsumerState<ShopperConfirmReleaseScreen> {
  final DatabaseService _dbService = DatabaseService();
  bool _isReleasing = false;
  final _ratings = [5, 4, 5];
  static const _ratingLabels = [
    'Service Quality',
    'Professionalism',
    'Punctuality',
  ];
  static const _ratingBadges = ['Excellent', '', ''];

  @override
  Widget build(BuildContext context) {
    final activeLang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF10221C),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor:
                    const Color(0xFF10221C).withValues(alpha: 0.8),
                floating: true,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg
                          .withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18),
                  ),
                ),
                title: Text(AppLocalizations.translate('confirm_release', activeLang),
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                centerTitle: true,
                actions: const [SizedBox(width: 52)],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Headline
                      Text('Job Completed?',
                          style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.slate400,
                              height: 1.5),
                          children: [
                            const TextSpan(
                                text:
                                    'Review the proof provided by '),
                            TextSpan(
                                text: 'Akinade O.',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.emerald600)),
                            const TextSpan(
                                text:
                                    ' and rate your experience below to release the funds.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Proof of work
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Proof of Work',
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text('3 Photos',
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.emerald600,
                                    letterSpacing: 0.5)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _proofCard(Icons.electrical_services_rounded),
                            const SizedBox(width: 12),
                            _proofCard(Icons.hardware_rounded),
                            const SizedBox(width: 12),
                            _proofCard(Icons.build_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Ratings
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg
                              .withValues(alpha: 0.4),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.05)),
                        ),
                        child: Column(
                          children: List.generate(
                              _ratingLabels.length, (i) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: i <
                                          _ratingLabels.length - 1
                                      ? 20
                                      : 0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Text(_ratingLabels[i],
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.w600,
                                              color:
                                                  Colors.white)),
                                      if (_ratingBadges[i]
                                          .isNotEmpty)
                                        Text(_ratingBadges[i],
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color: AppColors
                                                    .emerald600)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: List.generate(5, (j) {
                                      return GestureDetector(
                                        onTap: () => setState(
                                            () => _ratings[i] = j + 1),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(
                                                  right: 6),
                                          child: Icon(
                                            Icons.star_rounded,
                                            color: j < _ratings[i]
                                                ? AppColors.emerald600
                                                : AppColors.slate700,
                                            size: 28,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // SafePay assurance
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600
                              .withValues(alpha: 0.05),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.verified_user_rounded,
                                color: AppColors.emerald600,
                                size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.translate('safepay_protection', activeLang),
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(
                                      AppLocalizations.translate('safepay_held_msg', activeLang),
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color:
                                              AppColors.slate400,
                                          height: 1.5)),
                                ],
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
              color: const Color(0xFF10221C)
                  .withValues(alpha: 0.95),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.white
                            .withValues(alpha: 0.05))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg
                          .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white
                              .withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('TOTAL RELEASE',
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.slate400,
                                letterSpacing: 1.5)),
                        const SizedBox(width: 8),
                        Text('₦45,000.00',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isReleasing ? null : () async {
                        setState(() => _isReleasing = true);
                        final success = await _dbService.releaseEscrowPayment('MTX-ESC-9921');
                        if (!context.mounted) return;
                        setState(() => _isReleasing = false);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(activeLang == 'Pidgin'
                                  ? 'Escrow release dey successful!'
                                  : (activeLang == 'Igbo'
                                      ? 'A tọhapụla ego escrow nke ọma!'
                                      : 'Escrow payment released successfully!')),
                              backgroundColor: AppColors.emerald600,
                            ),
                          );
                          context.go('/payment-success');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                      ),
                      child: _isReleasing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              '${AppLocalizations.translate('confirm_release', activeLang)} Payment',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        context.go('/escrow-dispute'),
                    icon: const Icon(Icons.flag_rounded,
                        size: 16, color: Color(0xFF94A3B8)),
                    label: Text(AppLocalizations.translate('raise_issue', activeLang),
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate400)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _proofCard(IconData icon) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Center(
        child: Icon(icon,
            color: AppColors.emerald600.withValues(alpha: 0.7),
            size: 40),
      ),
    );
  }
}
