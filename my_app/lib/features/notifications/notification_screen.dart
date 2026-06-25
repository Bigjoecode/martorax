import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        title: Text(ref.tr('st_notifications'),
            style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(ref.tr('ntf_mark_all_read'),
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald600)),
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(color: AppColors.slate700.withValues(alpha: 0.5), height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today',
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text('3 new',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.slate400)),
                      ],
                    ),
                  ),

                  _NotifItem(
                    icon: Icons.calendar_today_rounded,
                    title: 'New booking request from Chidi',
                    subtitle: 'Kitchen renovation consultation scheduled.',
                    time: '10:30 AM',
                    unread: true,
                  ),
                  _NotifItem(
                    icon: Icons.account_balance_wallet_rounded,
                    title: '₦15,000 released to your wallet',
                    subtitle: 'Payment for order #882 has been processed.',
                    time: '8:15 AM',
                    unread: true,
                  ),
                  _NotifItem(
                    icon: Icons.verified_user_rounded,
                    title: 'Your KYC is verified!',
                    subtitle: 'You can now accept premium projects.',
                    time: '6:00 AM',
                    unread: false,
                    dimmed: true,
                  ),

                  // Earlier section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text('Earlier',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),

                  _NotifItem(
                    icon: Icons.event_repeat_rounded,
                    title: 'Service reminder: Jane Smith',
                    subtitle: 'Scheduled for tomorrow at 9:00 AM.',
                    time: 'Yesterday',
                    unread: false,
                    dimmed: true,
                  ),
                  _NotifItem(
                    icon: Icons.payments_rounded,
                    title: 'Withdrawal Successful',
                    subtitle: '₦45,000 sent to your GT Bank account.',
                    time: 'Oct 24, 2023',
                    unread: false,
                    dimmed: true,
                  ),
                ],
              ),
            ),
          ),
          _BottomNav(context),
        ],
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;
  final bool dimmed;

  const _NotifItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.unread,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.8 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: unread
              ? AppColors.cardBg.withValues(alpha: 0.4)
              : Colors.transparent,
          border: unread
              ? Border(
                  left: BorderSide(color: AppColors.emerald600, width: 4))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: unread
                      ? AppColors.emerald600.withValues(alpha: 0.1)
                      : AppColors.surfaceBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: unread ? AppColors.emerald600 : AppColors.slate400,
                    size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.slate400,
                            height: 1.4)),
                    const SizedBox(height: 4),
                    Text(time.toUpperCase(),
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: unread
                                ? AppColors.emerald600.withValues(alpha: 0.8)
                                : AppColors.slate400,
                            letterSpacing: 0.8)),
                  ],
                ),
              ),
              if (unread)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.emerald600,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.emerald600.withValues(alpha: 0.5),
                            blurRadius: 8)
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
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
        color: AppColors.darkBg,
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.grid_view_rounded, 'Dashboard', false,
              () => ctx.go('/home')),
          _NavItem(Icons.book_online_rounded, 'Bookings', false, () {}),
          _NavItem(
              Icons.notifications_rounded, 'Notifications', true, () {}),
          _NavItem(Icons.explore_rounded, 'Leads', false, () {}),
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
              size: 22),
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
