import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class VendorOrderDetailsScreen extends StatelessWidget {
  const VendorOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white, size: 20),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #MTX-99201',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            color: AppColors.emerald600, size: 12),
                        const SizedBox(width: 4),
                        Text('Asaba • Behind XYZ Filling Station',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.emerald600)),
                      ],
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.info_outline_rounded,
                          color: AppColors.slate400, size: 18),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 220),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // SafePay banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.emerald600
                              .withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.emerald600
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.emerald600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.verified_user_rounded,
                                  color: Colors.white,
                                  size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'SafePay Escrow Active',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: AppColors
                                              .emerald600)),
                                  Text(
                                      '₦33,000 held securely. Release on delivery.',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color:
                                              AppColors.slate400)),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.emerald600
                                    .withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text('SECURED',
                                  style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight:
                                          FontWeight.w700,
                                      color: AppColors
                                          .emerald600,
                                      letterSpacing: 1.0)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _sectionLabel('CUSTOMER COMMUNICATION'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
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
                                  ),
                                  child: Icon(
                                      Icons.person_rounded,
                                      color:
                                          AppColors.slate400,
                                      size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Chidi K.',
                                          style:
                                              GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white,
                                          )),
                                      Text(
                                          'Last seen 5m ago',
                                          style:
                                              GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors
                                                .slate400,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionButton(
                                      icon: Icons.call_rounded,
                                      label: 'Call (Masked)'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ActionButton(
                                      icon:
                                          Icons.chat_rounded,
                                      label: 'Chat'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _sectionLabel('ORDER ITEMS (2)'),
                          Text('Weight: ~6.5kg',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.slate400)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
                        ),
                        child: Column(
                          children: [
                            _OrderItem(
                              icon: Icons.rice_bowl_rounded,
                              name:
                                  'Premium White Garri - 5kg',
                              meta: '₦12,500 × 2',
                              total: '₦25,000',
                              hasDivider: true,
                            ),
                            _OrderItem(
                              icon: Icons.local_florist_rounded,
                              name:
                                  'Fresh Onions - Large Basket',
                              meta: '₦8,000 × 1',
                              total: '₦8,000',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order Total',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight.w500,
                                    color: AppColors.slate400)),
                            Text('₦33,000',
                                style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.w800,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _sectionLabel('LOGISTICS'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.slate700),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald600
                                        .withValues(alpha: 0.2),
                                    borderRadius:
                                        BorderRadius.circular(
                                            8),
                                  ),
                                  child: Icon(
                                      Icons.moped_rounded,
                                      color: AppColors
                                          .emerald600,
                                      size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'No rider assigned yet',
                                          style:
                                              GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white,
                                          )),
                                      const SizedBox(height: 4),
                                      Text(
                                          'Request a local rider for delivery to the Landmark: Behind XYZ Filling Station.',
                                          style:
                                              GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors
                                                .slate400,
                                            height: 1.5,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    context.go('/rider/discovery'),
                                icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 18),
                                label: Text('Request Rider',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.emerald600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              12)),
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
            ],
          ),
          // Bottom footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.darkBg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.go('/vendor/orders'),
                        icon: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 22),
                        label: Text(
                            'Mark as Ready for Pickup',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.emerald600,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkBg
                          .withValues(alpha: 0.95),
                      border: Border(
                          top: BorderSide(
                              color: AppColors.slate700)),
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom:
                          MediaQuery.of(context).padding.bottom +
                              12,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(Icons.dashboard_rounded,
                            'Dashboard', false,
                            () => context
                                .go('/vendor/dashboard')),
                        _NavItem(Icons.inventory_2_rounded,
                            'Inventory', false,
                            () => context
                                .go('/vendor/inventory')),
                        _NavItem(Icons.assignment_rounded,
                            'Orders', true,
                            () => context
                                .go('/vendor/orders')),
                        _NavItem(Icons.person_rounded,
                            'Profile', false,
                            () => context.go('/profile')),
                      ],
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

  Widget _sectionLabel(String text) {
    return Text(text,
        style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.slate400,
            letterSpacing: 1.5));
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String meta;
  final String total;
  final bool hasDivider;
  const _OrderItem({
    required this.icon,
    required this.name,
    required this.meta,
    required this.total,
    this.hasDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: hasDivider
            ? Border(
                bottom: BorderSide(color: AppColors.slate700))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                color: AppColors.emerald600, size: 36),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(meta,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.slate400)),
              ],
            ),
          ),
          Text(total,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
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
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.emerald600
                      : AppColors.slate400)),
        ],
      ),
    );
  }
}
