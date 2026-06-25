import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class GroupBuyInviteScreen extends ConsumerWidget {
  const GroupBuyInviteScreen({super.key});

  static const _participants = [
    _Participant('Chidi (You)', true),
    _Participant('Amaka', true),
    _Participant('Emeka', true),
    _Participant('Waiting...', false),
    _Participant('Waiting...', false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_group_buy_invite'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero banner
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.emerald700.withValues(alpha: 0.4),
                              AppColors.darkBg,
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              CustomPaint(
                                painter: _GroupBgPainter(),
                                child: const SizedBox.expand(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.emerald600,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('ACTIVE DEAL',
                                        style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            letterSpacing: 0.5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Headline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.3),
                            children: [
                              const TextSpan(
                                  text: 'Buy in bulk with others and save '),
                              TextSpan(
                                  text: '20% on delivery',
                                  style: TextStyle(
                                      color: AppColors.emerald600)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'MartoraX helps Asaba residents pool orders to slash logistics costs.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.slate400,
                                height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.slate700),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('PROGRESS',
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.slate400,
                                          letterSpacing: 1.5)),
                                  Text('Spots remaining',
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                ],
                              ),
                              Text('3/5',
                                  style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.emerald600)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: 0.6,
                              backgroundColor: AppColors.emerald600
                                  .withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.emerald600),
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.bolt_rounded,
                                  color: AppColors.emerald600, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                  'Only 2 spots left to lock in the discount!',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.emerald600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Participants
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Participants',
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Asaba Main Hub',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.slate400)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _participants.length,
                      itemBuilder: (context, i) {
                        final p = _participants[i];
                        return _ParticipantAvatar(p: p);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Bottom action hub
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              border: Border(top: BorderSide(color: AppColors.slate700)),
            ),
            child: Column(
              children: [
                // WhatsApp preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate700),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.chat_bubble_rounded,
                          color: AppColors.emerald600, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('WHATSAPP PREVIEW',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate400,
                                    letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text(
                                '"Join me on MartoraX to get 20% off delivery at Asaba Mall! Just 2 more people needed."',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white
                                        .withValues(alpha: 0.7),
                                    height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Join button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.group_add_rounded,
                        color: Colors.black, size: 20),
                    label: Text('Join Group Buy',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Share to WhatsApp button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_rounded,
                        color: Color(0xFF25D366), size: 20),
                    label: Text('Share to WhatsApp',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF25D366))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF25D366), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
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

class _Participant {
  final String name;
  final bool joined;
  const _Participant(this.name, this.joined);
}

class _ParticipantAvatar extends StatelessWidget {
  final _Participant p;
  const _ParticipantAvatar({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: p.joined ? AppColors.cardBg : AppColors.surfaceBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: p.joined
                    ? AppColors.emerald600
                    : AppColors.slate700,
                width: 2,
                style: p.joined ? BorderStyle.solid : BorderStyle.solid,
              ),
            ),
            child: p.joined
                ? Icon(Icons.person_rounded,
                    color: AppColors.slate400, size: 28)
                : Icon(Icons.person_add_rounded,
                    color: AppColors.slate400, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            p.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: p.joined ? Colors.white : AppColors.slate400),
          ),
        ],
      ),
    );
  }
}

class _GroupBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF0D1B2A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bg);
    final g = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.drawCircle(
          Offset(i * size.width / 4 + 20, j * size.height / 2 + 30),
          20,
          g,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GroupBgPainter o) => false;
}
