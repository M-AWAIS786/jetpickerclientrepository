import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/order_now_container.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_fontweight.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/profile_appbar.dart';
import '../../../utils/share_pictures.dart';

import '../../../widgets/custom_searchbar.dart';
import '../../../widgets/orderer_home_card.dart';

class OrdererHomeScreen extends StatelessWidget {
  const OrdererHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProfileAppBar(
            statusBarIconBrightness: Brightness.dark,
            title: AppStrings.fromLondonToMadrid,
            fontSize: 14.sp,
            fontWeight: TextWeight.medium,
            titleColor: AppColors.black,
            appBarColor: AppColors.yellow3,
            bellColor: AppColors.black,
            imagePath: AppImages.profileIcon,
            bottomHeight: 30.h,
          ),
          Transform.translate(
            offset: Offset(0.0, -20.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomSearchBar(
                prefixColor: AppColors.labelGray,
                sufixColor: AppColors.labelGray,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: SharePictures(
                        imagePath: AppImages.jetOrdererHomeImage,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.availableJetPickersNearYou,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: 70.w,
                          height: 35.h,
                          child: CustomButton(
                            text: AppStrings.seeAll,
                            textColor: AppColors.black,
                            color: AppColors.yellow3,
                            radius: 20.r,
                            fontSize: 14.sp,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 450.h,
                      child: Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 25.h),
                              child: OrdererHomeCard(),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.topSellingGoods,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: 70.w,
                          height: 35.h,
                          child: CustomButton(
                            text: AppStrings.seeAll,
                            textColor: AppColors.black,
                            color: AppColors.yellow3,
                            radius: 20.r,
                            fontSize: 14.sp,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    8.h.ph,
                    SizedBox(
                      height: 250.h,
                      child: Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return OrderNowContainer();
                          },
                        ),
                      ),
                    ),
                    30.h.ph,
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
