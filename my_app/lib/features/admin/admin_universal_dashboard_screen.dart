import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

// Model Classes for Universal Management
class AdminUser {
  final String id;
  final String name;
  final String email;
  String role;
  String kycStatus; // 'Approved' | 'Pending' | 'Flagged'
  bool isBanned;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.kycStatus,
    this.isBanned = false,
  });
}

class AdminRider {
  final String id;
  final String name;
  String status; // 'Active' | 'In Transit' | 'Offline'
  final String zone;
  final double rating;

  AdminRider({
    required this.id,
    required this.name,
    required this.status,
    required this.zone,
    required this.rating,
  });
}

class AdminProduct {
  final String id;
  final String title;
  final String vendorName;
  final double price;
  bool isFlagged;

  AdminProduct({
    required this.id,
    required this.title,
    required this.vendorName,
    required this.price,
    this.isFlagged = false,
  });
}

class AdminUniversalDashboardScreen extends ConsumerStatefulWidget {
  const AdminUniversalDashboardScreen({super.key});

  @override
  ConsumerState<AdminUniversalDashboardScreen> createState() =>
      _AdminUniversalDashboardScreenState();
}

class _AdminUniversalDashboardScreenState
    extends ConsumerState<AdminUniversalDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Management State Lists
  final List<AdminUser> _users = [];
  final List<AdminRider> _riders = [];
  final List<AdminProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadInitialAdminState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadInitialAdminState() {
    // 1. Users Directory
    _users.addAll([
      AdminUser(id: 'u1', name: 'Akinade O.', email: 'akinade@martorax.com', role: 'SHOPPER', kycStatus: 'Approved'),
      AdminUser(id: 'u2', name: 'Mama Chidi', email: 'chidi@martorax.com', role: 'VENDOR', kycStatus: 'Approved'),
      AdminUser(id: 'u3', name: 'Efe Plumber', email: 'efe@martorax.com', role: 'PROVIDER', kycStatus: 'Pending'),
      AdminUser(id: 'u4', name: 'Rider Tobi', email: 'tobi@martorax.com', role: 'RIDER', kycStatus: 'Approved'),
    ]);

    // 2. Logistics Riders
    _riders.addAll([
      AdminRider(id: 'r1', name: 'Rider Tobi', status: 'In Transit', zone: 'Asaba Nnebisi', rating: 4.9),
      AdminRider(id: 'r2', name: 'Rider Chuka', status: 'Active', zone: 'Summit Road', rating: 4.7),
      AdminRider(id: 'r3', name: 'Rider Yusuf', status: 'Offline', zone: 'Okpanam Extension', rating: 4.8),
    ]);

    // 3. Products Catalog
    _products.addAll([
      AdminProduct(id: 'p1', title: 'Fresh Tomatoes (Basket)', vendorName: 'Ogbogonogo Agro', price: 4500.0),
      AdminProduct(id: 'p2', title: 'Premium Ankara 6Yards', vendorName: 'Mama Chidi Fabrics', price: 22800.0),
      AdminProduct(id: 'p3', title: 'Foreign Rice 50kg', vendorName: 'Asaba Wholesalers', price: 68000.0),
    ]);
  }

  // Admin Operational Controls
  void _toggleKyc(int index) {
    setState(() {
      final current = _users[index].kycStatus;
      _users[index].kycStatus = current == 'Approved' ? 'Pending' : 'Approved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emerald600,
        content: Text('KYC verification status updated for ${_users[index].name}!'),
      ),
    );
  }

  void _toggleBan(int index) {
    setState(() {
      _users[index].isBanned = !_users[index].isBanned;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _users[index].isBanned ? Colors.redAccent : AppColors.emerald600,
        content: Text(_users[index].isBanned
            ? 'Account for ${_users[index].name} has been suspended.'
            : 'Account for ${_users[index].name} restored successfully.'),
      ),
    );
  }

  void _toggleProductFlag(int index) {
    setState(() {
      _products[index].isFlagged = !_products[index].isFlagged;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _products[index].isFlagged ? Colors.redAccent : AppColors.emerald600,
        content: Text(_products[index].isFlagged
            ? 'Listing "${_products[index].title}" has been flagged and hidden.'
            : 'Listing "${_products[index].title}" verified and restored.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.darkBg.withValues(alpha: 0.9),
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                onPressed: () => context.pop(),
              ),
              title: Text(
                ref.tr('st_admin_universal'),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              centerTitle: false,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.emerald600,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.slate400,
                tabs: const [
                  Tab(text: 'Analytics'),
                  Tab(text: 'Users Directory'),
                  Tab(text: 'SafePay Escrows'),
                  Tab(text: 'Riders & Fleet'),
                  Tab(text: 'Wholesale Catalog'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAnalyticsTab(),
            _buildUsersTab(),
            _buildSafePayTab(),
            _buildRidersTab(),
            _buildCatalogTab(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: ANALYTICS COMMAND
  // ==========================================
  Widget _buildAnalyticsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatTile(
                title: 'Escrow Deposits',
                value: '₦1.24M',
                icon: Icons.account_balance_wallet_rounded,
                color: AppColors.emerald600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatTile(
                title: 'Platform Fee (1.5%)',
                value: '₦18,600',
                icon: Icons.percent_rounded,
                color: AppColors.amber500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatTile(
                title: 'Total Users',
                value: '${_users.length} Active',
                icon: Icons.people_alt_rounded,
                color: AppColors.emerald600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatTile(
                title: 'Active Riders',
                value: '${_riders.where((r) => r.status != 'Offline').length} Online',
                icon: Icons.local_shipping_rounded,
                color: AppColors.amber500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'PLATFORM ESCROW TRENDS',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slate400, letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Center(
            child: Icon(Icons.show_chart_rounded, color: AppColors.emerald600, size: 64),
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.slate400, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: USERS DIRECTORY
  // ==========================================
  Widget _buildUsersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      _buildChip(user.role),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'KYC: ${user.kycStatus}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: user.kycStatus == 'Approved' ? AppColors.emerald600 : AppColors.amber500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.verified_user_rounded,
                      color: user.kycStatus == 'Approved' ? AppColors.emerald600 : AppColors.slate400,
                    ),
                    onPressed: () => _toggleKyc(index),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.block_rounded,
                      color: user.isBanned ? Colors.redAccent : AppColors.slate400,
                    ),
                    onPressed: () => _toggleBan(index),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // TAB 3: SAFEPAY ESCROWS
  // ==========================================
  Widget _buildSafePayTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildEscrowTicket(
          code: 'DISP-MTX-8821',
          buyer: 'Akinade O.',
          merchant: 'TechFlow Solutions',
          amount: '₦11,000.00',
          reason: 'Pipe leaking again within 2 hours of fixing. Service provider refused to come back.',
        ),
        _buildEscrowTicket(
          code: 'DISP-MTX-9012',
          buyer: 'John Doe',
          merchant: 'Mama Chidi Fabrics',
          amount: '₦22,800.00',
          reason: 'Received standard cotton instead of the premium Ankara print ordered.',
        ),
      ],
    );
  }

  Widget _buildEscrowTicket({
    required String code,
    required String buyer,
    required String merchant,
    required String amount,
    required String reason,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
                code,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.emerald600),
              ),
              Text(
                'DISPUTED',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.amber500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Buyer: $buyer', style: GoogleFonts.inter(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
          Text('Merchant: $merchant', style: GoogleFonts.inter(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
          Text('Amount Held: $amount', style: GoogleFonts.inter(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(reason, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    side: BorderSide(color: AppColors.amber500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Refund Buyer', style: GoogleFonts.inter(color: AppColors.amber500)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Release to Merchant'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 4: RIDERS & FLEET CONTROL
  // ==========================================
  Widget _buildRidersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _riders.length,
      itemBuilder: (context, index) {
        final rider = _riders[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rider.name,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text('Zone: ${rider.zone}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: AppColors.amber500, size: 14),
                      const SizedBox(width: 4),
                      Text('${rider.rating}', style: GoogleFonts.inter(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              _buildRiderStatusBadge(rider.status),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRiderStatusBadge(String status) {
    Color color = AppColors.slate400;
    if (status == 'Active') color = AppColors.emerald600;
    if (status == 'In Transit') color = AppColors.amber500;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }

  // ==========================================
  // TAB 5: CATALOG GUARD
  // ==========================================
  Widget _buildCatalogTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: product.isFlagged ? AppColors.slate400 : Colors.white,
                      decoration: product.isFlagged ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Vendor: ${product.vendorName}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate400)),
                  const SizedBox(height: 4),
                  Text('Price: ₦${product.price.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.emerald600, fontWeight: FontWeight.w700)),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.flag_rounded,
                  color: product.isFlagged ? Colors.redAccent : AppColors.slate400,
                ),
                onPressed: () => _toggleProductFlag(index),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // Utility Widgets
  // ==========================================
  Widget _buildChip(String role) {
    Color color = AppColors.emerald600;
    if (role == 'VENDOR') color = AppColors.amber500;
    if (role == 'RIDER') color = Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role,
        style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}
