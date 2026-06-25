import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class OrderReceiptScreen extends ConsumerWidget {
  const OrderReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(ref.tr('st_order_receipt'),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded,
                color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white
                                      .withValues(alpha: 0.1))),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.emerald600
                                    .withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppColors.emerald600
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Icon(
                                  Icons.storefront_rounded,
                                  color: AppColors.emerald600,
                                  size: 28),
                            ),
                            const SizedBox(height: 16),
                            Text('MARTORAX',
                                style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.0)),
                            const SizedBox(height: 8),
                            Text('Fresh Mart Vendor',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            const SizedBox(height: 2),
                            Text('Stall #B24 • Oct 24, 2023',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate400)),
                            const SizedBox(height: 4),
                            Text('TRX ID: MTX-992384-01',
                                style: GoogleFonts.robotoMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate400
                                        .withValues(alpha: 0.7),
                                    letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                      // Items
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  bottom: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.white
                                            .withValues(
                                                alpha: 0.1))),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('DESCRIPTION',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.w800,
                                          color:
                                              AppColors.slate400,
                                          letterSpacing: 1.5)),
                                  Text('AMOUNT',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.w800,
                                          color:
                                              AppColors.slate400,
                                          letterSpacing: 1.5)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _item('Organic Tomatoes (5kg)',
                                'Qty: 1', '₦4,500'),
                            _item('Fresh Habanero Pepper',
                                'Qty: 2', '₦1,200'),
                            _item('Red Bell Peppers',
                                'Qty: 3', '₦3,300'),
                          ],
                        ),
                      ),
                      // Dashed divider
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24),
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          size: const Size(double.infinity, 1),
                        ),
                      ),
                      // Totals
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            24, 16, 24, 24),
                        child: Column(
                          children: [
                            _totalRow('Subtotal', '₦9,000'),
                            const SizedBox(height: 8),
                            _totalRow('Delivery Fee', '₦1,500'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: Colors.white)),
                                Text('₦10,500',
                                    style: GoogleFonts.inter(
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: AppColors
                                            .emerald600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // QR code
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            24, 16, 24, 40),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: CustomPaint(
                                size: const Size(128, 128),
                                painter: _QrPainter(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                                'Scan to verify order status\non the MartoraX Network',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.slate400,
                                    height: 1.5)),
                          ],
                        ),
                      ),
                      // Zigzag bottom
                      CustomPaint(
                        painter: _ZigZagPainter(),
                        size: const Size(double.infinity, 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Footer actions
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              border: Border(
                  top: BorderSide(color: AppColors.slate700)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print_rounded,
                        color: Colors.white, size: 20),
                    label: Text('Print Receipt',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald600,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                            color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.slate700),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14)),
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

  Widget _item(String name, String qty, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                Text(qty,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.slate400)),
              ],
            ),
          ),
          Text(amount,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.slate400)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.slate400)),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 2;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
          Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter o) => false;
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final cellSize = size.width / 16;
    final seed = 0x4D7;
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        final hash = (i * 31 + j * 17 + seed) & 0xff;
        if (hash % 3 == 0) {
          canvas.drawRect(
              Rect.fromLTWH(i * cellSize, j * cellSize, cellSize,
                  cellSize),
              paint);
        }
      }
    }
    // Corner finder patterns
    void corner(double x, double y) {
      canvas.drawRect(
          Rect.fromLTWH(x, y, cellSize * 4, cellSize * 4), paint);
      canvas.drawRect(
          Rect.fromLTWH(x + cellSize, y + cellSize,
              cellSize * 2, cellSize * 2),
          Paint()..color = Colors.white);
    }

    corner(0, 0);
    corner(size.width - cellSize * 4, 0);
    corner(0, size.height - cellSize * 4);
  }

  @override
  bool shouldRepaint(_QrPainter o) => false;
}

class _ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkBg
      ..style = PaintingStyle.fill;
    final path = Path()..moveTo(0, 0);
    const peakWidth = 12.0;
    double x = 0;
    bool peak = false;
    while (x < size.width) {
      path.lineTo(x + peakWidth / 2, peak ? 0 : size.height);
      x += peakWidth / 2;
      peak = !peak;
    }
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ZigZagPainter o) => false;
}
