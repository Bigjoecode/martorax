import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/localization/app_localizations.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static const int _deliveryFee = 800;
  static const int _safePayFee = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    final itemsTotal = items.fold<int>(
      0,
      (s, i) => s + (i.price * i.quantity).round(),
    );
    final total = itemsTotal + _deliveryFee + _safePayFee;

    final grouped = <String, List<CartItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.vendor, () => []).add(item);
    }
    final isMultiVendor = grouped.length > 1;

    int subtotalFor(List<CartItem> vendorItems) =>
        vendorItems.fold<int>(0, (s, i) => s + (i.price * i.quantity).round());

    void startCheckout(String vendor) {
      ref.read(checkoutVendorProvider.notifier).state = vendor;
      context.go('/checkout/delivery');
    }

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: Text(ref.tr('cart_title'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Colors.white, size: 22),
              tooltip: ref.tr('cart_clear'),
              onPressed: notifier.clearCart,
            ),
        ],
      ),
      body: items.isEmpty
          ? _EmptyCart(
              title: ref.tr('cart_empty_title'),
              subtitle: ref.tr('cart_empty_subtitle'),
              ctaLabel: ref.tr('cart_start_shopping'),
              onShop: () => context.go('/home'),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (isMultiVendor)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: _MultiVendorBanner(
                              message:
                                  'Your cart spans ${grouped.length} vendors. Check out one vendor at a time.',
                            ),
                          ),
                        ...grouped.entries.map((entry) => _VendorGroup(
                              vendorName: entry.key,
                              items: entry.value,
                              subtotal: subtotalFor(entry.value),
                              showCheckoutButton: isMultiVendor,
                              checkoutLabel: ref.tr('cart_checkout_btn'),
                              onIncrease: (item) => notifier.updateQuantity(
                                  item.id, item.quantity + 1),
                              onDecrease: (item) => notifier.updateQuantity(
                                  item.id, item.quantity - 1),
                              onRemove: (item) => notifier.removeItem(item.id),
                              onCheckout: () => startCheckout(entry.key),
                            )),
                        const SizedBox(height: 24),
                        _PaymentSummary(
                          itemsTotal: itemsTotal,
                          deliveryFee: _deliveryFee,
                          safePayFee: _safePayFee,
                          total: total,
                          titleLabel: ref.tr('cart_payment_summary'),
                          itemsLabel: ref.tr('cart_items_total'),
                          deliveryLabel: ref.tr('cart_delivery_fee'),
                          safepayLabel: ref.tr('cart_safepay_fee'),
                          totalLabel: ref.tr('cart_total'),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: items.isEmpty || isMultiVendor
          ? null
          : _BottomBar(
              total: total,
              ctaLabel: ref.tr('cart_checkout_btn'),
              onCheckout: () => startCheckout(grouped.keys.first),
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onShop;
  const _EmptyCart({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onShop,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.slate700),
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  color: AppColors.slate400, size: 44),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.slate400)),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onShop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                ),
                child: Text(ctaLabel,
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorGroup extends StatelessWidget {
  final String vendorName;
  final List<CartItem> items;
  final int subtotal;
  final bool showCheckoutButton;
  final String checkoutLabel;
  final void Function(CartItem) onIncrease;
  final void Function(CartItem) onDecrease;
  final void Function(CartItem) onRemove;
  final VoidCallback onCheckout;

  const _VendorGroup({
    required this.vendorName,
    required this.items,
    required this.subtotal,
    required this.showCheckoutButton,
    required this.checkoutLabel,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.storefront_rounded,
                  color: AppColors.emerald600, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(vendorName,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              if (showCheckoutButton)
                Text('₦${_fmt(subtotal)}',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600)),
            ],
          ),
        ),
        ...items.map((item) => _CartItemRow(
              item: item,
              onIncrease: () => onIncrease(item),
              onDecrease: () => onDecrease(item),
              onRemove: () => onRemove(item),
            )),
        if (showCheckoutButton)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.emerald600, size: 18),
                label: Text('$checkoutLabel · $vendorName',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.emerald600),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MultiVendorBanner extends StatelessWidget {
  final String message;
  const _MultiVendorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.amber500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.amber500.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.amber500, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: GoogleFonts.inter(
                    fontSize: 13, color: Colors.white, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartItemRow({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.slate700.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.slate700),
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.slate400, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text('₦${_fmt(item.price.round())}',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.close_rounded,
                  color: AppColors.slate400, size: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _QtyBtn(label: '-', onTap: onDecrease, filled: false),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${item.quantity}',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                _QtyBtn(label: '+', onTap: onIncrease, filled: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _QtyBtn({required this.label, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppColors.emerald600 : AppColors.surfaceBg,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  final int itemsTotal;
  final int deliveryFee;
  final int safePayFee;
  final int total;
  final String titleLabel;
  final String itemsLabel;
  final String deliveryLabel;
  final String safepayLabel;
  final String totalLabel;

  const _PaymentSummary({
    required this.itemsTotal,
    required this.deliveryFee,
    required this.safePayFee,
    required this.total,
    required this.titleLabel,
    required this.itemsLabel,
    required this.deliveryLabel,
    required this.safepayLabel,
    required this.totalLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleLabel,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate400,
                  letterSpacing: 0.8)),
          const SizedBox(height: 16),
          _SummaryRow(label: itemsLabel, value: '₦${_fmt(itemsTotal)}'),
          const SizedBox(height: 12),
          _SummaryRow(label: deliveryLabel, value: '₦${_fmt(deliveryFee)}'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(safepayLabel,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.slate400)),
                  const SizedBox(width: 4),
                  const Icon(Icons.verified_user_rounded,
                      color: AppColors.emerald600, size: 15),
                ],
              ),
              Text('₦${_fmt(safePayFee)}',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.slate700),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(totalLabel,
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text('₦${_fmt(total)}',
                  style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.emerald600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate400)),
        Text(value, style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int total;
  final String ctaLabel;
  final VoidCallback onCheckout;
  const _BottomBar({
    required this.total,
    required this.ctaLabel,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
              label: Text('$ctaLabel · ₦${_fmt(total)}',
                  style: GoogleFonts.inter(
                      fontSize: 15,
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
    );
  }
}

String _fmt(int n) {
  final s = n.toString();
  if (s.length <= 3) return s;
  final buf = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) buf.write(',');
    buf.write(s[i]);
    count++;
  }
  return buf.toString().split('').reversed.join();
}
