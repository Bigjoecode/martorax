import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/data_providers.dart';
import '../../core/supabase/supabase_config.dart';

IconData _iconFor(String? type) {
  switch (type) {
    case 'order':
      return Icons.receipt_long_rounded;
    case 'payment':
    case 'escrow':
      return Icons.account_balance_wallet_rounded;
    case 'kyc':
      return Icons.verified_user_rounded;
    case 'booking':
      return Icons.calendar_today_rounded;
    default:
      return Icons.notifications_rounded;
  }
}

String _relative(Object? iso) {
  final d = DateTime.tryParse(iso?.toString() ?? '')?.toLocal();
  if (d == null) return '';
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${d.day}/${d.month}/${d.year}';
}

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  Future<void> _markAllRead(WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    try {
      await SupabaseConfig.client
          .from('notifications')
          .update({'is_read': true}).eq('user_id', user.id);
    } catch (_) {}
    ref.invalidate(notificationsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifs = ref.watch(notificationsProvider);
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
            onPressed: () => _markAllRead(ref),
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
            child: notifs.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.emerald600)),
              error: (_, __) => Center(
                child: Text('Could not load notifications',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.slate400)),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off_rounded,
                            size: 56,
                            color: AppColors.slate400.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text('No notifications yet',
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.slate400)),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.emerald600,
                  onRefresh: () async => ref.invalidate(notificationsProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final n = items[i];
                      return _NotifItem(
                        icon: _iconFor(n['type'] as String?),
                        title: (n['title'] as String?) ?? '',
                        subtitle: (n['body'] as String?) ?? '',
                        time: _relative(n['created_at']),
                        unread: !((n['is_read'] as bool?) ?? false),
                      );
                    },
                  ),
                );
              },
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

  const _NotifItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unread ? 1.0 : 0.8,
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
