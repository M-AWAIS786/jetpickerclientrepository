import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_images.dart';
import '../../../utils/share_pictures.dart';
import '../../../widgets/listtile_arrow.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.profile,
        titleColor: AppColors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.h.ph,
          profileImage(),
          12.h.ph,
          Text(
            AppStrings.userNameHint,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.red3),
          ),
          3.h.ph,
          Text(
            AppStrings.phoneNumberHint,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.labelGray),
          ),
          48.h.ph,
          ListTileArrow(
            text: AppStrings.personalInformation,
            prefixIcon: AppImages.profileIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              goRouter.push(AppRoutes.personalDetailScreen);
            },
          ),
          12.h.ph,
          ListTileArrow(
            text: AppStrings.travelDetails,
            prefixIcon: AppImages.travelDetailIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              goRouter.push(AppRoutes.travelDetailScreen);
            },
          ),
          12.h.ph,
          ListTileArrow(
            text: AppStrings.settings,
            prefixIcon: AppImages.settingIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              goRouter.push( AppRoutes.settingScreen);
            },
          ),
          12.h.ph,
          ListTileArrow(
            text: AppStrings.paymentMethods,
            prefixIcon: AppImages.paymentcardsIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              goRouter.push( AppRoutes.paymentMethodScreen);
            },
          ),
          12.h.ph,
          ListTileArrow(
            containerColor: AppColors.white,
            text: AppStrings.helpAndSupport,
            prefixIcon: AppImages.helpIcon,
            onTap: () {},
          ),

          ListTileArrow(
            containerColor: AppColors.white,
            text: AppStrings.logout,
            prefixIcon: AppImages.logoutIcon,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget profileImage() {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            shape: BoxShape.circle,
            border: Border.all(width: 1.w, color: AppColors.red3),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.redLight,
              shape: BoxShape.circle,
              border: Border.all(width: 1.w, color: AppColors.red3),
            ),
            child: Transform.scale(
              scale: 0.6,
              child: SharePictures(imagePath: AppImages.cameraIcon),
            ),
          ),
        ),
      ],
    );
  }
}
