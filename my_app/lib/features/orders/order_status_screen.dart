import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class OrderStatusScreen extends ConsumerWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/order/confirmation'),
        ),
        title: Column(
          children: [
            Text('Order #78291',
                style: GoogleFonts.inter(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            Text(ref.tr('ord_in_progress'),
                style: GoogleFonts.inter(
                    color: AppColors.emerald600, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Order summary card
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.slate700.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceBg,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                            ),
                            child: CustomPaint(painter: _MapPainter()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Stall 42 • West Wing',
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.emerald600,
                                                letterSpacing: 0.5)),
                                        const SizedBox(height: 4),
                                        Text(ref.tr('co_order_summary'),
                                            style: GoogleFonts.inter(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.emerald600.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('₦12,500',
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.emerald600)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '1x Organic Tomatoes, 2x Fresh Peppers, 1x Red Onions',
                                  style: GoogleFonts.inter(
                                      fontSize: 13, color: AppColors.slate400, height: 1.4),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.receipt_long_rounded,
                                        color: Colors.white, size: 16),
                                    label: Text('View Receipt',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.emerald600,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Timeline
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ref.tr('ord_track_live'),
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate400,
                                letterSpacing: 1.0)),
                        const SizedBox(height: 20),
                        _TimelineStep(
                          icon: Icons.check_circle_rounded,
                          title: 'Order Placed',
                          time: '10:00 AM',
                          status: _StepStatus.done,
                          isLast: false,
                        ),
                        _TimelineStep(
                          icon: Icons.storefront_rounded,
                          title: 'Stall 42 Accepted',
                          time: '10:05 AM',
                          status: _StepStatus.done,
                          isLast: false,
                        ),
                        _TimelineStep(
                          icon: Icons.pedal_bike_rounded,
                          title: 'Rider Picked Up',
                          time: '10:20 AM • In transit',
                          status: _StepStatus.active,
                          isLast: false,
                        ),
                        _TimelineStep(
                          icon: Icons.home_rounded,
                          title: 'Out for Delivery',
                          time: 'Estimated 10:45 AM',
                          status: _StepStatus.pending,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_rounded,
                                  color: Colors.white, size: 18),
                              label: Text('Message Vendor',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
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
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.help_outline_rounded,
                                  color: Colors.white, size: 18),
                              label: Text('Need Help?',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
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

enum _StepStatus { done, active, pending }

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final _StepStatus status;
  final bool isLast;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.time,
    required this.status,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status == _StepStatus.done;
    final isActive = status == _StepStatus.active;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDone || isActive
                    ? AppColors.emerald600
                    : AppColors.surfaceBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDone || isActive
                      ? AppColors.emerald600
                      : AppColors.slate700,
                  width: 2,
                ),
              ),
              child: Icon(icon,
                  color: isDone || isActive ? Colors.white : AppColors.slate400,
                  size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isDone ? AppColors.emerald600 : AppColors.slate700,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColors.emerald600
                          : status == _StepStatus.pending
                              ? AppColors.slate400
                              : Colors.white)),
              const SizedBox(height: 2),
              Text(time,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: status == _StepStatus.pending
                          ? AppColors.slate400.withValues(alpha: 0.6)
                          : AppColors.slate400)),
            ],
          ),
        ),
      ],
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
        color: AppColors.darkBg.withValues(alpha: 0.8),
        border: Border(top: BorderSide(color: AppColors.slate700.withValues(alpha: 0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.home_rounded, 'Home', false, () => ctx.go('/home')),
          _NavItem(Icons.search_rounded, 'Search', false, () => ctx.go('/search')),
          _NavItem(Icons.calendar_month_rounded, 'Bookings', true, () {}),
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
              color: active ? AppColors.emerald600 : AppColors.slate400, size: 24),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.emerald600 : AppColors.slate400)),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF1A2E3A);
    canvas.drawRect(Offset.zero & size, bg);
    final road = Paint()
      ..color = const Color(0xFF253545)
      ..strokeWidth = 8;
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), road);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.4, size.height), road);
  }

  @override
  bool shouldRepaint(_MapPainter old) => false;
}
