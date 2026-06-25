import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class PublicServiceProfileScreen extends ConsumerWidget {
  const PublicServiceProfileScreen({super.key});

  static const _reviews = [
    _Review(
      name: 'Nneka E.',
      date: '2 days ago',
      rating: 5,
      text:
          'Chidi is hands down the best tailor in Asaba. He fixed my wedding suit in 48 hours and the fit was perfect. Highly recommended!',
    ),
    _Review(
      name: 'Emeka J.',
      date: '1 week ago',
      rating: 4,
      text:
          'Great service and professional handling. His shop at Okpanam Road is easy to find. Professional work!',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor:
                    AppColors.darkBg.withValues(alpha: 0.8),
                pinned: true,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                title: Text(ref.tr('st_service_profile'),
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                centerTitle: true,
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share_rounded,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Hero
                    SizedBox(
                      height: 280,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.emerald700
                                      .withValues(alpha: 0.4),
                                  AppColors.darkBg,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                  Icons.content_cut_rounded,
                                  color: Colors.white
                                      .withValues(alpha: 0.2),
                                  size: 140),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.darkBg,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Avatar + name
                    Transform.translate(
                      offset: const Offset(0, -50),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceBg,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.darkBg,
                                      width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.person_rounded,
                                    color: AppColors.slate400,
                                    size: 70),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF09F6AB),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.darkBg,
                                        width: 2),
                                  ),
                                  child: const Icon(
                                      Icons.verified_rounded,
                                      color: AppColors.darkBg,
                                      size: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Chidi Okafor',
                              style: GoogleFonts.inter(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 2),
                          Text('Master Tailor',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      const Color(0xFF09F6AB))),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: AppColors.slate400,
                                  size: 14),
                              const SizedBox(width: 2),
                              Text('Asaba, Nigeria',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.slate400)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Stats
                    Transform.translate(
                      offset: const Offset(0, -32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Row(
                          children: [
                            _stat(
                                value: '4.9',
                                label: 'RATING',
                                icon: Icons.star_rounded),
                            const SizedBox(width: 12),
                            _stat(
                                value: '120+', label: 'JOBS'),
                            const SizedBox(width: 12),
                            _stat(
                                value: '8 Yrs', label: 'EXP'),
                          ],
                        ),
                      ),
                    ),
                    // Recent work
                    Transform.translate(
                      offset: const Offset(0, -16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text('Recent Work',
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.white)),
                                Text('View all',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: const Color(
                                            0xFF09F6AB))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 220,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              children: [
                                _workTile(
                                    Icons.checkroom_rounded),
                                _workTile(Icons.iron_rounded),
                                _workTile(
                                    Icons.dry_cleaning_rounded),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Text('Reviews from Asaba',
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 12),
                          ..._reviews.map((r) => Padding(
                                padding: const EdgeInsets
                                    .symmetric(
                                    horizontal: 16,
                                    vertical: 6),
                                child: _ReviewCard(review: r),
                              )),
                          const SizedBox(height: 160),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Footer actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom:
                    MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkBg.withValues(alpha: 0.95),
                border: Border(
                    top:
                        BorderSide(color: AppColors.slate700)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.go('/provider/chat'),
                        icon: const Icon(Icons.mail_rounded,
                            color: Colors.white, size: 18),
                        label: Text('Message',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.surfaceBg
                              .withValues(alpha: 0.5),
                          side: BorderSide(
                              color: AppColors.slate700),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.go('/service/booking'),
                        icon: const Icon(
                            Icons.event_available_rounded,
                            color: Colors.white,
                            size: 20),
                        label: Text('Book Service',
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald600,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14)),
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

  Widget _stat({required String value, required String label, IconData? icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate700),
        ),
        child: Column(
          children: [
            if (icon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      color: const Color(0xFF09F6AB), size: 16),
                  const SizedBox(width: 4),
                  Text(value,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              )
            else
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate400,
                    letterSpacing: 1.0)),
          ],
        ),
      ),
    );
  }

  Widget _workTile(IconData icon) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Center(
        child: Icon(icon,
            color: const Color(0xFF09F6AB), size: 72),
      ),
    );
  }
}

class _Review {
  final String name;
  final String date;
  final int rating;
  final String text;
  const _Review({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
  });
}

class _ReviewCard extends StatelessWidget {
  final _Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.slate700,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(review.name,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text(review.date.toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.slate400,
                                letterSpacing: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(Icons.star_rounded,
                            color: i < review.rating
                                ? const Color(0xFF09F6AB)
                                : AppColors.slate700,
                            size: 14);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.text,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.slate400,
                  height: 1.5)),
        ],
      ),
    );
  }
}
