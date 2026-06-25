import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/data_providers.dart';
import '../../core/widgets/withdraw_sheet.dart';

String _naira(num v) =>
    '₦${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

String _short(Object? id, [int n = 6]) {
  final s = id?.toString() ?? '';
  return s.length <= n ? s : s.substring(0, n);
}

class ProviderDashboardScreen extends ConsumerStatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  ConsumerState<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends ConsumerState<ProviderDashboardScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final data =
        ref.watch(providerDashboardProvider).valueOrNull ?? const ProviderDashboardData();
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final bizName = (profile?['business_name'] as String?)?.trim();
    final category = (profile?['service_category'] as String?)?.trim();
    final fullName = (profile?['full_name'] as String?)?.trim();
    final displayName = (bizName != null && bizName.isNotEmpty)
        ? bizName
        : (category != null && category.isNotEmpty
            ? category
            : (fullName != null && fullName.isNotEmpty ? fullName : 'Your Services'));
    final rating = (profile?['rating'] as num?)?.toStringAsFixed(1) ?? '5.0';
    final activeBooking = data.recent.where((b) {
      final s = b['status'] as String?;
      return s == 'requested' || s == 'accepted';
    }).toList();
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.emerald600.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.emerald600.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.handyman_rounded,
                  color: AppColors.emerald600, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.slate400)),
                Text(displayName,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ],
        ),
        actions: [
          // Active Online Toggler
          Row(
            children: [
              Text(
                _isOnline ? 'ONLINE' : 'OFFLINE',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _isOnline ? AppColors.emerald600 : AppColors.slate400,
                ),
              ),
              Switch(
                value: _isOnline,
                activeColor: AppColors.emerald600,
                activeTrackColor: AppColors.emerald600.withValues(alpha: 0.2),
                onChanged: (val) {
                  setState(() => _isOnline = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val ? 'You are now live to receive client requests!' : 'You went offline.'),
                      backgroundColor: val ? AppColors.emerald600 : AppColors.slate700,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SafePay Earnings Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.cardBg,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total SafePay Holdings',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SECURE',
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.emerald600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _naira(data.earnings),
                      style: GoogleFonts.manrope(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                showWithdrawSheet(context, ref, data.earnings),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald600,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Withdraw Earning'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Telemetry SLA Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.flash_on_rounded,
                      color: AppColors.emerald600,
                      label: 'ACTIVE LEADS',
                      value: '${data.pendingCount}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.check_circle_outline_rounded,
                      color: Colors.blueAccent,
                      label: 'COMPLETED JOBS',
                      value: '${data.completedCount}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.star_rounded,
                      color: AppColors.amber500,
                      label: 'RATING',
                      value: rating,
                    ),
                  ),
                ],
              ),
            ),

            // Active In-Progress Booking HUD
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'IN-PROGRESS BOOKING',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate400,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.slate700.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.amber500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SAFE-PAY LOCKED',
                            style: GoogleFonts.inter(
                                fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.amber500),
                          ),
                        ),
                        Text(
                          activeBooking.isEmpty
                              ? '—'
                              : _naira((activeBooking.first['amount'] as num?) ?? 0),
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      activeBooking.isEmpty
                          ? 'No active booking'
                          : 'Customer ${_short(activeBooking.first['shopper_id'])}',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activeBooking.isEmpty
                          ? 'New requests will appear here'
                          : ((activeBooking.first['service_category'] as String?) ?? 'Service'),
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeBooking.isEmpty
                          ? ''
                          : 'Issue: ${(activeBooking.first['description'] as String?) ?? '—'}',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/provider/portfolio'),
                            icon: const Icon(Icons.handyman_rounded, size: 16),
                            label: const Text('Update Job'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.slate400,
                              side: BorderSide(color: AppColors.slate700),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final shopperId = activeBooking.isEmpty
                                  ? null
                                  : activeBooking.first['shopper_id'] as String?;
                              context.go('/provider/chat', extra: {
                                if (shopperId != null) 'otherUserId': shopperId,
                                if (shopperId != null)
                                  'roomId': 'booking:${activeBooking.first['id']}',
                                'otherName': activeBooking.isEmpty
                                    ? 'Customer'
                                    : 'Customer ${_short(activeBooking.first['shopper_id'])}',
                              });
                            },
                            icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Colors.white),
                            label: const Text('Open Chat'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald600,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _QuickStatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.slate400, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
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
        color: AppColors.darkBg.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.space_dashboard_rounded, 'Dashboard', true, () {}),
          _NavItem(Icons.flash_on_rounded, 'Leads', false, () => ctx.go('/provider/leads')),
          _NavItem(Icons.account_circle_rounded, 'Portfolio', false, () => ctx.go('/provider/portfolio')),
          _NavItem(Icons.person_rounded, 'Profile', false, () => ctx.go('/profile')),
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
