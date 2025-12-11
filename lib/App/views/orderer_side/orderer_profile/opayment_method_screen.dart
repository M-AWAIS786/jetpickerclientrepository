import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_fontweight.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/profile_appbar.dart';

class OpaymentMethodScreen extends StatefulWidget {
  const OpaymentMethodScreen({super.key});

  @override
  State<OpaymentMethodScreen> createState() => _OpaymentMethodScreenState();
}

class _OpaymentMethodScreenState extends State<OpaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.paymentMethods,
        appBarColor: AppColors.yellow3,
        titleColor: AppColors.black,
        bellColor: AppColors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            20.h.ph,
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.extraCardScreen);
              },
              child: Container(
                width: double.infinity,
                height: 81.h,
                decoration: BoxDecoration(
                  color: AppColors.yellow2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    AppStrings.addPaymentMethod,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: TextWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            60.h.ph,
            _paymentCard(
              AppStrings.masterCard,
              '**** **** 0783 7873',
              AppImages.mastercardImage,
            ),
            20.h.ph,
            CustomDivider(),
            20.h.ph,
            _paymentCard(
              AppStrings.paypal,
              '**** **** 0582 4672',
              AppImages.paypalImage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(String title, String subTitle, String trailing) {
    return ListTile(
      leading: SharePictures(imagePath: AppImages.paymentcardsIcon),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(
        subTitle,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.labelGray),
      ),
      trailing: SharePictures(imagePath: trailing, width: 32.w, height: 32.h),
    );
  }
}
