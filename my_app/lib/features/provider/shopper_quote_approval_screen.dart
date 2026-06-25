import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ShopperQuoteApprovalScreen extends ConsumerWidget {
  const ShopperQuoteApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: const Icon(Icons.chevron_left_rounded,
                      color: Colors.white, size: 32),
                ),
                title: Text(ref.tr('st_quote_approval'),
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                centerTitle: true,
                actions: const [SizedBox(width: 52)],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(24, 24, 24, 220),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Provider card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.05),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceBg,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            AppColors.emerald600,
                                        width: 2),
                                  ),
                                  child: Icon(
                                      Icons
                                          .electrical_services_rounded,
                                      color:
                                          AppColors.emerald600,
                                      size: 40),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.emerald600,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color:
                                              AppColors.darkBg,
                                          width: 2),
                                    ),
                                    child: const Icon(
                                        Icons.verified_rounded,
                                        color: Colors.white,
                                        size: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                            'Okonkwo Services',
                                            style: GoogleFonts.inter(
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 6,
                                                vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .emerald600
                                              .withValues(
                                                  alpha: 0.2),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(20),
                                          border: Border.all(
                                              color: AppColors
                                                  .emerald600
                                                  .withValues(
                                                      alpha:
                                                          0.3)),
                                        ),
                                        child: Text('PRO',
                                            style:
                                                GoogleFonts.inter(
                                              fontSize: 9,
                                              fontWeight:
                                                  FontWeight.w800,
                                              color: AppColors
                                                  .emerald600,
                                              letterSpacing: 1.0,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Professional Electrician • Asaba',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w500,
                                          color: AppColors
                                              .slate400)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.star_rounded,
                                          color: Color(
                                              0xFFFBBF24),
                                          size: 14),
                                      const SizedBox(width: 4),
                                      Text('4.9 (124 reviews)',
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: AppColors
                                                  .slate400)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Itemized Quote',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.05),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            _quoteRow('Service Description',
                                'AC Installation & Electrical Wiring',
                                hasBottomBorder: true),
                            _quoteRow('Material Cost', '₦24,500',
                                hasBottomBorder: true),
                            _quoteRow(
                                'Labor Cost', '₦12,000'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Total
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600
                              .withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount',
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        AppColors.emerald600)),
                            Text('₦36,500',
                                style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        AppColors.emerald600,
                                    letterSpacing: -0.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // SafePay banner
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
                            Icon(Icons.shield_rounded,
                                color: AppColors.emerald600,
                                size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('SafePay Protection',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: AppColors
                                              .emerald600)),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Your payment is held securely in escrow. Funds are only released to the pro once you confirm the work is completed to your satisfaction.',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors
                                              .emerald600
                                              .withValues(
                                                  alpha: 0.8),
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
          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.slate700)),
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    MediaQuery.of(context).padding.bottom + 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.go('/checkout/payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                      ),
                      child: Text('Approve & Pay (₦36,500)',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppColors.slate700,
                            width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                      ),
                      child: Text('Decline / Counter',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate400)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(Icons.home_rounded, 'Home',
                          false, () => context.go('/home')),
                      _NavItem(
                          Icons.assignment_rounded,
                          'Quotes',
                          true,
                          () {}),
                      _NavItem(Icons.chat_bubble_rounded,
                          'Messages', false, () {}),
                      _NavItem(Icons.person_rounded, 'Profile',
                          false, () => context.go('/profile')),
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

  Widget _quoteRow(String label, String value,
      {bool hasBottomBorder = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: hasBottomBorder
            ? Border(
                bottom: BorderSide(color: AppColors.slate700))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate400)),
          ),
          SizedBox(
            width: 180,
            child: Text(value,
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(this.icon, this.label, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: active
                  ? AppColors.emerald600
                  : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
