import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import '../../routes/app_routes.dart';

class HowitworkScreen extends StatelessWidget {
  const HowitworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red3,
      appBar: AppBar(
        backgroundColor: AppColors.yellowA0,
        centerTitle: true,
        title: SharePictures(
          imagePath: AppImages.jetPicksLogo1,
          width: 84.w,
          height: 54.h,
          fit: BoxFit.cover,
        ),
      ),
      bottomNavigationBar:      SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: CustomButton(
                    text: AppStrings.continueText,
                    color: AppColors.yellow3,
                    textColor: AppColors.black,
                    onPressed: () {
                      goRouter.go(AppRoutes.roleSelectionScreen);
                      // Navigator.pushNamed(context, AppRoutes.roleSelectionScreen);
                    },
                  ),
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 188.h,
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Transform.scale(
                  scale: 0.35,
                  child: SharePictures(imagePath: AppImages.playButton),
                ),
              ),
              25.h.ph,
              questionAnswer(context, AppStrings.question1, AppStrings.answer1),
              questionAnswer(context, AppStrings.question2, AppStrings.answer2),
              questionAnswer(context, AppStrings.question3, AppStrings.answer3),
              questionAnswer(context, AppStrings.question4, AppStrings.answer4),
              questionAnswer(context, AppStrings.question5, AppStrings.answer5),
              questionAnswer(context, AppStrings.question6, AppStrings.answer6),
              20.h.ph,
         
            ],
          ),
        ),
      ),
    );
  }

  Widget questionAnswer(BuildContext context, String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.white),
        ),
        12.h.ph,
        Text(
          answer,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.white),
        ),
        25.h.ph,
      ],
    );
  }
}
