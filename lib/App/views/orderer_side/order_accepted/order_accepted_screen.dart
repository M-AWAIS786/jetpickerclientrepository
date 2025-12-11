import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/your_order_card.dart';

import '../../../constants/app_fontweight.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/text_title.dart';

class OrderAcceptedScreen extends StatefulWidget {
  const OrderAcceptedScreen({super.key});

  @override
  State<OrderAcceptedScreen> createState() => _OrderAcceptedScreenState();
}

class _OrderAcceptedScreenState extends State<OrderAcceptedScreen> {
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
            SharePictures(imagePath: AppImages.orderboxIcon),
            10.h.ph,
            Text(
              AppStrings.yourOrderAccepted,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            28.h.ph,
            YourOrderCard(),
            58.h.ph,
            textTile(
              AppStrings.freeBreakdown,
              '',
              size: 16.sp,
              fontweight: TextWeight.medium,
            ),
            20.h.ph,
            textTile(AppStrings.reward, '\$20'),
            textTile(AppStrings.itemCost, '\$50'),
            textTile(AppStrings.jetPicksFee, '\$5'),

            14.h.ph,
            CustomDivider(dividerThickness: 1, dividerColor: AppColors.black),
            10.h.ph,
            textTile(
              AppStrings.total,
              '\$75',
              size: 16.sp,
              fontweight: TextWeight.medium,
            ),
            32.h.ph,
            CustomButton(
              text: AppStrings.continueWithJetPicker,
              textColor: AppColors.black,
              color: AppColors.white,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.offerReceivedScreen);
              },
            ),
            18.h.ph,
            CustomButton(
              text: AppStrings.startChat,
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
