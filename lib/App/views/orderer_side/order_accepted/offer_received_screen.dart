import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/your_order_card.dart';
import '../../../constants/app_fontweight.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/text_title.dart';

class OfferReceivedScreen extends StatefulWidget {
  const OfferReceivedScreen({super.key});

  @override
  State<OfferReceivedScreen> createState() => _OfferReceivedScreenState();
}

class _OfferReceivedScreenState extends State<OfferReceivedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow3,
      appBar: ProfileAppBar(
        appBarColor: AppColors.yellow3,
        leadingIcon: true,
        backBtnColor: AppColors.white,
        backIconColor: AppColors.black,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.h.ph,
            Text(
              AppStrings.counterOfferReceived,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            28.h.ph,
            YourOrderCard(counterOffer: true),
            58.h.ph,
            textTile(
              AppStrings.freeBreakdown,
              '',
              size: 16.sp,
              fontweight: TextWeight.medium,
            ),
            20.h.ph,
            textTile(AppStrings.deliveryFee, '\$30'),
            textTile(AppStrings.itemCost, '\$50'),
            textTile(AppStrings.jetPicksFee, '\$5'),

            14.h.ph,
            CustomDivider(dividerThickness: 1, dividerColor: AppColors.black),
            10.h.ph,
            textTile(
              AppStrings.total,
              '\$85',
              size: 16.sp,
              fontweight: TextWeight.medium,
            ),
            32.h.ph,
            CustomButton(
              text: AppStrings.acceptOfferbtn,
              textColor: AppColors.black,
              color: AppColors.white,
              onPressed: () {},
            ),
            18.h.ph,
            CustomButton(
              text: AppStrings.declinebtn,
              textColor: AppColors.black,
              borderColor: AppColors.black,
              color: AppColors.yellow3,
              onPressed: () {},
            ),
          ],
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
      trailingText: trailing,
    );
  }
}
