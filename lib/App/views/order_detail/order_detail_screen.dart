import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';

import '../../constants/app_images.dart';
import '../../widgets/order_detail_card.dart';
import '../../widgets/text_title.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red3,
      appBar: ProfileAppBar(
        leadingIcon: true,
        backIconColor: AppColors.black,
        backBtnColor: AppColors.white,
        title: AppStrings.orderDetails,
        titleColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.h.ph,
              OrderDetailCard(
                imagePath: AppImages.calendarIcon,
                titleText: 'Apple Mouse',
                trailingText: '\$120',
              ),
              OrderDetailCard(
                imagePath: AppImages.calendarIcon,
                titleText: 'Apple Headphone',
                trailingText: '\$120',
              ),
              OrderDetailCard(
                imagePath: AppImages.calendarIcon,
                titleText: 'Apple Watch',
                trailingText: '\$120',
              ),
              40.h.ph,
              CustomDivider(dividerThickness: 1, dividerColor: AppColors.white),
              12.h.ph,
              textTile(
                AppStrings.freeBreakdown,
                '\$360',
                size: 16.sp,
                fontweight: TextWeight.medium,
              ),
              20.h.ph,
              textTile(AppStrings.itemCost, '\$360'),
              textTile(AppStrings.reward, '\$20'),
              textTile(AppStrings.jetPicksFee, '\$5'),

              14.h.ph,
              CustomDivider(dividerThickness: 1, dividerColor: AppColors.white),
              10.h.ph,
              textTile(
                AppStrings.total,
                '\$385',
                size: 16.sp,
                fontweight: TextWeight.medium,
              ),

              40.h.ph,
              Text(
                AppStrings.estimatedDeliveryDate,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.white,
                  fontSize: 16.sp,
                  fontWeight: TextWeight.medium,
                ),
              ),
              20.h.ph,
              textTile('13 Dec', AppStrings.basedonArrivialDate),

              60.h.ph,
              RadioText(
                text: AppStrings.iAgreetoTermConditions,
                isSelected: false,
                textColor: AppColors.white,
                fontSize: 14.sp,
                fontWeight: TextWeight.regular,
                iAgree: true,
                onChanged: () {},
              ),
              8.h.ph,
              RadioText(
                text: AppStrings.iAgreetoCustomLaws,
                isSelected: true,
                textColor: AppColors.white,
                fontSize: 14.sp,
                fontWeight: TextWeight.regular,
                iAgree: true,
                onChanged: () {},
              ),
              60.h.ph,
              CustomButton(
                text: AppStrings.acceptDelivery,
                color: AppColors.red1,
                onPressed: () {},
              ),
              16.h.ph,
              CustomButton(
                text: AppStrings.sendCounterOffer,
                borderColor: AppColors.red1,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.counterOfferScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textTile(
    String title,
    String trailing, {
    double? size,
    FontWeight? fontweight,
  }) {
    return TextTile(
      titleText: title,
      fontSize: size,
      fontWeight: fontweight,
      titleTextColor: AppColors.white,
      trailingText: trailing,
      trailingTextColor: AppColors.white,
    );
  }
}
