import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class CheckoutConfirmScreen extends ConsumerStatefulWidget {
  const CheckoutConfirmScreen({super.key});

  @override
  ConsumerState<CheckoutConfirmScreen> createState() => _CheckoutConfirmScreenState();
}

class _CheckoutConfirmScreenState extends ConsumerState<CheckoutConfirmScreen> {
  int _paySelected = 0;
  bool _homeDelivery = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/checkout/payment'),
        ),
        title: Text(ref.tr('st_checkout_confirm'),
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Delivery/Pickup toggle
                Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _Toggle(
                        label: ref.tr('co_home_delivery'),
                        active: _homeDelivery,
                        onTap: () => setState(() => _homeDelivery = true),
                      ),
                      _Toggle(
                        label: ref.tr('co_market_pickup'),
                        active: !_homeDelivery,
                        onTap: () => setState(() => _homeDelivery = false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Delivery Address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ref.tr('co_address'),
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    Text('Change',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.emerald600)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.slate700),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.emerald600.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on_rounded,
                            color: AppColors.emerald600, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chukwuma Obi',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('Plot 12, Nnebisi Road, Asaba, Delta State.',
                                style: GoogleFonts.inter(
                                    fontSize: 13, color: AppColors.slate400)),
                            const SizedBox(height: 12),
                            Divider(color: AppColors.slate700),
                            const SizedBox(height: 8),
                            Text('LANDMARK (OPTIONAL)',
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate400,
                                    letterSpacing: 0.8)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.flag_rounded,
                                    color: AppColors.slate400, size: 16),
                                const SizedBox(width: 6),
                                Text('Opp. Nnebisi Junction',
                                    style: GoogleFonts.inter(
                                        fontSize: 14, color: AppColors.slate400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Order Summary
                Text(ref.tr('co_order_summary'),
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.restaurant_rounded,
                          color: AppColors.slate400, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Abacha & Ugba Platter (Family)',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          Text('Qty: 1',
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: AppColors.slate400)),
                        ],
                      ),
                    ),
                    Text('₦4,500',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.slate700),
                  ),
                  child: Column(
                    children: [
                      _SumRow(label: 'Subtotal', value: '₦4,500'),
                      const SizedBox(height: 12),
                      _SumRow(label: 'Delivery Fee', value: '₦800'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Group-Buy Discount',
                                  style: GoogleFonts.inter(
                                      fontSize: 14, color: AppColors.slate400)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.emerald600.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('ACTIVE',
                                    style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.emerald600)),
                              ),
                            ],
                          ),
                          Text('-₦500',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.emerald600)),
                        ],
                      ),
                      Divider(color: AppColors.slate700, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ref.tr('cart_total'),
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text('₦4,800',
                              style: GoogleFonts.inter(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.emerald600)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Payment Method
                Text(ref.tr('st_checkout_payment'),
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 12),
                _PayOption(
                  icon: Icons.verified_user_rounded,
                  title: 'SafePay Escrow',
                  subtitle: 'Funds held safely until you confirm delivery.',
                  badge: 'SECURE',
                  selected: _paySelected == 0,
                  highlight: true,
                  onTap: () => setState(() => _paySelected = 0),
                ),
                const SizedBox(height: 10),
                _PayOption(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'MartoraX Wallet',
                  subtitle: 'Balance: ₦12,400',
                  selected: _paySelected == 1,
                  onTap: () => setState(() => _paySelected = 1),
                ),
                const SizedBox(height: 10),
                _PayOption(
                  icon: Icons.account_balance_rounded,
                  title: 'Bank Transfer',
                  selected: _paySelected == 2,
                  onTap: () => setState(() => _paySelected = 2),
                ),
              ],
            ),
          ),

          // Bottom sheet-style footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border(top: BorderSide(color: AppColors.slate700)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total to pay',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.slate400)),
                          Text('₦4,800',
                              style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.security_rounded,
                              color: AppColors.emerald600, size: 14),
                          const SizedBox(width: 4),
                          Text(ref.tr('co_payment_protected'),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.emerald600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/order/confirmation'),
                      icon: const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                      label: Text(ref.tr('co_place_order'),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
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
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Toggle({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: active ? AppColors.surfaceBg : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.slate400)),
          ),
        ),
      ),
    );
  }
}

class _PayOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final bool selected;
  final bool highlight;
  final VoidCallback onTap;

  const _PayOption({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    required this.selected,
    this.highlight = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected && highlight
              ? AppColors.emerald600.withValues(alpha: 0.05)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
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
                    ? AppColors.emerald600
                    : AppColors.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: selected ? Colors.white : AppColors.slate400, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(badge!,
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.slate400)),
                ],
              ),
            ),
            selected
                ? Icon(Icons.check_circle_rounded,
                    color: AppColors.emerald600, size: 22)
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.slate700, width: 2),
                    ),
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
