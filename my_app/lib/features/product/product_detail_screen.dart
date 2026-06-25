import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/localization/app_localizations.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _qty = 1;
  bool _isFavourite = false;

  static const _productId = 'leather-tote-001';
  static const _productName = 'Premium Hand-Crafted Leather Tote';
  static const _productPrice = 45000.0;
  static const _productVendor = "Efe's Leather Works";

  void _addToCart() {
    final notifier = ref.read(cartProvider.notifier);
    for (var i = 0; i < _qty; i++) {
      notifier.addItem(const CartItem(
        id: _productId,
        name: _productName,
        price: _productPrice,
        vendor: _productVendor,
      ));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$_qty × $_productName${ref.tr('cart_added_suffix')}'),
      backgroundColor: AppColors.emerald600,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: ref.tr('cart_view'),
        textColor: Colors.white,
        onPressed: () => context.go('/cart'),
      ),
    ));
  }

  void _showBargainSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => const _BargainSheet(),
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
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.darkBg,
                leading: GestureDetector(
                  onTap: () => context.go('/search'),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _isFavourite = !_isFavourite),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavourite
                            ? AppColors.red500
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.share_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.surfaceBg,
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(Icons.shopping_bag_rounded,
                              size: 120,
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.3)),
                        ),
                        Positioned(
                          top: 60,
                          left: 16,
                          child: Row(
                            children: [
                              _Badge(
                                  label: 'HOT DEAL',
                                  color: AppColors.red500),
                              const SizedBox(width: 8),
                              _Badge(
                                  label: '20% OFF',
                                  color: AppColors.amber500),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium Hand-Crafted Leather Tote',
                          style: GoogleFonts.manrope(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2)),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('₦45,000',
                              style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text('₦58,000',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: AppColors.slate400,
                                    decoration:
                                        TextDecoration.lineThrough)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _VendorRow(),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.slate700),
                      const SizedBox(height: 16),
                      Text(ref.tr('pd_description'),
                          style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                        'Authentic cow-hide leather bag, locally sourced and stitched in the heart of Asaba. Durable, water-resistant, and built for everyday use. Available in brown, black, and tan.',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.slate400,
                            height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      _QtySelector(
                        qty: _qty,
                        onDecrease: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                        onIncrease: () => setState(() => _qty++),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomActions(
              onBargain: _showBargainSheet,
              onAddToCart: _addToCart,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }
}

class _VendorRow extends ConsumerWidget {
  const _VendorRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.storefront_rounded,
              color: AppColors.emerald600, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Efe's Leather Works",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.amber500, size: 13),
                  const SizedBox(width: 3),
                  Text('4.8 (124 reviews)',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.slate400)),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.amber500.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(ref.tr('pd_trusted'),
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.amber500)),
        ),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.emerald600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(ref.tr('pd_visit_shop'),
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
      ],
    );
  }
}

class _QtySelector extends ConsumerWidget {
  final int qty;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  const _QtySelector(
      {required this.qty,
      required this.onDecrease,
      required this.onIncrease});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(ref.tr('pd_quantity'),
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate700),
          ),
          child: Row(
            children: [
              _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrease),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$qty',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              _QtyBtn(icon: Icons.add_rounded, onTap: onIncrease),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: AppColors.emerald600, size: 20),
      ),
    );
  }
}

class _BottomActions extends ConsumerWidget {
  final VoidCallback onBargain;
  final VoidCallback onAddToCart;
  const _BottomActions({required this.onBargain, required this.onAddToCart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: const Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBargain,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.emerald600),
              ),
              child: Row(
                children: [
                  const Icon(Icons.handshake_rounded,
                      color: AppColors.emerald600, size: 20),
                  const SizedBox(width: 6),
                  Text(ref.tr('pd_bargain'),
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emerald600)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(ref.tr('pd_add_to_cart'),
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BargainSheet extends ConsumerWidget {
  const _BargainSheet();

  static const _phrases = [
    'Can you do ₦40,000?',
    'Any discount for two?',
    'Free delivery if I add one more?',
    'Fit do am for ₦38,000?',
    'If na two, you go reduce?',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(ref.tr('st_product_bargain'),
                style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text('Pick a phrase or type your own offer',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.slate400)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _phrases
                  .map((p) => GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.emerald600
                                    .withValues(alpha: 0.4)),
                          ),
                          child: Text(p,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.emerald600,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: GoogleFonts.inter(
                        fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your offer...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.slate400),
                      filled: true,
                      fillColor: AppColors.surfaceBg,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.slate700),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.slate700),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.emerald600, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.emerald600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
