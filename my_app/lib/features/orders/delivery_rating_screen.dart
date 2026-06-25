import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class DeliveryRatingScreen extends ConsumerStatefulWidget {
  const DeliveryRatingScreen({super.key});

  @override
  ConsumerState<DeliveryRatingScreen> createState() => _DeliveryRatingScreenState();
}

class _DeliveryRatingScreenState extends ConsumerState<DeliveryRatingScreen> {
  int _vendorRating = 4;
  int _riderRating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/order/tracking'),
        ),
        title: Text(ref.tr('st_delivery_rating'),
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  // Celebratory icon
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.emerald600.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle_rounded,
                          color: AppColors.emerald600, size: 64),
                    ),
                  ),

                  Text(ref.tr('ord_delivered_title'),
                      style: GoogleFonts.manrope(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    'The vendor has received their payment.\nThank you for shopping local!',
                    style: GoogleFonts.inter(
                        fontSize: 15, color: AppColors.slate400, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Rating header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Rate your Experience',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 20),
                  const SizedBox(height: 12),

                  // Vendor rating card
                  _RatingCard(
                    roleLabel: 'Rate the Vendor',
                    name: 'Artisan Craft Co.',
                    rating: _vendorRating,
                    onRatingChanged: (r) => setState(() => _vendorRating = r),
                  ),
                  const SizedBox(height: 16),

                  // Rider rating card
                  _RatingCard(
                    roleLabel: 'Rate the Rider',
                    name: 'Alex Johnson',
                    rating: _riderRating,
                    onRatingChanged: (r) => setState(() => _riderRating = r),
                  ),
                  const SizedBox(height: 32),

                  // Done button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Done',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
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

class _RatingCard extends StatelessWidget {
  final String roleLabel;
  final String name;
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _RatingCard({
    required this.roleLabel,
    required this.name,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.emerald600.withValues(alpha: 0.3),
                      width: 2),
                ),
                child: Icon(Icons.person_rounded,
                    color: AppColors.slate400, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(roleLabel,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.slate400)),
                  Text(name,
                      style: GoogleFonts.inter(
                          fontSize: 15,
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
              final filled = i < rating;
              return GestureDetector(
                onTap: () => onRatingChanged(i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: filled ? AppColors.emerald600 : AppColors.slate400,
                    size: 36,
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

class _BottomNav extends StatelessWidget {
  final BuildContext ctx;
  const _BottomNav(this.ctx);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(Icons.home_rounded, 'Home', false, () => ctx.go('/home')),
          _NavItem(Icons.search_rounded, 'Search', false, () => ctx.go('/search')),
          _NavItem(Icons.receipt_long_rounded, 'Bookings', true, () {}),
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
