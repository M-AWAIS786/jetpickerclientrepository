import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/views/auth/jetorderer_auth/orderer_login_screen.dart';
import 'package:jet_picks_app/App/views/auth/jetorderer_auth/orderer_signup_screen.dart';
import 'package:jet_picks_app/App/views/auth/jetpicker_auth/login_screen.dart';
import 'package:jet_picks_app/App/views/auth/jetpicker_auth/signup_screen.dart';
import 'package:jet_picks_app/App/views/bottom_bar/picker_bottom_bar_screen.dart';
import 'package:jet_picks_app/App/views/chat_screen/conversation_screen.dart';
import 'package:jet_picks_app/App/views/order_detail/counter_offer_screen.dart';
import 'package:jet_picks_app/App/views/order_screen/accept_orderdetail_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/bottom_bar/orderer_bottom_bar_screen.dart';
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
  static const String ordererProfileSetupScreen =
      "/orderer_profilesetup_screen";
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
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSetting) {
    switch (routeSetting.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case AppRoutes.howItWorkScreen:
        return MaterialPageRoute(builder: (_) => HowitworkScreen());

      case AppRoutes.roleSelectionScreen:
        return MaterialPageRoute(builder: (_) => RoleSelectionScreen());

      case AppRoutes.welcomeJetpickerScreen:
        return MaterialPageRoute(builder: (_) => WelcomeJetpickerScreen());

      case AppRoutes.welcomeJetordererScreen:
        return MaterialPageRoute(builder: (_) => WelcomeJetordererScreen());

      case AppRoutes.signUpScreen:
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case AppRoutes.ordererSignupScreen:
        return MaterialPageRoute(builder: (_) => OrdererSignupScreen());

      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case AppRoutes.ordererLoginScreen:
        return MaterialPageRoute(builder: (_) => OrdererLoginScreen());

      case AppRoutes.profileSetupScreen:
        return MaterialPageRoute(builder: (_) => ProfileSetupScreen());

      case AppRoutes.travelDetailSetupScreen:
        return MaterialPageRoute(builder: (_) => TravelDetailSetupScreen());

      case AppRoutes.ordererProfileSetupScreen:
        return MaterialPageRoute(builder: (_) => OrdererProfileSetupScreen());

      case AppRoutes.pickerBottomBarScreen:
        return MaterialPageRoute(builder: (_) => PickerBottomBarScreen());

      case AppRoutes.ordererBottomBarScreen:
        return MaterialPageRoute(builder: (_) => OrdererBottomBarScreen());

      case AppRoutes.orderDetailScreen:
        return MaterialPageRoute(builder: (_) => OrderDetailScreen());

      case AppRoutes.counterOfferScreen:
        return MaterialPageRoute(builder: (_) => CounterOfferScreen());

      case AppRoutes.conversationScreen:
        return MaterialPageRoute(builder: (_) => ConversationScreen());

      case AppRoutes.acceptOrderDetailScreen:
        return MaterialPageRoute(builder: (_) => AcceptOrderdetailScreen());

      case AppRoutes.personalDetailScreen:
        return MaterialPageRoute(builder: (_) => PersonalDetailScreen());

      case AppRoutes.travelDetailScreen:
        return MaterialPageRoute(builder: (_) => TravelDetailScreen());

      case AppRoutes.settingScreen:
        return MaterialPageRoute(builder: (_) => SettingScreen());

      case AppRoutes.paymentMethodScreen:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());

      case AppRoutes.bankDetailScreen:
        return MaterialPageRoute(builder: (_) => BankDetailScreen());

        case AppRoutes.oPersonalDetailScreen:
        return MaterialPageRoute(builder: (_) => OpersonalDetailScreen());

        case AppRoutes.oPaymentMethodScreen:
        return MaterialPageRoute(builder: (_) => OpaymentMethodScreen());

        case AppRoutes.oSettingScreen:
        return MaterialPageRoute(builder: (_) => OsettingScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("No route defined"))),
        );
    }
  }
}
