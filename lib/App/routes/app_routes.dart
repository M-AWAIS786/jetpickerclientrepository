import 'package:flutter/material.dart';
import '../views/splash_screen.dart/splash_screen.dart';


class AppRoutes {
  static const String splashScreen = "/";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSetting) {
    switch (routeSetting.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
  
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("No route defined"))),
        );
    }
  }
}