import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../../constants/app_strings.dart';

class WelcomeJetpickerScreen extends StatelessWidget {
  const WelcomeJetpickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red3,
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              AppStrings.welcomeJetPicker,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(color: AppColors.white),
            ),
            24.h.ph,
            Text(
              textAlign: TextAlign.center,
              AppStrings.makeMoneyWhileTravelling,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontSize: 19.sp,
              ),
            ),
            100.h.ph,
            CustomButton(
              text: AppStrings.createAccount,
              color: AppColors.red1,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signUpScreen);
              },
            ),
            18.h.ph,
            CustomButton(
              text: AppStrings.switchToJetOrderer,
              borderColor: AppColors.white,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
