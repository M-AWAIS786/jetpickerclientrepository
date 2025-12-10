import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/profile_setup_data.dart';
import '../../routes/app_routes.dart';
import '../../utils/profile_appbar.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_formfeild.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.payoutMethods,
        titleColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.ph,
            Text(
              AppStrings.selectPayoutMethod,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppColors.red3),
            ),
            16.h.ph,
            RadioText(
              text: AppStrings.bankAccount,
              isSelected: true,
              fontSize: 14.sp,
              textColor: AppColors.red1,
              selectedColor: AppColors.red3,
              onChanged: () {},
            ),
            12.h.ph,
            RadioText(
              text: AppStrings.paypal,
              isSelected: false,
              fontSize: 14.sp,
              textColor: AppColors.red1,
              onChanged: () {},
            ),

            25.h.ph,
            Text(
              AppStrings.enterPaypalEmail,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.red1),
            ),
            10.h.ph,
            CustomTextFormfeild(hintText: 'Enter Email'),
            12.h.ph,
            Text(
              AppStrings.paypalPaymentInfo,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.labelGray),
            ),
            25.h.ph,
            RadioText(
              text: AppStrings.mobileWallet,
              isSelected: false,
              fontSize: 14.sp,
              textColor: AppColors.red1,
              onChanged: () {},
            ),
            25.h.ph,
            CustomDropDown(
              selectedValue: selectedCountry,
              hintText: 'wallet',
              hintTextColor: AppColors.labelGray,
              labelText: AppStrings.walletType,
              items: countryList,
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            CustomDivider(),
            25.h.ph,
            Text(
              AppStrings.registeredMobileNumber,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.red1),
            ),
            10.h.ph,
            CustomTextFormfeild(
              hintText: AppStrings.registeredMobileNumberHint,
            ),
            100.h.ph,
            CustomButton(
              text: AppStrings.save,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.bankDetailScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
