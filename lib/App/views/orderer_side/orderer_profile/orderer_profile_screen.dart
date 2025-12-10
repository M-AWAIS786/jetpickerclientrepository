import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/profile_appbar.dart';
import '../../../utils/share_pictures.dart';
import '../../../widgets/listtile_arrow.dart';

class OrdererProfileScreen extends StatelessWidget {
  const OrdererProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.profile,
        appBarColor: AppColors.yellow3,
        titleColor: AppColors.black,
        bellColor: AppColors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.h.ph,
          profileImage(),
          12.h.ph,
          Text(
            AppStrings.userNameHint,
            style: Theme.of(context).textTheme.titleMedium,
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
            containerColor: AppColors.yellow1,
            textColor: AppColors.black,
            prefixIconColor: AppColors.black,
            sufixIconColor: AppColors.black,
            text: AppStrings.personalInformation,
            prefixIcon: AppImages.profileIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.oPersonalDetailScreen);
            },
          ),
          12.h.ph,
          ListTileArrow(
            containerColor: AppColors.yellow1,
            textColor: AppColors.black,
            prefixIconColor: AppColors.black,
            sufixIconColor: AppColors.black,
            text: AppStrings.paymentMethods,
            prefixIcon: AppImages.paymentcardsIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.oPaymentMethodScreen);
            },
          ),

          12.h.ph,
          ListTileArrow(
            containerColor: AppColors.yellow1,
            textColor: AppColors.black,
            prefixIconColor: AppColors.black,
            sufixIconColor: AppColors.black,
            text: AppStrings.settings,
            prefixIcon: AppImages.settingIcon,
            sufixIcon: AppImages.rightArrowIcon,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.oSettingScreen);
            },
          ),

          12.h.ph,
          ListTileArrow(
            containerColor: AppColors.white,
            textColor: AppColors.black,
            prefixIconColor: AppColors.black,
            text: AppStrings.helpAndSupport,
            prefixIcon: AppImages.helpIcon,
            onTap: () {},
          ),

          ListTileArrow(
            containerColor: AppColors.white,
            textColor: AppColors.black,
            prefixIconColor: AppColors.black,
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
            border: Border.all(width: 1.w, color: AppColors.yellow3),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
              border: Border.all(width: 1.w, color: AppColors.yellow3),
            ),
            child: Transform.scale(
              scale: 0.6,
              child: SharePictures(
                imagePath: AppImages.cameraIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.yellow3,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
