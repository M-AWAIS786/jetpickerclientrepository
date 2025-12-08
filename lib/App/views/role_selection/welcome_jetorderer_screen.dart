import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';

class WelcomeJetordererScreen extends StatelessWidget {
  const WelcomeJetordererScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow3,
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              AppStrings.welcomeJetOrderer,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            24.h.ph,
            Text(
              textAlign: TextAlign.center,
              AppStrings.orderAnythingGlobally,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 19.sp),
            ),
            100.h.ph,
            CustomButton(
              text: AppStrings.createAccount,
              color: AppColors.white,
              textColor: AppColors.black,
              onPressed: () {
                 Navigator.pushNamed(context, AppRoutes.ordererSignupScreen);
              },
            ),
            18.h.ph,
            CustomButton(
              text: AppStrings.switchToJetPicker,
              color: AppColors.yellow3,
              borderColor: AppColors.black,
              textColor: AppColors.black,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
