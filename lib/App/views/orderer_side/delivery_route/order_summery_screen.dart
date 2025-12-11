import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_fontweight.dart';
import '../../../utils/share_pictures.dart';
import '../../../widgets/radio_text.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({super.key});

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.orderSummary,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            30.h.ph,
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      _detailText(AppStrings.route, textColor: AppColors.black),
                      _detailText(
                        AppStrings.itemList,
                        textColor: AppColors.black,
                      ),
                      _detailText(AppStrings.store, textColor: AppColors.black),
                      _detailText(
                        AppStrings.weight,
                        textColor: AppColors.black,
                      ),
                      _detailText(AppStrings.price, textColor: AppColors.black),
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
                      _detailText('from London - Spain'),
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
            30.h.ph,
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
                child: SharePictures(imagePath: AppImages.watchImage),
              ),
            ),
            71.h.ph,

            Align(
              alignment: Alignment.centerLeft,
              child: RadioText(
                text: AppStrings.iAgreetoTermConditions,
                isSelected: false,
                fontSize: 14.sp,
                fontWeight: TextWeight.regular,
                iAgree: true,
                checkContainerColor: AppColors.labelGray,
                textColor: AppColors.labelGray,
                checkColor: AppColors.white,
                onChanged: () {},
              ),
            ),
            8.h.ph,
            Align(
              alignment: Alignment.centerLeft,
              child: RadioText(
                text: AppStrings.iAgreetoCustomLaws,
                isSelected: true,
                fontSize: 14.sp,
                fontWeight: TextWeight.regular,
                iAgree: true,
                checkContainerColor: AppColors.labelGray,
                textColor: AppColors.labelGray,
                checkColor: AppColors.white,
                onChanged: () {},
              ),
            ),
          ],
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
