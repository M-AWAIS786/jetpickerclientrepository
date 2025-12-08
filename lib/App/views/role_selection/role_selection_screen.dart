import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(child: Container(color: AppColors.red3)),
                Expanded(child: Container(color: AppColors.yellow1)),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ).copyWith(top: 50.h),
              child: Column(
                children: [
                  SharePictures(
                    imagePath: AppImages.jetPicksLogo2,
                    width: 74.w,
                    height: 73.h,
                    fit: BoxFit.cover,
                  ),
                  60.h.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            AppStrings.roleTitle1,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: AppColors.yellow3),
                          ),
                          8.h.ph,
                          Text(
                            textAlign: TextAlign.center,
                            AppStrings.roleSubtitle1,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.white, height: 1.2),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            AppStrings.roleTitle2,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: AppColors.red3),
                          ),
                          8.h.ph,
                          Text(
                            textAlign: TextAlign.center,
                            AppStrings.roleSubtitle2,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.red1, height: 1.2),
                          ),
                        ],
                      ),
                    ],
                  ),
                  40.h.ph,

                  SizedBox(
                    height: 270.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 15,
                          bottom: 0,
                          child: SharePictures(
                            imagePath: AppImages.jetPicker,
                            width: 200.w,
                            height: 268.h,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 0,
                          child: SharePictures(
                            imagePath: AppImages.jetOrderer,
                            width: 146.w,
                            height: 270.h,
                          ),
                        ),
                      ],
                    ),
                  ),

                  80.h.ph,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 210,
                      child: CustomButton(
                        text: AppStrings.continueAsJetPicker,
                        color: AppColors.yellow3,
                        textColor: AppColors.black,
                        fontSize: 14.sp,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.welcomeJetpickerScreen,
                          );
                        },
                      ),
                    ),
                  ),
                  12.h.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 210,
                      child: CustomButton(
                        text: AppStrings.continueAsJetOrderer,
                        color: AppColors.yellow3,
                        textColor: AppColors.black,
                        fontSize: 14.sp,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.welcomeJetordererScreen,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
