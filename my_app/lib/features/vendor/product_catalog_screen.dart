import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ProductCatalogScreen extends ConsumerStatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  ConsumerState<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends ConsumerState<ProductCatalogScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Select Category';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_vendor_catalog'),
            style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Cancel',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.slate400,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 130),
            child: Column(
              children: [
                // Step indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _stepDot(true),
                      const SizedBox(width: 8),
                      _stepDot(false),
                      const SizedBox(width: 8),
                      _stepDot(false),
                    ],
                  ),
                ),
                // Step 1: Photos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Step 1: Product Photos',
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text('Up to 6',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.slate400)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: 6,
                        itemBuilder: (_, i) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBg
                                  .withValues(alpha: 0.5),
                              borderRadius:
                                  BorderRadius.circular(12),
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
                                  i == 0
                                      ? Icons.add_a_photo_rounded
                                      : Icons.add_rounded,
                                  color: i == 0
                                      ? AppColors.emerald600
                                      : AppColors.slate400,
                                  size: 24,
                                ),
                                if (i == 0) ...[
                                  const SizedBox(height: 4),
                                  Text('MAIN',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.w800,
                                          color: AppColors
                                              .emerald600,
                                          letterSpacing: 0.5)),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Step 2: Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Step 2: Product Info',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 16),
                      _fieldLabel('Product Name'),
                      _textField(_nameCtrl,
                          'e.g. Fresh Ogbogonogo Peppers'),
                      const SizedBox(height: 16),
                      _fieldLabel('Category'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _category,
                            isExpanded: true,
                            dropdownColor: AppColors.cardBg,
                            icon: Icon(Icons.expand_more_rounded,
                                color: AppColors.slate400),
                            style: GoogleFonts.inter(
                                fontSize: 14, color: Colors.white),
                            items: const [
                              'Select Category',
                              'Farm Produce',
                              'Spices & Seasoning',
                              'Grains & Cereals',
                              'Fashion',
                              'Electronics',
                            ]
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            vertical: 14),
                                        child: Text(c),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _category = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Step 3: AI Pricing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Step 3: AI Smart Price',
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.auto_awesome_rounded,
                                    color: AppColors.emerald600,
                                    size: 12),
                                const SizedBox(width: 4),
                                Text('SMART AI',
                                    style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: AppColors
                                            .emerald600,
                                        letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Asking Price (₦)',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            AppColors.slate400)),
                                Row(
                                  children: [
                                    Text('Ogbogonogo Board',
                                        style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: AppColors
                                                .slate400)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.info_outline_rounded,
                                        color: AppColors.slate400,
                                        size: 12),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _priceCtrl,
                                    keyboardType:
                                        TextInputType.number,
                                    style: GoogleFonts.inter(
                                        fontSize: 24,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: '5,000',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 24,
                                          color:
                                              AppColors.slate400),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald600
                                        .withValues(alpha: 0.2),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.emerald600
                                            .withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                      'Suggested: ₦4,850',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: AppColors
                                              .emerald600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _fieldLabel('Description'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.auto_fix_high_rounded,
                                    color: AppColors.emerald600,
                                    size: 14),
                                const SizedBox(width: 4),
                                Text('AI Description',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: AppColors
                                            .emerald600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _textField(_descCtrl,
                          'Describe your product here...',
                          maxLines: 4),
                      const SizedBox(height: 6),
                      Text(
                          '"Catchy local descriptions attract 3x more buyers in the market."',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: AppColors.slate400)),
                    ],
                  ),
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
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkBg.withValues(alpha: 0.95),
                border: Border(
                    top: BorderSide(color: AppColors.slate700)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/vendor/inventory'),
                  icon: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                  label: Text('Continue to Review',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepDot(bool active) {
    return Container(
      width: 48,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColors.emerald600 : AppColors.cardBg,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.slate400)),
    );
  }

  Widget _textField(TextEditingController c, String hint,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
              fontSize: 14, color: AppColors.slate400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
