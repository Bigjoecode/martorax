import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

// Admin Dispute Ticket Model
class DisputeTicket {
  final String id;
  final String disputeCode;
  final String holdCode;
  final String buyerName;
  final String merchantName;
  final double amount;
  final String reason;
  final String date;
  String status; // 'pending' | 'released' | 'refunded'

  DisputeTicket({
    required this.id,
    required this.disputeCode,
    required this.holdCode,
    required this.buyerName,
    required this.merchantName,
    required this.amount,
    required this.reason,
    required this.date,
    this.status = 'pending',
  });
}

class AdminEscrowDashboardScreen extends ConsumerStatefulWidget {
  const AdminEscrowDashboardScreen({super.key});

  @override
  ConsumerState<AdminEscrowDashboardScreen> createState() =>
      _AdminEscrowDashboardScreenState();
}

class _AdminEscrowDashboardScreenState
    extends ConsumerState<AdminEscrowDashboardScreen> {
  final List<DisputeTicket> _disputes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadDisputeTickets();
  }

  void _loadDisputeTickets() {
    _disputes.addAll([
      DisputeTicket(
        id: 'disp_1',
        disputeCode: 'DISP-MTX-8821',
        holdCode: 'SP-MTX-8821',
        buyerName: 'Akinade O.',
        merchantName: 'TechFlow Solutions',
        amount: 11000.0,
        reason: 'Pipe leaking again within 2 hours of fixing. Service provider refused to come back.',
        date: 'Today, 02:14 PM',
      ),
      DisputeTicket(
        id: 'disp_2',
        disputeCode: 'DISP-MTX-9012',
        holdCode: 'SP-MTX-9012',
        buyerName: 'John Doe',
        merchantName: 'Mama Chidi Fabrics',
        amount: 22800.0,
        reason: 'Received standard cotton instead of the premium Ankara print ordered.',
        date: 'Yesterday, 11:30 AM',
      ),
    ]);
  }

  // Admin Escrow Resolve Action
  Future<void> _adjudicateEscrow({
    required int index,
    required bool approveMerchant, // true = release to merchant, false = refund to buyer
  }) async {
    setState(() => _loading = true);

    // Simulate database RPC call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      _disputes[index].status = approveMerchant ? 'released' : 'refunded';
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: approveMerchant ? AppColors.emerald600 : AppColors.amber500,
        content: Text(
          approveMerchant
              ? 'SafePay Escrow Released to ${_disputes[index].merchantName} successfully!'
              : 'Escrow Refunded back to ${_disputes[index].buyerName} successfully!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Admin Header
              SliverAppBar(
                backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  ref.tr('st_admin_escrow'),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                centerTitle: false,
              ),

              // Overview Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYSTEM OVERVIEW',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slate400,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Escrow Volume',
                              value: '₦345.8K',
                              icon: Icons.account_balance_wallet_rounded,
                              color: AppColors.emerald600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Active Disputes',
                              value: '${_disputes.where((d) => d.status == 'pending').length} Open',
                              icon: Icons.gavel_rounded,
                              color: AppColors.amber500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Disputes Queue Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(
                    'DISPUTES SETTLEMENT HUB',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.slate400,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // Dispute List Items
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ticket = _disputes[index];
                    return _buildDisputeCard(ticket, index);
                  },
                  childCount: _disputes.length,
                ),
              ),
            ],
          ),

          // Loading Overlay blocker
          if (_loading)
            Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.emerald600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.slate400),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(DisputeTicket ticket, int index) {
    final bool isPending = ticket.status == 'pending';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.disputeCode,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.emerald600),
              ),
              _buildStatusBadge(ticket.status),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Held Code', ticket.holdCode),
          _buildDetailRow('Buyer', ticket.buyerName),
          _buildDetailRow('Merchant', ticket.merchantName),
          _buildDetailRow('Amount Held', '₦${ticket.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          Text(
            'DISPUTE GROUNDS:',
            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.slate400, letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.reason,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8), height: 1.4),
          ),
          const SizedBox(height: 16),
          
          // Action Buttons (Only visible if pending)
          if (isPending)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _adjudicateEscrow(index: index, approveMerchant: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      side: BorderSide(color: AppColors.amber500),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Refund Buyer',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.amber500),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _adjudicateEscrow(index: index, approveMerchant: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Release Merchant',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = AppColors.darkBg;
    Color text = AppColors.slate400;
    String label = 'PENDING';

    if (status == 'released') {
      bg = AppColors.emerald600.withValues(alpha: 0.1);
      text = AppColors.emerald600;
      label = 'RELEASED';
    } else if (status == 'refunded') {
      bg = AppColors.amber500.withValues(alpha: 0.1);
      text = AppColors.amber500;
      label = 'REFUNDED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: text),
      ),
    );
  }
}
