import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../constants/app_colors.dart';

import '../constants/app_strings.dart';


class OrderNowContainer extends StatelessWidget {
  const OrderNowContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 153.w,
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 153.w,
            height: 148.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
            ),
            child: Icon(
              Icons.image_not_supported,
              size: 40.sp,
              color: Colors.grey.shade600,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 7.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  'Electric Massager',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.labelGray),
                ),
                Text('\$30', style: Theme.of(context).textTheme.labelMedium),
                SizedBox(
                  width: 93.w,
                  height: 28.h,
                  child: CustomButton(
                    text: AppStrings.orderNow,
                    textColor: AppColors.black,
                    color: AppColors.yellow3,
                    radius: 20.r,
                    fontSize: 14.sp,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
