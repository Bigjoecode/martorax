import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class AiSmartQuoteScreen extends ConsumerStatefulWidget {
  const AiSmartQuoteScreen({super.key});

  @override
  ConsumerState<AiSmartQuoteScreen> createState() =>
      _AiSmartQuoteScreenState();
}

class _AiSmartQuoteScreenState extends ConsumerState<AiSmartQuoteScreen> {
  final _descCtrl = TextEditingController(
      text:
          'AC maintenance for 2HP Samsung unit. Needs checking for leaks and potential gas refill.');
  final _laborCtrl = TextEditingController(text: '8,500');
  final _materialCtrl = TextEditingController(text: '3,200');

  @override
  void dispose() {
    _descCtrl.dispose();
    _laborCtrl.dispose();
    _materialCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor:
                    AppColors.darkBg.withValues(alpha: 0.8),
                pinned: true,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 20),
                ),
                title: Text(ref.tr('st_ai_smart_quote'),
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.history_rounded,
                        color: AppColors.emerald600, size: 22),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 8, 16, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client context
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('CLIENT LOCATION',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: AppColors.slate400,
                                      letterSpacing: 1.5)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      color: AppColors
                                          .emerald600,
                                      size: 14),
                                  const SizedBox(width: 4),
                                  Text('Asaba, Delta State',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w500,
                                          color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text('DATE',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: AppColors.slate400,
                                      letterSpacing: 1.5)),
                              const SizedBox(height: 4),
                              Text('Oct 24, 2023',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Service description
                      Text('Service Description',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate400)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg
                              .withValues(alpha: 0.5),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
                        ),
                        child: TextField(
                          controller: _descCtrl,
                          maxLines: 4,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              height: 1.5),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.all(16),
                            hintText:
                                'e.g. Split Unit AC repair and gas refill...',
                            hintStyle: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.slate400),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // AI recommendation
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600
                              .withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.2)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.emerald600
                                    .withValues(alpha: 0.2),
                                blurRadius: 15),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                color: AppColors.emerald600,
                                size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'AI Smart Recommendation',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: AppColors
                                              .emerald600)),
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors
                                              .emerald600
                                              .withValues(
                                                  alpha: 0.9),
                                          height: 1.5),
                                      children: [
                                        const TextSpan(
                                            text:
                                                'AC repairs in Asaba typically range from '),
                                        TextSpan(
                                            text:
                                                '₦8,000 - ₦12,000',
                                            style: GoogleFonts
                                                .inter(
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight
                                                      .w700,
                                              color: AppColors
                                                  .emerald600,
                                            )),
                                        const TextSpan(
                                            text:
                                                ' based on current market trends.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Pricing breakdown
                      Text('PRICING BREAKDOWN',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate400,
                              letterSpacing: 1.5)),
                      const SizedBox(height: 16),
                      _PricingField(
                        controller: _laborCtrl,
                        label: 'Labor Cost',
                        badge: 'MARKET RATE',
                        badgeColor: AppColors.slate700,
                        badgeTextColor: AppColors.slate400,
                      ),
                      const SizedBox(height: 16),
                      _PricingField(
                        controller: _materialCtrl,
                        label: 'Material Cost',
                        badge: 'AI SUGGESTED',
                        badgeColor: AppColors.emerald600
                            .withValues(alpha: 0.2),
                        badgeTextColor: AppColors.emerald600,
                        hint:
                            'Includes R22 Gas Refill (Asaba Market Board avg.)',
                      ),
                      const SizedBox(height: 24),
                      // Total card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg
                              .withValues(alpha: 0.4),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.slate700
                                  .withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Quote Amount',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w500,
                                        color:
                                            AppColors.slate400)),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald600
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            6),
                                  ),
                                  child: Text(
                                      'PROFITABLE RANGE',
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: AppColors
                                              .emerald600,
                                          letterSpacing: 0.5)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('₦11,700',
                                style: GoogleFonts.inter(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg.withValues(alpha: 0.95),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.slate700)),
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.send_rounded,
                            color: Colors.white, size: 20),
                        label: Text('Send Quote',
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
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.save_rounded,
                        color: AppColors.slate400, size: 24),
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

class _PricingField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String? hint;

  const _PricingField({
    required this.controller,
    required this.label,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(badge,
                  style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor,
                      letterSpacing: 0.5)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surfaceBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate700),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Text('₦',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.slate400)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.emerald600
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.auto_fix_high_rounded,
                    color: AppColors.emerald600, size: 20),
              ),
            ],
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(hint!,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.slate400)),
        ],
      ],
    );
  }
}
