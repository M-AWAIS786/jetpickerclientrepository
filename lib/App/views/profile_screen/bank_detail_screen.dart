import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../data/profile_setup_data.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_formfeild.dart';

class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({super.key});

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  String? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        title: AppStrings.bankDetails,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            25.h.ph,
            CustomDropDown(
              selectedValue: selectedCountry,
              hintText: AppStrings.bankName,
              hintTextColor: AppColors.labelGray,
              labelText: AppStrings.bankName,
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
              AppStrings.accountHolderName,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.red1),
            ),
            10.h.ph,
            CustomTextFormfeild(hintText: AppStrings.userNameHint),
            25.h.ph,
            Text(
              AppStrings.accountNumber,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.red1),
            ),
            10.h.ph,
            CustomTextFormfeild(hintText: '----/----/----/-----'),
            25.h.ph,
            Text(
              AppStrings.branchCode,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.red1),
            ),
            10.h.ph,
            CustomTextFormfeild(hintText: '-----'),
            150.h.ph,
            CustomButton(text: AppStrings.save, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
