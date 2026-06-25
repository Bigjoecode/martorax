import 'package:go_router/go_router.dart';
import '../supabase/supabase_config.dart';
import 'scaffold_with_nav_bar.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/language_selection_screen.dart';
import '../../features/onboarding/get_started_screen.dart';
import '../../features/onboarding/role_selection_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/product/product_detail_screen.dart';
import '../../features/vendor/vendor_register_screen.dart';
import '../../features/vendor/vendor_kyc_screen.dart';
import '../../features/vendor/vendor_location_screen.dart';
import '../../features/vendor/vendor_dashboard_screen.dart';
import '../../features/vendor/vendor_orders_screen.dart';
import '../../features/vendor/vendor_inventory_screen.dart';
import '../../features/vendor/vendor_go_live_screen.dart';
import '../../features/vendor/vendor_sales_analytics_screen.dart';
import '../../features/provider/provider_register_screen.dart';
import '../../features/provider/provider_kyc_screen.dart';
import '../../features/provider/provider_dashboard_screen.dart';
import '../../features/provider/service_booking_screen.dart';
import '../../features/provider/service_provider_portfolio_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/checkout_delivery_screen.dart';
import '../../features/checkout/checkout_payment_screen.dart';
import '../../features/checkout/paystack_checkout_screen.dart';
import '../supabase/paystack_payment_service.dart';
import '../../features/checkout/checkout_confirm_screen.dart';
import '../../features/checkout/order_confirmation_screen.dart';
import '../../features/orders/order_status_screen.dart';
import '../../features/orders/delivery_tracking_screen.dart';
import '../../features/orders/delivery_rating_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/wallet/history_statements_screen.dart';
import '../../features/wallet/link_bank_account_screen.dart';
import '../../features/wallet/shopper_confirm_release_screen.dart';
import '../../features/wallet/escrow_dispute_screen.dart';
import '../../features/notifications/notification_screen.dart';
import '../../features/market/market_cluster_screen.dart';
import '../../features/market/market_hubs_screen.dart';
import '../../features/live/live_deals_screen.dart';
import '../../features/group_buy/create_group_buy_screen.dart';
import '../../features/group_buy/group_buy_invite_screen.dart';
import '../../features/rider/rider_registration_screen.dart';
import '../../features/rider/rider_service_dashboard_screen.dart';
import '../../features/rider/rider_in_transit_view_screen.dart';
import '../../features/rider/rider_earnings_hub_screen.dart';
import '../../features/rider/shopper_rider_discovery_screen.dart';
import '../../features/profile/shopper_profile_screen.dart';
import '../../features/bookings/shopper_bookings_screen.dart';
import '../../features/ai/ai_personalized_feed_screen.dart';
import '../../features/ai/ai_service_concierge_screen.dart';
import '../../features/orders/delivery_success_screen.dart';
import '../../features/provider/leads_management_screen.dart';
import '../../features/market/market_trends_screen.dart';
import '../../features/search/search_filters_screen.dart';
import '../../features/provider/provider_chat_screen.dart';
import '../../features/orders/delivery_tracking_safety_screen.dart';
import '../../features/provider/nearby_services_map_screen.dart';
import '../../features/provider/shopper_quote_approval_screen.dart';
import '../../features/ai/ai_smart_quote_screen.dart';
import '../../features/vendor/vendor_order_details_screen.dart';
import '../../features/admin/admin_escrow_dashboard_screen.dart';
import '../../features/admin/admin_universal_dashboard_screen.dart';
import '../../features/kyc/kyc_verify_screen.dart';
import '../widgets/role_gate.dart';

// Routes that are reachable WITHOUT being signed in.
const _publicPaths = {
  '/',
  '/onboarding',
  '/language',
  '/get-started',
  '/role',
  '/login',
  '/register',
  '/vendor/register',
  '/provider/register',
  '/rider/register',
};

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isSignedIn = SupabaseConfig.client.auth.currentSession != null;
    final path = state.matchedLocation;
    final isPublic = _publicPaths.contains(path);
    // Block protected paths if not signed in.
    if (!isSignedIn && !isPublic) return '/login';
    // If signed in and trying to view auth screens, send to /home.
    if (isSignedIn && (path == '/login' || path == '/register')) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/language', builder: (_, __) => const LanguageSelectionScreen()),
    GoRoute(path: '/get-started', builder: (_, __) => const GetStartedScreen()),
    GoRoute(path: '/role', builder: (_, __) => const RoleSelectionScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/product', builder: (_, __) => const ProductDetailScreen()),
    
    // Stateful tab navigation shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/bookings', builder: (_, __) => const ShopperBookingsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, __) => const ShopperProfileScreen()),
          ],
        ),
      ],
    ),

    // Vendor flows
    GoRoute(path: '/vendor/register', builder: (_, __) => const VendorRegisterScreen()),
    GoRoute(path: '/vendor/kyc', builder: (_, __) => const VendorKycScreen()),
    GoRoute(path: '/vendor/location', builder: (_, __) => const VendorLocationScreen()),
    GoRoute(
        path: '/vendor/dashboard',
        builder: (_, __) =>
            const RoleGate(requiredRole: 'vendor', child: VendorDashboardScreen())),
    GoRoute(path: '/vendor/orders', builder: (_, __) => const VendorOrdersScreen()),
    GoRoute(path: '/vendor/inventory', builder: (_, __) => const VendorInventoryScreen()),
    GoRoute(path: '/vendor/go-live', builder: (_, __) => const VendorGoLiveScreen()),
    GoRoute(path: '/vendor/analytics', builder: (_, __) => const VendorSalesAnalyticsScreen()),
    // Provider flows
    GoRoute(path: '/provider/register', builder: (_, __) => const ProviderRegisterScreen()),
    GoRoute(path: '/provider/kyc', builder: (_, __) => const ProviderKycScreen()),
    GoRoute(
        path: '/provider/dashboard',
        builder: (_, __) =>
            const RoleGate(requiredRole: 'provider', child: ProviderDashboardScreen())),
    GoRoute(path: '/provider/portfolio', builder: (_, __) => const ServiceProviderPortfolioScreen()),
    GoRoute(path: '/service/booking', builder: (_, __) => const ServiceBookingScreen()),
    // Cart & Checkout
    GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
    GoRoute(path: '/checkout/delivery', builder: (_, __) => const CheckoutDeliveryScreen()),
    GoRoute(path: '/checkout/payment', builder: (_, __) => const CheckoutPaymentScreen()),
    GoRoute(
      path: '/checkout/paystack',
      builder: (_, state) {
        final extra = (state.extra as Map?) ?? const {};
        final items = (extra['items'] as List?)?.cast<CheckoutItem>() ?? const [];
        return PaystackCheckoutScreen(
          items: items,
          landmark: extra['landmark'] as String? ?? '',
        );
      },
    ),
    GoRoute(path: '/checkout/confirm', builder: (_, __) => const CheckoutConfirmScreen()),
    GoRoute(path: '/order/confirmation', builder: (_, __) => const OrderConfirmationScreen()),
    GoRoute(path: '/order/status', builder: (_, __) => const OrderStatusScreen()),
    GoRoute(path: '/order/tracking', builder: (_, __) => const DeliveryTrackingScreen()),
    GoRoute(path: '/order/rating', builder: (_, __) => const DeliveryRatingScreen()),
    // Wallet & Escrow
    GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
    GoRoute(path: '/history', builder: (_, __) => const HistoryStatementsScreen()),
    GoRoute(path: '/link-bank', builder: (_, __) => const LinkBankAccountScreen()),
    GoRoute(path: '/confirm-release', builder: (_, __) => const ShopperConfirmReleaseScreen()),
    GoRoute(path: '/escrow-dispute', builder: (_, __) => const EscrowDisputeScreen()),
    GoRoute(path: '/admin/escrow', builder: (_, __) => const AdminEscrowDashboardScreen()),
    GoRoute(path: '/admin/universal', builder: (_, __) => const AdminUniversalDashboardScreen()),
    GoRoute(path: '/payment-success', builder: (_, __) => const OrderConfirmationScreen()),
    GoRoute(path: '/notifications', builder: (_, __) => const NotificationScreen()),
    // Market
    GoRoute(path: '/market/ogbogonogo', builder: (_, __) => const MarketClusterScreen()),
    GoRoute(path: '/market/hubs', builder: (_, __) => const MarketHubsScreen()),
    // Live
    GoRoute(path: '/live', builder: (_, __) => const LiveDealsScreen()),
    // Group Buy
    GoRoute(path: '/group-buy/create', builder: (_, __) => const CreateGroupBuyScreen()),
    GoRoute(path: '/group-buy/invite', builder: (_, __) => const GroupBuyInviteScreen()),
    // Rider
    GoRoute(path: '/rider/register', builder: (_, __) => const RiderRegistrationScreen()),
    GoRoute(
        path: '/rider/dashboard',
        builder: (_, __) =>
            const RoleGate(requiredRole: 'rider', child: RiderServiceDashboardScreen())),
    GoRoute(path: '/rider/in-transit', builder: (_, __) => const RiderInTransitViewScreen()),
    GoRoute(path: '/rider/earnings', builder: (_, __) => const RiderEarningsHubScreen()),
    GoRoute(path: '/rider/discovery', builder: (_, __) => const ShopperRiderDiscoveryScreen()),
    // AI
    GoRoute(path: '/ai/feed', builder: (_, __) => const AiPersonalizedFeedScreen()),
    GoRoute(path: '/ai/concierge', builder: (_, __) => const AiServiceConciergeScreen()),
    // Extras
    GoRoute(path: '/delivery-success', builder: (_, __) => const DeliverySuccessScreen()),
    GoRoute(path: '/provider/leads', builder: (_, __) => const LeadsManagementScreen()),
    GoRoute(path: '/market/trends', builder: (_, __) => const MarketTrendsScreen()),
    GoRoute(path: '/search/filters', builder: (_, __) => const SearchFiltersScreen()),
    GoRoute(path: '/provider/chat', builder: (_, __) => const ProviderChatScreen()),
    GoRoute(path: '/order/tracking-safety', builder: (_, __) => const DeliveryTrackingSafetyScreen()),
    GoRoute(path: '/services/map', builder: (_, __) => const NearbyServicesMapScreen()),
    GoRoute(path: '/quote/approval', builder: (_, __) => const ShopperQuoteApprovalScreen()),
    GoRoute(path: '/ai/smart-quote', builder: (_, __) => const AiSmartQuoteScreen()),
    GoRoute(path: '/vendor/order-details', builder: (_, __) => const VendorOrderDetailsScreen()),
    GoRoute(path: '/kyc/verify', builder: (_, __) => const KycVerifyScreen()),
  ],
);
