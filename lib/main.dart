import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jet_picks_app/App/constants/app_textstyle.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jet Picks',
          theme: ThemeData(
            useMaterial3: true,
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: GoogleFonts.interTextTheme(
              AppResponsiveTypography.textTheme,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: AppRoutes.splashScreen,
        );
      },
    );
  }
}
