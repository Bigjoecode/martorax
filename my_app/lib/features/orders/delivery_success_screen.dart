import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class DeliverySuccessScreen extends ConsumerStatefulWidget {
  const DeliverySuccessScreen({super.key});

  @override
  ConsumerState<DeliverySuccessScreen> createState() =>
      _DeliverySuccessScreenState();
}

class _DeliverySuccessScreenState extends ConsumerState<DeliverySuccessScreen> {
  int _vendorRating = 4;
  int _riderRating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10221C),
      body: Stack(
        children: [
          Column(
            children: [
              // App bar
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 22),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(ref.tr('st_delivery_success'),
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 22),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Celebratory icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.emerald600
                                .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.emerald600,
                              size: 64),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(ref.tr('ord_delivered_title'),
                            style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5)),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24),
                          child: Text(
                              'The vendor has received their payment. Thank you for shopping local!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.slate400,
                                  height: 1.5)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Divider
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      const SizedBox(height: 16),
                      Text('Rate your Experience',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 16),
                      // Vendor rating
                      _RatingCard(
                        label: 'Rate the Vendor',
                        name: 'Artisan Craft Co.',
                        icon: Icons.storefront_rounded,
                        rating: _vendorRating,
                        onChange: (v) =>
                            setState(() => _vendorRating = v),
                      ),
                      const SizedBox(height: 12),
                      // Rider rating
                      _RatingCard(
                        label: 'Rate the Rider',
                        name: 'Alex Johnson',
                        icon: Icons.delivery_dining_rounded,
                        rating: _riderRating,
                        onChange: (v) =>
                            setState(() => _riderRating = v),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () =>
                              context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.emerald600,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                          child: Text('Done',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
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
              color: const Color(0xFF10221C),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom:
                    MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.white
                            .withValues(alpha: 0.05))),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(Icons.home_rounded, 'Home', false,
                      () => context.go('/home')),
                  _NavItem(Icons.search_rounded, 'Search', false,
                      () => context.go('/search')),
                  _NavItem(Icons.receipt_long_rounded,
                      'Bookings', true,
                      () => context.go('/bookings')),
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

class _RatingCard extends StatelessWidget {
  final String label;
  final String name;
  final IconData icon;
  final int rating;
  final ValueChanged<int> onChange;

  const _RatingCard({
    required this.label,
    required this.name,
    required this.icon,
    required this.rating,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.emerald600
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.emerald600
                          .withValues(alpha: 0.3),
                      width: 2),
                ),
                child: Icon(icon,
                    color: AppColors.emerald600, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.slate400)),
                  Text(name,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => onChange(i + 1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.star_rounded,
                    color: i < rating
                        ? AppColors.emerald600
                        : AppColors.slate700,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
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
              color: active
                  ? AppColors.emerald600
                  : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
