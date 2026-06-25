import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class LeadsManagementScreen extends ConsumerStatefulWidget {
  const LeadsManagementScreen({super.key});

  @override
  ConsumerState<LeadsManagementScreen> createState() =>
      _LeadsManagementScreenState();
}

class _LeadsManagementScreenState extends ConsumerState<LeadsManagementScreen> {
  int _filterIdx = 0;
  static const _filters = ['All Leads', 'New', 'Pending', 'Replied'];

  static const _leads = [
    _Lead(
      name: 'Chisom Okafor',
      status: 'New',
      service: 'AC Repair',
      distance: '2.4km away',
      time: '2m ago',
      message:
          '"Hi, my split unit is leaking water and making a loud noise since morning..."',
      isReply: false,
    ),
    _Lead(
      name: 'Blessing Eke',
      status: 'Pending',
      service: 'Electrical',
      distance: '5.1km away',
      time: '45m ago',
      message:
          '"Need a quote for rewiring a 3-bedroom flat in GRA phase 2."',
      isReply: false,
    ),
    _Lead(
      name: 'David Okon',
      status: 'Replied',
      service: 'Plumbing',
      distance: '1.2km away',
      time: '2h ago',
      message: 'You: "I can come over by 4 PM to check the kitchen sink."',
      isReply: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          Column(
            children: [
              // Sticky header
              Container(
                color: AppColors.darkBg.withValues(alpha: 0.9),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ref.tr('st_provider_leads'),
                            style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5)),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              Icons.notifications_rounded,
                              color: AppColors.slate400,
                              size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search bar
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Icon(Icons.search_rounded,
                                color: AppColors.slate400,
                                size: 22),
                          ),
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white),
                              decoration: InputDecoration(
                                hintText:
                                    'Search leads by name or service...',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.slate400),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Icon(Icons.tune_rounded,
                                color: AppColors.slate400,
                                size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (_, i) {
                          final selected = _filterIdx == i;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _filterIdx = i),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10),
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 20),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.emerald600
                                    : AppColors.cardBg,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(_filters[i],
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: selected
                                            ? Colors.white
                                            : AppColors.slate400)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              // Lead list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  children: [
                    ..._leads.map((l) => _LeadCard(lead: l)),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          Icon(Icons.hourglass_empty_rounded,
                              color: AppColors.slate400
                                  .withValues(alpha: 0.3),
                              size: 40),
                          const SizedBox(height: 8),
                          Text('End of current leads',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.slate400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg.withValues(alpha: 0.95),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom:
                    MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.slate700)),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(Icons.dashboard_rounded, 'Dashboard',
                      false,
                      () => context.go('/provider/dashboard')),
                  _NavItem(Icons.calendar_month_rounded,
                      'Bookings', false, () {}),
                  _NavItem(Icons.chat_bubble_rounded, 'Leads',
                      true, () {}),
                  _NavItem(Icons.person_rounded, 'Profile',
                      false, () => context.go('/profile')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lead {
  final String name;
  final String status;
  final String service;
  final String distance;
  final String time;
  final String message;
  final bool isReply;
  const _Lead({
    required this.name,
    required this.status,
    required this.service,
    required this.distance,
    required this.time,
    required this.message,
    required this.isReply,
  });
}

class _LeadCard extends StatelessWidget {
  final _Lead lead;
  const _LeadCard({required this.lead});

  Color get _statusColor {
    switch (lead.status) {
      case 'New':
        return AppColors.emerald600;
      case 'Pending':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.slate400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final replied = lead.status == 'Replied';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Opacity(
        opacity: replied ? 0.7 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color:
                            _statusColor.withValues(alpha: 0.2),
                        width: 2),
                  ),
                  child: Icon(Icons.person_rounded,
                      color: AppColors.slate400, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(lead.name,
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: replied
                                      ? AppColors.slate400
                                      : Colors.white)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _statusColor
                                  .withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(
                                lead.status.toUpperCase(),
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: _statusColor,
                                    letterSpacing: 1.0)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                          '${lead.service} • ${lead.distance}',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.slate400)),
                    ],
                  ),
                ),
                Text(lead.time,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.slate400)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceBg.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: lead.isReply
                    ? Border(
                        left: BorderSide(
                            color: AppColors.emerald600
                                .withValues(alpha: 0.4),
                            width: 4))
                    : null,
              ),
              child: Text(lead.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: lead.isReply
                          ? AppColors.slate400
                          : Colors.white
                              .withValues(alpha: 0.85))),
            ),
            if (!replied) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                            lead.status == 'New'
                                ? Icons.chat_rounded
                                : null,
                            color: lead.status == 'New'
                                ? Colors.white
                                : null,
                            size: 16),
                        label: Text(
                            lead.status == 'New'
                                ? 'Reply Now'
                                : 'View Details',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lead.status == 'New'
                              ? AppColors.emerald600
                              : AppColors.surfaceBg,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                        lead.status == 'New'
                            ? Icons.more_horiz_rounded
                            : Icons.call_rounded,
                        color: AppColors.slate400,
                        size: 18),
                  ),
                ],
              ),
            ],
          ],
        ),
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
              color: active
                  ? AppColors.emerald600
                  : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
