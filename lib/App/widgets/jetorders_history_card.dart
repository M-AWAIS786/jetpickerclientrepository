import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';

import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';

import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class JetOrdersHistoryCard extends StatelessWidget {
  const JetOrdersHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              top: 10.h,
              bottom: 18.h,
              right: 10,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'London - spain',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    5.h.ph,
                    Text(
                      '25 Nov - 27 Nov',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.labelGray,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green1C,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Delivered',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  width: 100.w,
                  height: 36.h,

                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(width: 3, color: AppColors.yellow1),
                  ),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      '3 Items',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                Text(
                  'Total Cost: \$70',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: TextWeight.bold),
                ),
              ],
            ),
          ),
          15.h.ph,
          CustomButton(
            text: AppStrings.viewOrderDetails,
            color: AppColors.yellow3,
            textColor: AppColors.black,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.orderHistoryDetailScreen);
            },
          ),
        ],
      ),
    );
  }
}
