import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';

import '../../../utils/share_pictures.dart';

class OrderHistorydetailScreen extends StatefulWidget {
  const OrderHistorydetailScreen({super.key});

  @override
  State<OrderHistorydetailScreen> createState() =>
      _OrderHistorydetailScreenState();
}

class _OrderHistorydetailScreenState extends State<OrderHistorydetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'London - Spain',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              20.h.ph,
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        _detailText(
                          AppStrings.route,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.itemList,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.store,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.weight,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.price,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.reward,
                          textColor: AppColors.black,
                        ),
                      ],
                    ),
                    26.w.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        _detailText(AppStrings.fromLondonToMadrid),
                        _detailText(AppStrings.watch),
                        _detailText(AppStrings.egAmazone),
                        _detailText('1/4 kg'),
                        _detailText('\$50'),
                        _detailText('\$10'),
                      ],
                    ),
                  ],
                ),
              ),
              35.h.ph,
              Container(
                width: 153.w,
                height: 148.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: Offset(0, 0),
                      blurRadius: 14,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: SharePictures(imagePath: AppImages.cameraIcon),
                ),
              ),
              20.h.ph,
              Text(
                '${AppStrings.totalCost}: \$70',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              24.h.ph,
              Text('JetPicker', style: Theme.of(context).textTheme.titleMedium),
              11.h.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColors.lightGray,
                    child: Center(child: Text('M')),
                  ),
                  8.w.pw,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Methew M.',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),

                      Row(
                        children: [
                          Text(
                            '4.8',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),

                          Icon(
                            Icons.star,
                            color: AppColors.starColor,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              43.h.ph,
              Text(
                AppStrings.orderMarkedasDelivered.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              13.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: RadioText(
                  text: AppStrings.deliveryCompleted,
                  isSelected: true,
                  onChanged: () {},
                ),
              ),
              10.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: RadioText(
                  text: AppStrings.issueWithDelivery,
                  selectedColor: AppColors.red57,
                  isSelected: true,
                  onChanged: () {},
                ),
              ),
              18.h.ph,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${AppStrings.remainingTime} 47h : 12m',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              13.h.ph,
              Text(
                AppStrings.confirmOrder,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              37.h.ph,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.rateYourExperience,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: TextWeight.bold,
                      ),
                    ),
                    20.h.ph,
                    // SharePictures(
                    //   imagePath: AppImages.starsImage,
                    //   width: 500,
                    //   height: 50,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, size: 32, color: AppColors.starsColor),
                        Icon(Icons.star, size: 32, color: AppColors.starsColor),
                        Icon(Icons.star, size: 32, color: AppColors.starsColor),
                        Icon(Icons.star, size: 32, color: AppColors.starsColor),
                        Icon(Icons.star, size: 32, color: AppColors.starsColor),
                      ],
                    ),
                    20.h.ph,
                    Container(
                      width: double.infinity,
                      height: 92.h,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text('Write your comment'),
                    ),
                    12.h.ph,
                    Container(
                      width: double.infinity,
                      height: 92.h,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.tipOption,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          17.h.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RadioText(
                                text: '\$5',
                                fontSize: 12.sp,
                                isSelected: true,
                                onChanged: () {},
                              ),
                              RadioText(
                                text: '\$10',
                                fontSize: 12.sp,
                                isSelected: false,
                                onChanged: () {},
                              ),
                              RadioText(
                                text: 'Custom amount',
                                fontSize: 12.sp,
                                isSelected: false,
                                onChanged: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    20.h.ph,
                    CustomButton(
                      text: AppStrings.submit,
                      color: AppColors.yellow3,
                      textColor: AppColors.black,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderAcceptedScreen,
                        );
                      },
                    ),
                  ],
                ),
              ),

              30.h.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailText(String title, {Color? textColor}) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: textColor ?? AppColors.labelGray),
    );
  }
}
