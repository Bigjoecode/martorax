import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/supabase/paystack_payment_service.dart';

class CheckoutPaymentScreen extends ConsumerStatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  ConsumerState<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends ConsumerState<CheckoutPaymentScreen> {
  int _selected = 0;

  static const _methods = [
    _PayMethod('MartoraX Wallet', 'Balance: ₦15,500.00', Icons.account_balance_wallet_rounded),
    _PayMethod('Bank Transfer', 'Transfer from your bank app', Icons.account_balance_rounded),
    _PayMethod('Debit Card', 'Visa, Mastercard, Verve', Icons.credit_card_rounded),
    _PayMethod('USSD', 'Dial a code to pay directly', Icons.dialpad_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/checkout/delivery'),
        ),
        title: Text(ref.tr('st_checkout_payment'),
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.emerald600.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Asaba',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.emerald600)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SafePay banner
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.emerald600.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.emerald600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ref.tr('co_payment_protected'),
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                                const SizedBox(height: 4),
                                Text(
                                  'Your funds are held securely and only released to the seller after you confirm delivery in Asaba.',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.slate400,
                                      height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Payment method list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(ref.tr('st_checkout_payment'),
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate400,
                            letterSpacing: 1.0)),
                  ),
                  const SizedBox(height: 12),
                  ..._methods.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: _PayMethodCard(
                          method: e.value,
                          selected: _selected == e.key,
                          onTap: () => setState(() => _selected = e.key),
                        ),
                      )),

                  const SizedBox(height: 8),

                  // Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(ref.tr('co_order_summary'),
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate400,
                            letterSpacing: 1.0)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _SumRow(label: 'Order Subtotal', value: '₦12,400.00'),
                        const SizedBox(height: 12),
                        _SumRow(label: 'Delivery Fee (Asaba Central)', value: '₦1,200.00'),
                        const SizedBox(height: 12),
                        _SumRow(label: 'Service Fee', value: '₦150.00'),
                        Divider(color: AppColors.slate700, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ref.tr('cart_total'),
                                style: GoogleFonts.inter(
                                    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                            Text('₦13,750.00',
                                style: GoogleFonts.inter(
                                    fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              border: Border(top: BorderSide(color: AppColors.slate700)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final cart = ref.read(activeCheckoutItemsProvider);
                      if (cart.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your cart is empty')),
                        );
                        return;
                      }
                      final items = cart
                          .map((c) => CheckoutItem(
                              productId: c.id, quantity: c.quantity))
                          .toList();
                      context.go(
                        '/checkout/paystack',
                        extra: {
                          'items': items,
                          'landmark': 'Asaba Central',
                        },
                      );
                    },
                    icon: const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                    label: Text('Pay ₦13,750.00 securely',
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_rounded,
                        color: AppColors.slate400, size: 12),
                    const SizedBox(width: 4),
                    Text('End-to-End Encryption Secured by MartoraX',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.slate400,
                            letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayMethod {
  final String name;
  final String subtitle;
  final IconData icon;
  const _PayMethod(this.name, this.subtitle, this.icon);
}

class _PayMethodCard extends StatelessWidget {
  final _PayMethod method;
  final bool selected;
  final VoidCallback onTap;
  const _PayMethodCard({required this.method, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.emerald600.withValues(alpha: 0.05)
              : AppColors.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.emerald600 : AppColors.slate700,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.emerald600.withValues(alpha: 0.2)
                    : AppColors.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: Icon(method.icon,
                  color: selected ? AppColors.emerald600 : AppColors.slate400, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.name,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: Colors.white)),
                  Text(method.subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: selected ? AppColors.emerald600 : AppColors.slate400)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.emerald600 : AppColors.slate400,
                  width: 2,
                ),
                color: selected ? AppColors.emerald600 : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  const _SumRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate400)),
        Text(value, style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}
