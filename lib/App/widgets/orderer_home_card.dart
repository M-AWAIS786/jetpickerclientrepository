import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class OrdererHomeCard extends StatelessWidget {
  const OrdererHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              top: 16.h,
              // bottom: 20.h,
              right: 10.w,
            ),
            child: Row(
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppColors.black),
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 17.h),
            child: Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(color: AppColors.yellow1),
              child: Center(
                child: Text(
                  'From London - Madrid \n 25 Nov',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Available space: 10kg    Fee: \$10/kg',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          10.h.ph,
          CustomButton(
            text: 'View Details',
            color: AppColors.yellow3,
            textColor: AppColors.black,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
