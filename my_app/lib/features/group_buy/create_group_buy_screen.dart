import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class CreateGroupBuyScreen extends ConsumerStatefulWidget {
  const CreateGroupBuyScreen({super.key});

  @override
  ConsumerState<CreateGroupBuyScreen> createState() => _CreateGroupBuyScreenState();
}

class _CreateGroupBuyScreenState extends ConsumerState<CreateGroupBuyScreen> {
  int _groupSize = 10;
  int _expiryIdx = 2;
  bool _autoCancel = true;
  final _priceCtrl =
      TextEditingController(text: '12500');

  static const _groupSizes = [5, 10, 20];
  static const _expiries = ['6 Hours', '12 Hours', '24 Hours', '48 Hours'];

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_group_buy_create'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      return Container(
                        width: 32,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: i == 0
                              ? AppColors.emerald600
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
                // Step 1: Select product
                _stepLabel('STEP 1: SELECT PRODUCT'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.emerald600.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.eco_rounded,
                              color: AppColors.emerald600, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fresh Farm Tomatoes (Big Basket)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('Original Price: ',
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white
                                              .withValues(alpha: 0.6))),
                                  Text('₦15,000',
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white
                                              .withValues(alpha: 0.4),
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle_rounded,
                            color: AppColors.emerald600, size: 22),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Step 2: Group size
                _stepLabel('STEP 2: SET GROUP SIZE'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      ..._groupSizes.map((size) {
                        final isSelected = _groupSize == size;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _groupSize = size),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.emerald600
                                    : Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.emerald600
                                      : Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text('$size',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                  Text('PEOPLE',
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                              .withValues(alpha: isSelected ? 0.8 : 0.5),
                                          letterSpacing: 0.5)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.add_rounded,
                                    color: Colors.white, size: 22),
                                Text('CUSTOM',
                                    style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(alpha: 0.5),
                                        letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Step 3: Discounted price
                _stepLabel('STEP 3: SET DISCOUNTED PRICE'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text('₦',
                                  style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.emerald600)),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _priceCtrl,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: '12,500',
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 22,
                                      color: AppColors.slate400),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: AppColors.slate400, size: 14),
                          const SizedBox(width: 6),
                          Text('Suggested discount for 10 people: 15% - 25% off',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.4))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Step 4: Expiry time
                _stepLabel('STEP 4: SET EXPIRY TIME'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_expiries.length, (i) {
                      final isSelected = _expiryIdx == i;
                      return GestureDetector(
                        onTap: () => setState(() => _expiryIdx = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.emerald600
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.emerald600
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(_expiries[i],
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: Colors.white)),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),
                // Auto-cancel toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Auto-cancel if not filled',
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(
                                  'Automatically refund buyers if group isn\'t full',
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.white.withValues(alpha: 0.5))),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _autoCancel = !_autoCancel),
                          child: _ToggleSwitch(value: _autoCancel),
                        ),
                      ],
                    ),
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
              color: AppColors.darkBg.withValues(alpha: 0.95),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.go('/group-buy/invite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Create Group Deal',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavItem(Icons.space_dashboard_rounded, 'Dashboard',
                          false, () => context.go('/vendor/dashboard')),
                      _NavItem(Icons.inventory_2_rounded, 'Inventory', true,
                          () {}),
                      _NavItem(Icons.shopping_cart_rounded, 'Orders', false,
                          () => context.go('/vendor/orders')),
                      _NavItem(Icons.person_rounded, 'Profile', false, () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _stepLabel(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(text,
        style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.6),
            letterSpacing: 1.0)),
  );
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  const _ToggleSwitch({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: value
            ? AppColors.emerald600
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 150),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
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
              color: active ? AppColors.emerald600 : AppColors.slate400,
              size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color:
                      active ? AppColors.emerald600 : AppColors.slate400)),
        ],
      ),
    );
  }
}
