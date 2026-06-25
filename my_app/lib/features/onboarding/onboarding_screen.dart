import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _PageData(
      icon: Icons.storefront_rounded,
      secondIcon: Icons.shopping_basket_rounded,
      titleKey: 'onb_slide1_title',
      subKey: 'onb_slide1_sub',
    ),
    _PageData(
      icon: Icons.build_rounded,
      secondIcon: Icons.camera_alt_rounded,
      titleKey: 'onb_slide2_title',
      subKey: 'onb_slide2_sub',
    ),
    _PageData(
      icon: Icons.local_shipping_rounded,
      secondIcon: Icons.shield_rounded,
      titleKey: 'onb_slide3_title',
      subKey: 'onb_slide3_sub',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.go('/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/language'),
                child: Text(ref.tr('skip'),
                    style: GoogleFonts.inter(
                        color: AppColors.slate400, fontSize: 15)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageWidget(
                  page: _pages[i],
                  title: ref.tr(_pages[i].titleKey),
                  subtitle: ref.tr(_pages[i].subKey),
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.emerald600,
                dotColor: AppColors.slate700,
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLast ? ref.tr('btn_get_started') : ref.tr('next'),
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      if (isLast) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final IconData secondIcon;
  final String titleKey;
  final String subKey;
  const _PageData(
      {required this.icon,
      required this.secondIcon,
      required this.titleKey,
      required this.subKey});
}

class _PageWidget extends StatelessWidget {
  final _PageData page;
  final String title;
  final String subtitle;
  const _PageWidget({required this.page, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(page.icon,
                          color: AppColors.emerald600, size: 46),
                    ),
                    Positioned(
                      right: -28,
                      bottom: -18,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(page.secondIcon,
                            color: AppColors.emerald600, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 15, color: AppColors.slate400, height: 1.5),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
