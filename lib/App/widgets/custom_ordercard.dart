import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class CustomOrderCard extends StatelessWidget {
  const CustomOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 10.h, bottom: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: AppColors.lightGray,
                        child: Center(child: Text('A')),
                      ),
                      8.w.pw,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sarah M.',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.black),
                          ),

                          Row(
                            children: [
                              Text(
                                '4.8',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(color: AppColors.black),
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
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildProductStrip(context),

                16.w.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Total Items 8',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      10.h.ph,
                      Text(
                        'Reward: \$20',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.red3,
                          fontWeight: TextWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.h.ph,
          CustomButton(
            text: AppStrings.viewOrderDetails,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.orderDetailScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductStrip(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.all(5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProductImage(assetPath: AppImages.passwordIcon),
          _ProductImage(assetPath: AppImages.calendarIcon),
          _ProductImage(assetPath: AppImages.calendarIcon),

          _buildPlusItemsBadge(3, context),
        ],
      ),
    );
  }

  Widget _buildPlusItemsBadge(int count, BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          '+ $count Items',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.red3),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String assetPath;

  const _ProductImage({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(child: SharePictures(imagePath: assetPath)),
    );
  }
}
