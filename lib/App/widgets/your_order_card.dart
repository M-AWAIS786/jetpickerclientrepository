import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class YourOrderCard extends StatelessWidget {
  final bool counterOffer;
  const YourOrderCard({super.key, this.counterOffer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 7.7,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
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
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.black,
                        ),
                      ),

                      Icon(Icons.star, color: AppColors.starColor, size: 15.sp),
                    ],
                  ),
                ],
              ),
            ],
          ),
          20.h.ph,
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(color: AppColors.yellow1),
            child: Center(
              child: Text(
                'From London - Madrid \n 25 Nov- 27 Nov',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          17.h.ph,
          if (counterOffer)
            Align(
              alignment: Alignment.center,
              child: Text(
                'Counter offer: \$30',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
        ],
      ),
    );
  }
}
