import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/views/auth/jetorderer_auth/orderer_login_screen.dart';
import 'package:jet_picks_app/App/views/auth/jetorderer_auth/orderer_signup_screen.dart';
import 'package:jet_picks_app/App/views/auth/jetpicker_auth/login_screen.dart';
import 'package:jet_picks_app/App/views/auth/jetpicker_auth/signup_screen.dart';
import 'package:jet_picks_app/App/views/bottom_bar/picker_bottom_bar_screen.dart';
import 'package:jet_picks_app/App/views/chat_screen/conversation_screen.dart';
import 'package:jet_picks_app/App/views/order_detail/counter_offer_screen.dart';
import 'package:jet_picks_app/App/views/order_screen/accept_orderdetail_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/bottom_bar/orderer_bottom_bar_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/order_accepted/offer_received_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/order_accepted/order_accepted_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_chat/orderer_conversation_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_order/order_history_detail_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_profile/opayment_method_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_profile/opersonal_detail_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_profile/osetting_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/profile_setup/orderer_profilesetup_screen.dart';
import 'package:jet_picks_app/App/views/profile_screen/bank_detail_screen.dart';
import 'package:jet_picks_app/App/views/profile_screen/payment_method_screen.dart';
import 'package:jet_picks_app/App/views/profile_screen/personal_detail_screen.dart';
import 'package:jet_picks_app/App/views/profile_screen/setting_screen.dart';
import 'package:jet_picks_app/App/views/profile_screen/travel_detail_screen.dart';
import 'package:jet_picks_app/App/views/profile_setup/travel_detail_setup_screen.dart';
import 'package:jet_picks_app/App/views/role_selection/role_selection_screen.dart';
import 'package:jet_picks_app/App/views/role_selection/welcome_jetorderer_screen.dart';
import 'package:jet_picks_app/App/views/role_selection/welcome_jetpicker_screen.dart';
import 'package:jet_picks_app/App/views/splash_screen.dart/howitwork_screen.dart';
import '../views/order_detail/order_detail_screen.dart';
import '../views/orderer_side/delivery_route/delivery_flow_screen.dart';
import '../views/orderer_side/orderer_profile/extra_card_screen.dart';
import '../views/profile_setup/profile_setup_screen.dart';
import '../views/splash_screen.dart/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = "/";
  static const String howItWorkScreen = "/howitwork_screen";
  static const String roleSelectionScreen = "/role_selection_screen";
  static const String welcomeJetpickerScreen = "/welcome_jetpicker_screen";
  static const String welcomeJetordererScreen = "/welcome_jetorderer_screen";
  static const String signUpScreen = "/signup_screen";
  static const String ordererSignupScreen = "/orderer_signup_screen";
  static const String loginScreen = "/login_screen";
  static const String ordererLoginScreen = "/orderer_login_screen";
  static const String profileSetupScreen = "/profile_setup_screen";
  static const String ordererProfileSetupScreen = "/orderer_profilesetup_screen";
  static const String travelDetailSetupScreen = "/travel_detail_setup_screen";
  static const String pickerBottomBarScreen = "/picker_bottom_bar_screen";
  static const String ordererBottomBarScreen = "/orderer_bottom_bar_screen";
  static const String orderDetailScreen = "/order_detail_screen";
  static const String counterOfferScreen = "/counter_offer_screen";
  static const String conversationScreen = "/conversation_screen";
  static const String acceptOrderDetailScreen = "/accept_orderdetail_screen";
  static const String personalDetailScreen = "/personal_detail_screen";
  static const String travelDetailScreen = "/travel_detail_screen";
  static const String settingScreen = "/setting_screen";
  static const String paymentMethodScreen = "/payment_method_screen";
  static const String bankDetailScreen = "/bank_detail_screen";
  static const String oPersonalDetailScreen = "/opersonal_detail_screen";
  static const String oPaymentMethodScreen = "/opayment_method_screen";
  static const String oSettingScreen = "/osetting_screen";
  static const String extraCardScreen = "/extra_card_screen";
  static const String ordererConversationScreen = "/orderer_conversation_screen";
  static const String orderHistoryDetailScreen = "/order_history_detail_screen";
  static const String deliveryFlowScreen = "/delivery_flow_screen";
  static const String orderAcceptedScreen = "/order_accepted_screen";
  static const String offerReceivedScreen = "/offer_received_screen";
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.signUpScreen,
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('No route defined for ${state.uri}')),
  ),
  routes: [
    GoRoute(
      path: AppRoutes.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.howItWorkScreen,
      builder: (context, state) => HowitworkScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelectionScreen,
      builder: (context, state) => RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcomeJetpickerScreen,
      builder: (context, state) => WelcomeJetpickerScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcomeJetordererScreen,
      builder: (context, state) => WelcomeJetordererScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUpScreen,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.ordererSignupScreen,
      builder: (context, state) => OrdererSignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.loginScreen,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.ordererLoginScreen,
      builder: (context, state) => OrdererLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.profileSetupScreen,
      builder: (context, state) => ProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.travelDetailSetupScreen,
      builder: (context, state) => TravelDetailSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.ordererProfileSetupScreen,
      builder: (context, state) => OrdererProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.pickerBottomBarScreen,
      builder: (context, state) => PickerBottomBarScreen(),
    ),
    GoRoute(
      path: AppRoutes.ordererBottomBarScreen,
      builder: (context, state) => OrdererBottomBarScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderDetailScreen,
      builder: (context, state) => OrderDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.counterOfferScreen,
      builder: (context, state) => CounterOfferScreen(),
    ),
    GoRoute(
      path: AppRoutes.conversationScreen,
      builder: (context, state) => ConversationScreen(),
    ),
    GoRoute(
      path: AppRoutes.acceptOrderDetailScreen,
      builder: (context, state) => AcceptOrderdetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.personalDetailScreen,
      builder: (context, state) => PersonalDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.travelDetailScreen,
      builder: (context, state) => TravelDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.settingScreen,
      builder: (context, state) => SettingScreen(),
    ),
    GoRoute(
      path: AppRoutes.paymentMethodScreen,
      builder: (context, state) => PaymentMethodScreen(),
    ),
    GoRoute(
      path: AppRoutes.bankDetailScreen,
      builder: (context, state) => BankDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.oPersonalDetailScreen,
      builder: (context, state) => OpersonalDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.oPaymentMethodScreen,
      builder: (context, state) => OpaymentMethodScreen(),
    ),
    GoRoute(
      path: AppRoutes.oSettingScreen,
      builder: (context, state) => OsettingScreen(),
    ),
    GoRoute(
      path: AppRoutes.extraCardScreen,
      builder: (context, state) => ExtraCardScreen(),
    ),
    GoRoute(
      path: AppRoutes.ordererConversationScreen,
      builder: (context, state) => OrdererConversationScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderHistoryDetailScreen,
      builder: (context, state) => OrderHistorydetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.deliveryFlowScreen,
      builder: (context, state) => DeliveryFlowScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderAcceptedScreen,
      builder: (context, state) => OrderAcceptedScreen(),
    ),
    GoRoute(
      path: AppRoutes.offerReceivedScreen,
      builder: (context, state) => OfferReceivedScreen(),
    ),
  ],
);
