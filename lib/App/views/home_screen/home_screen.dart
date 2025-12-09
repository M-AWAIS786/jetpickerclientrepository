import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_searchbar.dart';

import '../../widgets/custom_ordercard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProfileAppBar(
            title: AppStrings.fromLondonToMadrid,
            titleColor: AppColors.white,
            fontSize: 14.sp,
            fontWeight: TextWeight.medium,
            imagePath: AppImages.profileIcon,
            bottomHeight: 30.h,
          ),
          Transform.translate(
            offset: Offset(0.0, -20.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomSearchBar(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: SharePictures(imagePath: AppImages.jetPickerImage),
                    ),

                    CustomOrderCard(),
                    16.h.ph,
                    CustomOrderCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
