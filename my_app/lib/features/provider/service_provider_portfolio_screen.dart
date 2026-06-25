import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ServiceProviderPortfolioScreen extends ConsumerWidget {
  const ServiceProviderPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_provider_portfolio'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
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
            padding: const EdgeInsets.only(bottom: 140),
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
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.emerald600, width: 3),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_rounded,
                                  color: AppColors.slate400, size: 56),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.amber500,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.darkBg, width: 2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified_rounded,
                                      color: Colors.black, size: 12),
                                  const SizedBox(width: 2),
                                  Text('PRO',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 0.5)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Johnathan Vance',
                          style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Master Welder & Metal Fabricator',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald600)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_rounded,
                              color: AppColors.slate400, size: 14),
                          const SizedBox(width: 4),
                          Text('Asaba, Nigeria • 2km away',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.slate400)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Stats bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: _StatBox(
                        topWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_rounded,
                                color: AppColors.amber500, size: 18),
                            const SizedBox(width: 4),
                            Text('4.9',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                        label: '128 REVIEWS',
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _StatBox(
                        topWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user_rounded,
                                color: AppColors.emerald600, size: 18),
                            const SizedBox(width: 4),
                            Text('100%',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                        label: 'JOB SUCCESS',
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _StatBox(
                        topWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_rounded,
                                color: AppColors.blue500, size: 18),
                            const SizedBox(width: 4),
                            Text('12y',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                        label: 'EXPERIENCE',
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Past work gallery
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Past Work',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('View All',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _WorkTile(Icons.handyman_rounded, 'Welding Project'),
                      _WorkTile(Icons.chair_rounded, 'Metal Furniture'),
                      _WorkTile(Icons.architecture_rounded, 'Steel Beams'),
                      _WorkTile(Icons.auto_awesome_rounded, 'Wall Art'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Reviews
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer Reviews',
                          style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('See More',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _ReviewCard(
                        name: 'Sarah Jenkins',
                        time: '2 days ago • Asaba, Nigeria',
                        stars: 5,
                        text:
                            '"John did an incredible job repairing our custom iron gate. He was punctual, professional, and the finish is seamless. Highly recommended!"',
                        avatarColor: AppColors.slate700,
                      ),
                      const SizedBox(height: 12),
                      _ReviewCard(
                        name: 'Mark Thompson',
                        time: '1 week ago • Asaba, Nigeria',
                        stars: 5,
                        text:
                            '"Fair pricing and expert knowledge. Helped us with some structural welding on a short notice. A true professional pro."',
                        avatarColor: AppColors.cardBg,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fixed footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg.withValues(alpha: 0.95),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: AppColors.emerald600, width: 2),
                            shape: const StadiumBorder(),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('Quick Quote',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => context.go('/service/booking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emerald600,
                            shape: const StadiumBorder(),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('Book Now',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(Icons.home_rounded, 'Home', false,
                          () => context.go('/home')),
                      _NavItem(Icons.search_rounded, 'Search', false,
                          () => context.go('/search')),
                      _NavItem(
                          Icons.calendar_today_rounded, 'Bookings', false, () {}),
                      _NavItem(Icons.person_rounded, 'Profile', true, () {}),
                    ],
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

class _StatBox extends StatelessWidget {
  final Widget topWidget;
  final String label;
  const _StatBox({required this.topWidget, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          topWidget,
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate400,
                  letterSpacing: 0.8)),
        ],
      ),
    );
  }
}

class _WorkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WorkTile(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.emerald700.withValues(alpha: 0.3),
            AppColors.cardBg,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.emerald600, size: 44),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String time;
  final int stars;
  final String text;
  final Color avatarColor;
  const _ReviewCard(
      {required this.name,
      required this.time,
      required this.stars,
      required this.text,
      required this.avatarColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 16, backgroundColor: avatarColor),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text(time,
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.slate400)),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(
                    stars,
                    (_) => Icon(Icons.star_rounded,
                        color: AppColors.amber500, size: 14)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5)),
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
