import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class OrderDetailCard extends StatelessWidget {
  final String imagePath;
  final String titleText;
  final String? subTitleText;
  final String trailingText;
  final Color? containerColor;
  final Color? titleTextColor;
  final Color? subTitleTextColor;
  final Color? trailingTextColor;

  const OrderDetailCard({
    super.key,
    required this.imagePath,
    required this.titleText,
    this.subTitleText,
    required this.trailingText,
    this.containerColor,
    this.titleTextColor,
    this.subTitleTextColor,
    this.trailingTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: containerColor ?? AppColors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Center(
              child: SharePictures(
                imagePath: imagePath,
                width: 50.w,
                height: 50.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          12.w.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleText,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: titleTextColor ?? AppColors.white,
                    fontWeight: TextWeight.bold,
                  ),
                ),

                3.h.ph,

                Text(
                  subTitleText ?? AppStrings.storeLink,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: subTitleTextColor ?? AppColors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: subTitleTextColor ?? AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailingText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: trailingTextColor ?? AppColors.white,
              fontWeight: TextWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
