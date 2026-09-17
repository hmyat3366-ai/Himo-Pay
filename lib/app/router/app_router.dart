import 'package:flutter/material.dart';
import '../../core/storage/app_preferences.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/campaign_screen.dart';
import '../../features/auth/screens/login_phone_screen.dart';
import '../../features/auth/screens/login_otp_screen.dart';
import '../../features/auth/screens/login_passcode_screen.dart';
import '../../features/auth/screens/signup_phone_screen.dart';
import '../../features/auth/screens/kyc_personal_screen.dart';
import '../../features/auth/screens/kyc_identity_screen.dart';
import '../../features/auth/screens/kyc_verify_screen.dart';
import '../../features/auth/screens/create_passcode_screen.dart';
import '../../features/auth/screens/forgot_passcode_screen.dart';
import '../../features/auth/screens/forgot_otp_screen.dart';
import '../../features/auth/screens/reset_new_passcode_screen.dart';
import '../../features/auth/screens/passcode_reset_success_screen.dart';

import '../../features/home/screens/main_shell_screen.dart';

import '../../features/transfer/screens/transfer_recipient_screen.dart';
import '../../features/transfer/screens/transfer_amount_screen.dart';
import '../../features/transfer/screens/transfer_review_screen.dart';
import '../../features/transfer/screens/transfer_security_screen.dart';
import '../../features/transfer/screens/transfer_success_screen.dart';
import '../../features/transfer/screens/transfer_receipt_screen.dart';

import '../../features/cash_in/screens/cashin_methods_screen.dart';
import '../../features/cash_in/screens/cashin_amount_screen.dart';
import '../../features/cash_in/screens/cashin_success_screen.dart';
import '../../features/cash_in/screens/cashin_receipt_screen.dart';

import '../../features/cash_out/screens/cashout_methods_screen.dart';
import '../../features/cash_out/screens/cashout_amount_screen.dart';
import '../../features/cash_out/screens/cashout_security_screen.dart';
import '../../features/cash_out/screens/cashout_success_screen.dart';
import '../../features/cash_out/screens/cashout_receipt_screen.dart';


import '../../features/qr/screens/my_qr_screen.dart';
import '../../features/qr/screens/scan_qr_screen.dart';
import '../../features/qr/screens/scan_payment_detail_screen.dart';
import '../../features/qr/screens/scan_payment_success_screen.dart';

import '../../features/services/screens/topup_screen.dart';
import '../../features/services/screens/topup_success_screen.dart';
import '../../features/services/screens/bills_categories_screen.dart';
import '../../features/services/screens/bills_provider_screen.dart';
import '../../features/services/screens/bills_success_screen.dart';
import '../../features/services/screens/giftcards_catalog_screen.dart';
import '../../features/services/screens/giftcards_success_screen.dart';
import '../../features/services/screens/deals_browse_screen.dart';
import '../../features/services/screens/deals_detail_screen.dart';
import '../../features/services/screens/deals_success_screen.dart';
import '../../features/services/screens/events_browse_screen.dart';
import '../../features/services/screens/events_detail_screen.dart';
import '../../features/services/screens/events_success_screen.dart';
import '../../features/services/screens/movies_listing_screen.dart';
import '../../features/services/screens/movies_seats_screen.dart';
import '../../features/services/screens/movies_success_screen.dart';
import '../../features/services/screens/insurance_plans_screen.dart';
import '../../features/services/screens/insurance_detail_screen.dart';
import '../../features/services/screens/insurance_success_screen.dart';
import '../../features/services/screens/more_services_screen.dart';

import '../../features/tickets/screens/my_tickets_screen.dart';
import '../../features/tickets/screens/ticket_detail_screen.dart';

import '../../features/campaign/screens/campaign_detail_screen.dart';
import '../../features/campaign/screens/campaign_activated_screen.dart';

import '../../features/history/screens/history_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';

import '../../features/wallet/screens/bank_accounts_screen.dart';
import '../../features/wallet/screens/linked_cards_screen.dart';
import '../../features/wallet/screens/wallet_vouchers_screen.dart';
import '../../features/wallet/screens/wallet_deals_screen.dart';
import '../../features/wallet/screens/tier_benefits_screen.dart';

import '../../features/rewards/screens/rewards_screen.dart';
import '../../features/rewards/screens/promo_vouchers_screen.dart';
import '../../features/rewards/screens/voucher_detail_screen.dart';
import '../../features/rewards/screens/secret_shop_screen.dart';
import '../../features/rewards/screens/points_history_screen.dart';

import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/user_level_screen.dart';
import '../../features/profile/screens/limits_fees_screen.dart';
import '../../features/profile/screens/referral_code_screen.dart';
import '../../features/profile/screens/about_himopay_screen.dart';
import '../../features/profile/screens/security_privacy_screen.dart';
import '../../features/profile/screens/otp_settings_screen.dart';
import '../../features/profile/screens/live_support_screen.dart';
import '../../features/profile/screens/help_center_screen.dart';
import '../../features/profile/screens/feedback_screen.dart';
import '../../features/profile/screens/personal_information_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings, {VoidCallback? onToggleTheme, bool isDark = false}) {
    final args = settings.arguments;
    final routeName = settings.name ?? '';

    // Auth & onboarding route whitelist
    final isAuthRoute = routeName == '/splash' ||
        routeName == '/login' ||
        routeName == '/login-phone' ||
        routeName == '/signup' ||
        routeName == '/signup-phone' ||
        routeName == '/login-otp' ||
        routeName == '/signup-otp' ||
        routeName == '/login-passcode' ||
        routeName == '/create-passcode' ||
        routeName == '/forgot-passcode' ||
        routeName == '/forgot-otp' ||
        routeName == '/reset-new-passcode' ||
        routeName == '/passcode-reset-success' ||
        routeName == '/campaign' ||
        routeName == '/kyc-personal' ||
        routeName == '/kyc-identity' ||
        routeName == '/kyc-verify';

    // If unauthenticated and not navigating inside the auth flow, enforce direct Login
    if (!AppPreferences.isLoggedIn && !isAuthRoute) {
      return MaterialPageRoute(
        builder: (_) => const LoginPhoneScreen(),
        settings: const RouteSettings(name: '/login-phone'),
      );
    }

    Widget page;
    switch (settings.name) {
      // Splash & Auth & Onboarding
      case '/splash':
        page = const SplashScreen();
        break;
      case '':
      case '/':
      case '/login':
      case '/login-phone':
        page = const LoginPhoneScreen();
        break;
      case '/campaign':
        page = const CampaignScreen();
        break;
      case '/login-otp':
      case '/signup-otp':
        page = const LoginOtpScreen();
        break;
      case '/login-passcode':
        page = const LoginPasscodeScreen();
        break;
      case '/signup':
      case '/signup-phone':
        page = const SignupPhoneScreen();
        break;
      case '/kyc-personal':
        page = const KycPersonalScreen();
        break;
      case '/kyc-identity':
        page = const KycIdentityScreen();
        break;
      case '/kyc-verify':
        page = const KycVerifyScreen();
        break;
      case '/create-passcode':
        page = const CreatePasscodeScreen();
        break;
      case '/forgot-passcode':
        page = const ForgotPasscodeScreen();
        break;
      case '/forgot-otp':
        page = ForgotOtpScreen(data: args as Map<String, dynamic>?);
        break;
      case '/reset-new-passcode':
        page = const ResetNewPasscodeScreen();
        break;
      case '/passcode-reset-success':
        page = const PasscodeResetSuccessScreen();
        break;

      // Home & Main Shell
      case '/main':
      case '/home':
        page = MainShellScreen(initialTab: 0, onToggleTheme: onToggleTheme, isDark: isDark);
        break;
      case '/pay-bill':
        page = const BillsCategoriesScreen();
        break;
      case '/top-up':
        page = const TopupScreen();
        break;

      // Transfer Suite
      case '/transfer-recipient':
        page = const TransferRecipientScreen();
        break;
      case '/transfer-amount':
        page = TransferAmountScreen(recipient: args is Map<String, String> ? args : null);
        break;
      case '/transfer-review':
        page = TransferReviewScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/transfer-security':
      case '/transfer-processing':
        page = TransferSecurityScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/transfer-success':
        page = TransferSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/transfer-receipt':
        page = TransferReceiptScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Cash In Suite
      case '/cashin-methods':
        page = const CashinMethodsScreen();
        break;
      case '/cashin-amount':
        page = CashinAmountScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/cashin-success':
        page = CashinSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/cashin-receipt':
        page = CashinReceiptScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Cash Out Suite
      case '/cashout-methods':
        page = const CashoutMethodsScreen();
        break;
      case '/cashout-amount':
        page = CashoutAmountScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/cashout-security':
        page = CashoutSecurityScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/cashout-success':
        page = CashoutSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/cashout-receipt':
        page = CashoutReceiptScreen(data: args is Map<String, dynamic> ? args : null);
        break;


      // QR Suite
      case '/my-qr':
      case '/specify-amount':
        page = const MyQrScreen();
        break;
      case '/scan-qr':
        page = const ScanQrScreen();
        break;
      case '/scan-payment-detail':
        page = ScanPaymentDetailScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/scan-payment-success':
        page = ScanPaymentSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Top Up Suite
      case '/topup-main':
        page = const TopupScreen();
        break;
      case '/topup-success':
        page = TopupSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Bills Suite
      case '/bills-categories':
        page = const BillsCategoriesScreen();
        break;
      case '/bills-provider':
        page = BillsProviderScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/bills-success':
        page = BillsSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Gift Cards Suite
      case '/giftcards-catalog':
        page = const GiftcardsCatalogScreen();
        break;
      case '/giftcards-success':
        page = GiftcardsSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Group Deals Suite
      case '/deals':
      case '/deals-browse':
        page = const DealsBrowseScreen();
        break;
      case '/deals-detail':
        page = DealsDetailScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/deals-success':
        page = DealsSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Events Suite
      case '/events-browse':
        page = const EventsBrowseScreen();
        break;
      case '/events-detail':
        page = EventsDetailScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/events-success':
        page = EventsSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Movies Suite
      case '/movies-listing':
        page = const MoviesListingScreen();
        break;
      case '/movies-seats':
        page = MoviesSeatsScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/movies-success':
        page = MoviesSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Insurance Suite
      case '/insurance-plans':
        page = const InsurancePlansScreen();
        break;
      case '/insurance-detail':
        page = InsuranceDetailScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/insurance-success':
        page = InsuranceSuccessScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // More Services
      case '/more-services':
        page = const MoreServicesScreen();
        break;

      // Tickets Hub
      case '/my-tickets':
        page = const MyTicketsScreen();
        break;
      case '/ticket-detail':
        page = TicketDetailScreen(data: args is Map<String, dynamic> ? args : null);
        break;

      // Campaign
      case '/campaign-detail':
        page = const CampaignDetailScreen();
        break;
      case '/campaign-activated':
        page = const CampaignActivatedScreen();
        break;

      // History & Notifications
      case '/history':
      case '/history-all':
        page = const HistoryScreen();
        break;
      case '/notifications':
        page = const NotificationsScreen();
        break;

      // Wallet Suite
      case '/wallet-tab':
        page = MainShellScreen(initialTab: 1, onToggleTheme: onToggleTheme, isDark: isDark);
        break;
      case '/wallet-bank-accounts':
        page = const BankAccountsScreen();
        break;
      case '/wallet-cards':
        page = const LinkedCardsScreen();
        break;
      case '/wallet-vouchers':
        page = const WalletVouchersScreen();
        break;
      case '/wallet-deals':
        page = const WalletDealsScreen();
        break;
      case '/tier-benefits':
        page = const TierBenefitsScreen();
        break;

      // Rewards Suite
      case '/rewards':
        page = const RewardsScreen();
        break;
      case '/promo-vouchers':
        page = const PromoVouchersScreen();
        break;
      case '/voucher-detail':
        page = VoucherDetailScreen(data: args is Map<String, dynamic> ? args : null);
        break;
      case '/secret-shop':
        page = const SecretShopScreen();
        break;
      case '/points-history':
        page = const PointsHistoryScreen();
        break;

      // Profile Suite
      case '/profile':
        page = ProfileScreen(onToggleTheme: onToggleTheme, isDark: isDark);
        break;
      case '/profile-detail':
      case '/personal-information':
        page = const PersonalInformationScreen();
        break;
      case '/security-privacy':
        page = const SecurityPrivacyScreen();
        break;
      case '/live-support':
        page = const LiveSupportScreen();
        break;
      case '/about-himopay':
        page = const AboutHimopayScreen();
        break;
      case '/referral-code':
        page = const ReferralCodeScreen();
        break;
      case '/limits-fees':
        page = const LimitsFeesScreen();
        break;
      case '/user-level':
        page = const UserLevelScreen();
        break;
      case '/otp-settings':
        page = const OtpSettingsScreen();
        break;
      case '/feedback':
        page = const FeedbackScreen();
        break;
      case '/help-center':
        page = const HelpCenterScreen();
        break;

      default:
        page = AppPreferences.isLoggedIn
            ? MainShellScreen(initialTab: 0, onToggleTheme: onToggleTheme, isDark: isDark)
            : const LoginPhoneScreen();
    }

    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
