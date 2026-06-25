import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/localization/app_localizations.dart';

class ShopperProfileScreen extends ConsumerWidget {
  const ShopperProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLang = ref.watch(languageProvider);
    final activeRole = ref.watch(userRoleProvider);
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('profile_title'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_rounded,
                  color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.emerald600.withValues(alpha: 0.3),
                              width: 4),
                        ),
                        child: Icon(Icons.person_rounded,
                            color: AppColors.slate400, size: 56),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.emerald600,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.darkBg, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Chidi Okafor',
                      style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.emerald600.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'ROLE: ${activeRole.toUpperCase()}',
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emerald600,
                              letterSpacing: 0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Member since 2024',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.slate400)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Wallet card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.slate700),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SafePay Balance',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate400)),
                            const SizedBox(height: 4),
                            Text('₦ 25,000.00',
                                style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.account_balance_wallet_rounded,
                              color: AppColors.emerald600, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/wallet'),
                            icon: const Icon(Icons.add_circle_rounded,
                                color: Colors.white, size: 18),
                            label: Text('Top Up',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald600,
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/history'),
                            icon: Icon(Icons.history_rounded,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 18),
                            label: Text('History',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white
                                        .withValues(alpha: 0.8))),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surfaceBg,
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Account section
            _SectionHeader(ref.tr('prof_account')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.shopping_bag_rounded,
                      iconBg: AppColors.blue500.withValues(alpha: 0.1),
                      iconColor: AppColors.blue500,
                      title: ref.tr('prof_my_orders'),
                      subtitle: 'Track current & past history',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white38, size: 22),
                      onTap: () => context.go('/bookings'),
                      divider: true,
                    ),
                    if (activeRole == 'admin')
                      _SettingsRow(
                        icon: Icons.admin_panel_settings_rounded,
                        iconBg: AppColors.amber500.withValues(alpha: 0.1),
                        iconColor: AppColors.amber500,
                        title: 'Administrative Control Center',
                        subtitle: 'Manage SafePay, KYC, Riders & Catalog',
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.white38, size: 22),
                        onTap: () => context.push('/admin/universal'),
                        divider: true,
                      ),
                    _SettingsRow(
                      icon: Icons.favorite_rounded,
                      iconBg: Colors.pink.withValues(alpha: 0.1),
                      iconColor: Colors.pink,
                      title: 'Saved Stalls & Pros',
                      subtitle: 'Your favorite market spots',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white38, size: 22),
                      onTap: () {},
                      divider: true,
                    ),
                    _SettingsRow(
                      icon: Icons.location_on_rounded,
                      iconBg: AppColors.emerald600.withValues(alpha: 0.1),
                      iconColor: AppColors.emerald600,
                      title: ref.tr('prof_saved_addresses'),
                      subtitle: 'Opp. Nnebisi Junction, Asaba',
                      trailing: const Icon(Icons.edit_rounded,
                          color: Colors.white38, size: 20),
                      onTap: () {},
                      divider: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Preferences section
            _SectionHeader(ref.tr('profile_preferences')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.language_rounded,
                      iconBg: AppColors.slate700,
                      iconColor: AppColors.slate400,
                      title: ref.tr('profile_language'),
                      subtitle: ref.tr('profile_language_sub'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(activeLang,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.emerald600)),
                          const Icon(Icons.expand_more_rounded,
                              color: Colors.white38, size: 20),
                        ],
                      ),
                      onTap: () => context.go('/language'),
                      divider: true,
                    ),
                    _SettingsRow(
                      icon: Icons.notifications_rounded,
                      iconBg: AppColors.slate700,
                      iconColor: AppColors.slate400,
                      title: ref.tr('profile_notifications'),
                      subtitle: null,
                      trailing: _Toggle(value: true),
                      onTap: () {},
                      divider: true,
                    ),
                    _SettingsRow(
                      icon: Icons.dark_mode_rounded,
                      iconBg: AppColors.slate700,
                      iconColor: AppColors.slate400,
                      title: ref.tr('profile_theme'),
                      subtitle: null,
                      trailing: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Icon(Icons.light_mode_rounded,
                                  size: 14, color: AppColors.slate400),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.dark_mode_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                      divider: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Vendor CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              ref.tr('prof_become_vendor'),
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.3)),
                          const SizedBox(height: 8),
                          Text(
                              ref.tr('prof_become_sub'),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  height: 1.4)),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColors.cardBg,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  final roles = ['shopper', 'vendor', 'provider', 'rider'];
                                  if (activeRole == 'admin') {
                                    roles.add('admin');
                                  }
                                  return SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Switch App Dashboard Role',
                                              style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white)),
                                          const SizedBox(height: 12),
                                          ...roles.map((role) {
                                            final isSelected = activeRole == role;
                                            return ListTile(
                                              leading: Icon(
                                                role == 'shopper'
                                                    ? Icons.shopping_bag_rounded
                                                    : role == 'vendor'
                                                        ? Icons.storefront_rounded
                                                        : role == 'provider'
                                                            ? Icons.handyman_rounded
                                                            : role == 'rider'
                                                                ? Icons.directions_bike_rounded
                                                                : Icons.admin_panel_settings_rounded,
                                                color: isSelected ? AppColors.emerald600 : AppColors.slate400,
                                              ),
                                              title: Text(
                                                role.toUpperCase(),
                                                style: GoogleFonts.inter(
                                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                    color: isSelected ? AppColors.emerald600 : Colors.white),
                                              ),
                                              trailing: isSelected ? Icon(Icons.check_rounded, color: AppColors.emerald600) : null,
                                              onTap: () {
                                                ref.read(userRoleProvider.notifier).state = role;
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Switched to ${role.toUpperCase()} mode!'),
                                                    backgroundColor: AppColors.emerald600,
                                                  ),
                                                );
                                                if (role == 'admin') {
                                                  context.push('/admin/universal');
                                                 } else if (role == 'vendor') {
                                                   context.go('/vendor/dashboard');
                                                 } else if (role == 'provider') {
                                                   context.go('/provider/dashboard');
                                                 } else if (role == 'rider') {
                                                   context.go('/rider/dashboard');
                                                 } else if (role == 'shopper') {
                                                   context.go('/');
                                                }
                                              },
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(ref.tr('btn_get_started'),
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.emerald600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.storefront_rounded,
                        color: Colors.white.withValues(alpha: 0.2),
                        size: 64),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Footer actions
            TextButton.icon(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                if (!context.mounted) return;
                context.go('/login');
              },
              icon: Icon(Icons.logout_rounded,
                  color: AppColors.slate400, size: 18),
              label: Text(ref.tr('profile_logout'),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate400)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: Text('Delete Account',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.red.withValues(alpha: 0.6))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(context),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.slate400,
                letterSpacing: 1.5)),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final bool divider;
  const _SettingsRow(
      {required this.icon,
      required this.iconBg,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.onTap,
      required this.divider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.slate400)),
                      ],
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (divider)
          Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.05),
              indent: 70),
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool value;
  const _Toggle({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 26,
      decoration: BoxDecoration(
        color: value ? AppColors.emerald600 : AppColors.slate700,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Align(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
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
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 28),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.slate700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.home_rounded, 'Home', false, () => ctx.go('/home')),
          _NavItem(Icons.search_rounded, 'Search', false,
              () => ctx.go('/search')),
          _NavItem(Icons.calendar_today_rounded, 'Bookings', false,
              () => ctx.go('/bookings')),
          _NavItem(Icons.person_rounded, 'Profile', true, () {}),
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
