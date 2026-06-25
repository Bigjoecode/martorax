import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final _promoCtrl = TextEditingController();

  @override
  void dispose() {
    _promoCtrl.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: Text(ref.tr('st_wallet'),
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: ref.tr('wal_balance'),
                      value: '₦25,450.00',
                      highlight: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: ref.tr('wal_cashback'),
                      value: '₦1,200.50',
                      highlight: true,
                      badge: true,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/wallet/add'),
                        icon: const Icon(Icons.add_circle_rounded,
                            color: AppColors.darkBg, size: 20),
                        label: Text(ref.tr('wal_topup'),
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkBg)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.account_balance_wallet_rounded,
                            color: Colors.white, size: 20),
                        label: Text(ref.tr('wal_withdraw'),
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.slate700),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Promo code
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate700),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Redeem Rewards',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCtrl,
                            style: GoogleFonts.inter(
                                fontSize: 15, color: Colors.white),
                            decoration: InputDecoration(
                              hintText: ref.tr('wal_promo_hint'),
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 15, color: AppColors.slate400),
                              filled: true,
                              fillColor: AppColors.surfaceBg,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                borderSide: BorderSide(color: AppColors.slate700),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                borderSide: BorderSide(color: AppColors.slate700),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                borderSide: BorderSide(color: AppColors.emerald600),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            border: Border.all(color: AppColors.slate700),
                          ),
                          child: Center(
                            child: Text(ref.tr('wal_apply'),
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.emerald600,
                                    letterSpacing: 0.5)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ref.tr('wal_recent'),
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  GestureDetector(
                    onTap: () => context.go('/wallet/history'),
                    child: Text(ref.tr('see_all'),
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.emerald600)),
                  ),
                ],
              ),
            ),

            _TxItem(
              icon: Icons.shopping_bag_rounded,
              title: 'Grocery Mart Asaba',
              date: 'Oct 24, 2023 • 2:45 PM',
              amount: '-₦4,500.00',
              cashback: '+₦45.00 Cashback',
              positive: false,
            ),
            _TxItem(
              icon: Icons.payments_rounded,
              title: 'Wallet Top-up',
              date: 'Oct 22, 2023 • 10:15 AM',
              amount: '+₦10,000.00',
              note: 'Bank Transfer',
              positive: true,
            ),
            _TxItem(
              icon: Icons.electric_bolt_rounded,
              title: 'Utility Bill (EKEDC)',
              date: 'Oct 20, 2023 • 6:30 PM',
              amount: '-₦12,000.00',
              cashback: '+₦120.00 Cashback',
              positive: false,
            ),
            _TxItem(
              icon: Icons.redeem_rounded,
              title: 'Promo Reward',
              date: 'Oct 18, 2023 • 12:00 PM',
              amount: '+₦500.00',
              note: 'Code: MARTORAX10',
              positive: true,
              iconColor: AppColors.amber500,
              iconBg: AppColors.amber500.withValues(alpha: 0.1),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool badge;

  const _StatCard({
    required this.label,
    required this.value,
    required this.highlight,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.slate400)),
              if (badge) ...[
                const SizedBox(width: 4),
                Icon(Icons.verified_rounded,
                    color: AppColors.emerald600, size: 14),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: highlight ? AppColors.emerald600 : Colors.white)),
        ],
      ),
    );
  }
}

class _TxItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final String? cashback;
  final String? note;
  final bool positive;
  final Color? iconColor;
  final Color? iconBg;

  const _TxItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    this.cashback,
    this.note,
    required this.positive,
    this.iconColor,
    this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? AppColors.slate400;
    final bg = iconBg ?? AppColors.surfaceBg;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
            child: Icon(icon, color: ic, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text(date,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.slate400)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: positive ? AppColors.emerald600 : Colors.white)),
              if (cashback != null)
                Text(cashback!,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald600)),
              if (note != null)
                Text(note!,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.slate400)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final BuildContext ctx;
  const _BottomNav(this.ctx);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.home_rounded, 'Home', false, () => ctx.go('/home')),
          _NavItem(Icons.explore_rounded, 'Discover', false, () {}),
          _NavItem(Icons.account_balance_wallet_rounded, 'Wallet', true, () {}),
          _NavItem(Icons.person_rounded, 'Profile', false, () {}),
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
              color: active ? AppColors.emerald600 : AppColors.slate400,
              size: 24),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.emerald600 : AppColors.slate400)),
        ],
      ),
    );
  }
}
