import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
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
    super.initState();
    _bootstrapSession();
  }

  Future<void> _bootstrapSession() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final token = await UserPreferences.getToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      goRouter.go(AppRoutes.howItWorkScreen);
      return;
    }

    var activeRole = await UserPreferences.getActiveRole();
    if (activeRole == null || activeRole.isEmpty) {
      final roles = await UserPreferences.getUserRoles();
      if (roles.isNotEmpty) {
        activeRole = roles.contains('ORDERER') ? 'ORDERER' : roles.first;
        await UserPreferences.saveActiveRole(activeRole);
      }
    }

    if (!mounted) return;

    if (activeRole == 'ORDERER') {
      goRouter.go(AppRoutes.ordererBottomBarScreen);
    } else {
      goRouter.go(AppRoutes.pickerBottomBarScreen);
    }
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
