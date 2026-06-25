import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class AiServiceConciergeScreen extends ConsumerStatefulWidget {
  const AiServiceConciergeScreen({super.key});

  @override
  ConsumerState<AiServiceConciergeScreen> createState() =>
      _AiServiceConciergeScreenState();
}

class _AiServiceConciergeScreenState
    extends ConsumerState<AiServiceConciergeScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Column(
        children: [
          // App bar
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: AppColors.darkBg.withValues(alpha: 0.8),
              border: Border(
                  bottom: BorderSide(color: AppColors.slate700)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
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
                    child: Column(
                      children: [
                        Text(ref.tr('st_ai_concierge'),
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('MARTORAX ONLINE',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate400,
                                    letterSpacing: 1.2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
          // Chat history
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _AiMessage(
                    text:
                        'How can I help you find a service in Asaba today?'),
                const SizedBox(height: 12),
                _UserMessage(
                    text:
                        'My sink is leaking and I live in Okpanam'),
                const SizedBox(height: 12),
                _AiMessage(
                    text:
                        'I don find 3 plumbers near Okpanam for you. Emenike fit come now-now (₦5k)'),
                const SizedBox(height: 16),
                // Best matches header
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Row(
                    children: [
                      Icon(Icons.stars_rounded,
                          color: AppColors.emerald600, size: 14),
                      const SizedBox(width: 6),
                      Text('BEST MATCHES NEAR YOU',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emerald600,
                              letterSpacing: 1.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Provider carousel
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 56),
                    children: const [
                      _ProviderCard(
                        name: 'Emenike Plumbings',
                        rating: '4.9',
                        meta: '₦5,000 • Arrives Now-now',
                        primary: true,
                        badge: 'FASTEST',
                      ),
                      SizedBox(width: 12),
                      _ProviderCard(
                        name: 'Chidi Quick Fix',
                        rating: '4.7',
                        meta: '₦4,500 • 20 mins away',
                      ),
                      SizedBox(width: 12),
                      _ProviderCard(
                        name: 'Sunday Repairs',
                        rating: '4.5',
                        meta: '₦6,000 • Arrives 10 mins',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Input area
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkBg.withValues(alpha: 0.95),
              border: Border(
                  top: BorderSide(color: AppColors.slate700)),
            ),
            child: Column(
              children: [
                // Suggestion chips
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _SuggestionChip('Plumbing'),
                      _SuggestionChip('Electrical'),
                      _SuggestionChip('Cleaning'),
                      _SuggestionChip('Appliance Fix'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mic_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.only(
                            left: 20, right: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg,
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ctrl,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Type message...',
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.slate400),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiMessage extends StatelessWidget {
  final String text;
  const _AiMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.emerald600.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.emerald600
                    .withValues(alpha: 0.2),
                width: 2),
          ),
          child: Icon(Icons.auto_awesome_rounded,
              color: AppColors.emerald600, size: 20),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text('MartoraX',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate400)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(text,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserMessage extends StatelessWidget {
  final String text;
  const _UserMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 4, bottom: 4),
                child: Text('Shopper',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate400)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(text,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.5)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceBg,
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 2),
          ),
          child: Icon(Icons.person_rounded,
              color: AppColors.slate400, size: 20),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final String name;
  final String rating;
  final String meta;
  final bool primary;
  final String? badge;
  const _ProviderCard({
    required this.name,
    required this.rating,
    required this.meta,
    this.primary = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                color: AppColors.surfaceBg,
                child: Center(
                  child: Icon(Icons.plumbing_rounded,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 40),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.emerald600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(badge!,
                        style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: 0.5)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(name,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 2),
                    Text(rating,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(meta,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.slate400)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.go('/service/booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary
                          ? AppColors.emerald600
                          : AppColors.surfaceBg,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Book Now',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  const _SuggestionChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Center(
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.slate400)),
      ),
    );
  }
}
