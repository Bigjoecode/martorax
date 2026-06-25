import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ProductBargainScreen extends ConsumerStatefulWidget {
  const ProductBargainScreen({super.key});

  @override
  ConsumerState<ProductBargainScreen> createState() =>
      _ProductBargainScreenState();
}

class _ProductBargainScreenState extends ConsumerState<ProductBargainScreen> {
  int _qty = 1;
  String? _selectedPhrase;
  final _offerCtrl = TextEditingController();

  static const _phrases = [
    'Last price?',
    'Reduce small for me',
    'I fit pay ₦4,000',
    'Oga/Madam, do giveaway',
  ];

  @override
  void dispose() {
    _offerCtrl.dispose();
    super.dispose();
  }

  void _openBargainSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BargainSheet(
        phrases: _phrases,
        selected: _selectedPhrase,
        onSelect: (p) => setState(() => _selectedPhrase = p),
        offerCtrl: _offerCtrl,
      ),
    );
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
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                title: Text(ref.tr('st_product_details'),
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                centerTitle: true,
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share_rounded,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image
                    Container(
                      height: 360,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.emerald600
                                .withValues(alpha: 0.2),
                            AppColors.darkBg,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(Icons.local_florist_rounded,
                                color: Colors.white
                                    .withValues(alpha: 0.3),
                                size: 140),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons.verified_rounded,
                                      color: Colors.white,
                                      size: 14),
                                  const SizedBox(width: 4),
                                  Text('TRUSTED STALL',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: List.generate(4, (i) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets
                                      .symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: i == 0
                                        ? AppColors.emerald600
                                        : Colors.white
                                            .withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Title & price
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, 24, 16, 16),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('Fresh Grade A Tomatoes',
                                    style: GoogleFonts.inter(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.5)),
                                const SizedBox(height: 4),
                                Text(
                                    'Sold per basket (approx. 5kg)',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.white
                                            .withValues(alpha: 0.6))),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text('₦5,000',
                                  style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          AppColors.emerald600)),
                              Text('₦6,500',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white
                                          .withValues(alpha: 0.4),
                                      decoration: TextDecoration
                                          .lineThrough)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Bargain CTA
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, 8, 16, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _openBargainSheet,
                          icon: const Icon(Icons.forum_rounded,
                              color: Colors.white, size: 22),
                          label: Text('Bargain with Seller',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFD97706),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ),
                    // Vendor card
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.05),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          'Ogbogonogo Stall 42',
                                          style:
                                              GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white,
                                          )),
                                      const SizedBox(width: 6),
                                      Icon(
                                          Icons
                                              .verified_user_rounded,
                                          color: AppColors
                                              .emerald600,
                                          size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                          Icons
                                              .location_on_rounded,
                                          color: Colors.white
                                              .withValues(
                                                  alpha: 0.6),
                                          size: 14),
                                      const SizedBox(width: 2),
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      'Asaba • ',
                                                  style:
                                                      GoogleFonts
                                                          .inter(
                                                    fontSize:
                                                        12,
                                                    color: Colors
                                                        .white
                                                        .withValues(
                                                            alpha:
                                                                0.6),
                                                  )),
                                              TextSpan(
                                                  text:
                                                      'Responds in 5 mins',
                                                  style:
                                                      GoogleFonts
                                                          .inter(
                                                    fontSize:
                                                        12,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                    color: AppColors
                                                        .emerald600,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal: 14,
                                        vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                    ),
                                    child: Text('View Stall',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBg,
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white
                                        .withValues(alpha: 0.1)),
                              ),
                              child: Icon(
                                  Icons.storefront_rounded,
                                  color: AppColors.emerald600,
                                  size: 36),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Stock + delivery rows
                    _featureRow(
                      Icons.inventory_2_rounded,
                      'In Stock',
                      '12 baskets available',
                      pulseDot: true,
                    ),
                    _featureRow(
                      Icons.local_shipping_rounded,
                      'Delivery',
                      'Pickup or 30-min delivery',
                    ),
                    const SizedBox(height: 28),
                    // Quick bargain phrases preview
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Text('QUICK BARGAIN PHRASES',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white
                                  .withValues(alpha: 0.5),
                              letterSpacing: 1.5)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _phrases.map((p) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                  () => _selectedPhrase = p);
                              _openBargainSheet();
                            },
                            child: Container(
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 16,
                                  vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.05),
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white
                                        .withValues(alpha: 0.1)),
                              ),
                              child: Text(p,
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w500,
                                      color: Colors.white
                                          .withValues(alpha: 0.8))),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 180),
                  ],
                ),
              ),
            ],
          ),
          // Sticky footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom +
                    16,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkBg.withValues(alpha: 0.95),
                border: Border(
                    top: BorderSide(
                        color: Colors.white
                            .withValues(alpha: 0.1))),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white
                              .withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                              () => _qty = (_qty - 1).clamp(1, 99)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.remove_rounded,
                                color: Colors.white
                                    .withValues(alpha: 0.6),
                                size: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: Text('$_qty',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _qty++),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.add_rounded,
                                color: AppColors.emerald600,
                                size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.go('/cart'),
                        icon: const Icon(
                            Icons.shopping_basket_rounded,
                            color: Colors.white,
                            size: 20),
                        label: Text('Add to Cart',
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.emerald600,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String label, String sub,
      {bool pulseDot = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: AppColors.emerald600, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  Text(sub,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white
                              .withValues(alpha: 0.4))),
                ],
              ),
            ),
            if (pulseDot)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  shape: BoxShape.circle,
                ),
              )
            else
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 20),
          ],
        ),
      ),
    );
  }
}

class _BargainSheet extends StatelessWidget {
  final List<String> phrases;
  final String? selected;
  final ValueChanged<String> onSelect;
  final TextEditingController offerCtrl;

  const _BargainSheet({
    required this.phrases,
    required this.selected,
    required this.onSelect,
    required this.offerCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.slate700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text('Price Bargain',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                    "Negotiate the price with Ogbogonogo Stall 42",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.slate400)),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBg
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.slate700,
                      width: 2,
                      style: BorderStyle.solid),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT ASKING PRICE',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate400,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 6),
                    Text('₦5,000',
                        style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate400,
                            decoration: TextDecoration
                                .lineThrough)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('QUICK NEGOTIATE (ENGLISH & PIDGIN)',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate400,
                      letterSpacing: 1.2)),
              const SizedBox(height: 12),
              ...phrases.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => onSelect(p),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected == p
                              ? AppColors.emerald600
                                  .withValues(alpha: 0.1)
                              : AppColors.surfaceBg
                                  .withValues(alpha: 0.5),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: selected == p
                                  ? AppColors.emerald600
                                  : AppColors.slate700),
                        ),
                        child: Text('"$p"',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
              Text('OR ENTER YOUR OWN OFFER',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate400,
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Text('₦',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate400)),
                          Expanded(
                            child: TextField(
                              controller: offerCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: AppColors.slate400),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24),
                      ),
                      child: Text('Send',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
