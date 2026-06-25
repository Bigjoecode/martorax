import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class HistoryStatementsScreen extends ConsumerWidget {
  const HistoryStatementsScreen({super.key});

  static const _bookings = [
    _Booking(Icons.description_rounded, 'Standard Audit - Glo',
        'Oct 12, 2023', '₦45,000'),
    _Booking(Icons.analytics_rounded, 'Business Review - MTN',
        'Oct 08, 2023', '₦120,000'),
    _Booking(Icons.payments_rounded, 'Financial Advisory',
        'Oct 05, 2023', '₦85,000'),
    _Booking(Icons.person_pin_rounded, 'Consultation - Heritage Bank',
        'Sep 28, 2023', '₦50,000'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(ref.tr('st_wallet_history'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats summary
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.work_rounded,
                          label: 'Total Jobs',
                          value: '34',
                          valueColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Total Earned',
                          value: '₦1,240,000',
                          valueColor: AppColors.emerald600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Filter chips
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _filterChip('Month: October'),
                      const SizedBox(width: 10),
                      _filterChip('Year: 2023'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Past Bookings',
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _bookings.length,
                  itemBuilder: (context, i) {
                    final b = _bookings[i];
                    return _BookingRow(booking: b);
                  },
                ),
              ],
            ),
          ),
          // Export button
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf_rounded,
                    color: Colors.black, size: 20),
                label: Text('Export Statement',
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _Booking {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  const _Booking(this.icon, this.title, this.date, this.amount);
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  const _SummaryCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.slate400, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.slate400)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  letterSpacing: -0.5)),
        ],
      ),
    );
  }
}

Widget _filterChip(String label) {
  return Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.slate700),
    ),
    child: Row(
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.85))),
        const SizedBox(width: 4),
        Icon(Icons.expand_more_rounded, color: AppColors.slate400, size: 18),
      ],
    ),
  );
}

class _BookingRow extends StatelessWidget {
  final _Booking booking;
  const _BookingRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.emerald600.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(booking.icon, color: AppColors.emerald600, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Row(
                  children: [
                    Text('${booking.date} • ',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.slate400)),
                    Text('Completed',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.emerald600)),
                  ],
                ),
              ],
            ),
          ),
          Text(booking.amount,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
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
        color: AppColors.darkBg.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.grid_view_rounded, 'Dashboard', false, () {}),
          _NavItem(Icons.history_rounded, 'Bookings', true, () {}),
          _NavItem(Icons.rocket_launch_rounded, 'Leads', false, () {}),
          _NavItem(Icons.account_circle_rounded, 'Profile', false,
              () => ctx.go('/profile')),
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
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.emerald600 : AppColors.slate400)),
        ],
      ),
    );
  }
}
