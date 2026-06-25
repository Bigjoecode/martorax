import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  ConsumerState<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  int _selectedDay = 0;
  int _selectedTime = 1;

  static const _days = ['Mon\n13', 'Tue\n14', 'Wed\n15', 'Thu\n16', 'Fri\n17'];
  static const _times = ['09:00 AM', '11:30 AM', '02:00 PM', '04:30 PM'];

  static const _quickMessages = [
    'Can we negotiate the price?',
    'Are you available today?',
    'What materials do I need to buy?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 22),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_service_booking'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider profile
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.person_rounded,
                                color: AppColors.slate400, size: 40),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.darkBg, width: 2),
                              ),
                              child: const Icon(Icons.verified_rounded,
                                  color: Colors.white, size: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chidi Nwosu',
                                style: GoogleFonts.inter(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            Text('Expert Plumber & Pipefitter',
                                style: GoogleFonts.inter(
                                    fontSize: 13, color: AppColors.slate400)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.star_rounded,
                                    color: AppColors.amber500, size: 16),
                                const SizedBox(width: 2),
                                Text('4.9',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                                Text(' (128 reviews)',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.slate400)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: AppColors.emerald600),
                                children: [
                                  const TextSpan(text: 'Price from '),
                                  TextSpan(
                                      text: '₦5,000',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SafePay banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue500.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.blue500.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.verified_user_rounded,
                            color: AppColors.blue500, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SafePay Escrow Active',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blue500)),
                              const SizedBox(height: 4),
                              Text(
                                'Your payment is held securely in escrow and only released to Chidi when the job is completed to your satisfaction.',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.slate400,
                                    height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Date selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Date',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('May 2024',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _days.length,
                    itemBuilder: (context, i) {
                      final parts = _days[i].split('\n');
                      final isSelected = _selectedDay == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 56,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.emerald600
                                : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(parts[0],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : AppColors.slate400)),
                              Text(parts[1],
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Time selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Available Time',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(_times.length, (i) {
                      final isSelected = _selectedTime == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: (MediaQuery.of(context).size.width - 60) / 3,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.emerald600.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.emerald600
                                  : AppColors.slate700,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(_times[i],
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.emerald600
                                        : Colors.white)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 28),

                // Quick chat
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Quick Chat',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickMessages
                        .map((msg) => GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(msg,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                border: Border(top: BorderSide(color: AppColors.slate700)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.slate700, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.chat_bubble_outline_rounded,
                          color: AppColors.slate400, size: 22),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/order/confirmation'),
                        icon: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 20),
                        label: Text('Book Now',
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
