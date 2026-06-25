import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
          onPressed: () => context.go('/home'),
        ),
        title: Text(ref.tr('st_order_confirm'),
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Success checkmark
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.emerald600.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Icon(Icons.check_rounded, color: AppColors.emerald600, size: 56),
            ),
            const SizedBox(height: 24),

            // Headline
            Text(
              'Order Placed Successfully!',
              style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your payment is held securely in ',
              style: GoogleFonts.inter(fontSize: 15, color: AppColors.slate400),
              textAlign: TextAlign.center,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.slate400),
                children: [
                  TextSpan(
                      text: 'SafePay',
                      style: TextStyle(color: AppColors.emerald600, fontWeight: FontWeight.w600)),
                  const TextSpan(text: '. Stall 42 is now preparing your items.'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.emerald600.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_rounded,
                      color: AppColors.emerald600, size: 14),
                  const SizedBox(width: 6),
                  Text(ref.tr('co_payment_protected'),
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald600,
                          letterSpacing: 0.8)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Order details card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Details',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate400,
                              letterSpacing: 0.8)),
                      Text('#MX-88219',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emerald600)),
                    ],
                  ),
                  Divider(color: AppColors.slate700.withValues(alpha: 0.5), height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailCell(
                          label: 'Items',
                          value: '3 Fresh Items',
                        ),
                      ),
                      Expanded(
                        child: _DetailCell(
                          label: 'Total Paid',
                          value: '₦10,650',
                          align: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailCell(
                          label: 'Est. Delivery',
                          value: '20-30 mins',
                        ),
                      ),
                      Expanded(
                        child: _DetailCell(
                          label: 'Status',
                          value: 'Confirmed',
                          valueColor: AppColors.emerald600,
                          align: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Product thumbnails
            Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
                    ),
                    child: Icon(
                      [Icons.shopping_bag_outlined, Icons.restaurant_outlined, Icons.spa_outlined][i],
                      color: AppColors.slate400,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/order/status'),
                icon: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 20),
                label: Text(ref.tr('co_track_order'),
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => context.go('/home'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.slate700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(ref.tr('btn_go_back'),
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextAlign align;

  const _DetailCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          align == TextAlign.right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.inter(
                fontSize: 10, color: AppColors.slate400, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.white)),
      ],
    );
  }
}
