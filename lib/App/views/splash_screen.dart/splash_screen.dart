import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      goRouter.go(AppRoutes.howItWorkScreen);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow2,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 45.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SharePictures(imagePath: AppImages.jetPicksLogo1),
            20.h.ph,
            Text(
              textAlign: TextAlign.center,
              AppStrings.splashSubtitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppColors.red3),
            ),
          ],
        ),
      ),
    );
  }
}
