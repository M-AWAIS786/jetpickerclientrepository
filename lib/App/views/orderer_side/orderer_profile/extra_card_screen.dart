import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../data/profile_setup_data.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_formfeild.dart';

class ExtraCardScreen extends StatefulWidget {
  const ExtraCardScreen({super.key});

  @override
  State<ExtraCardScreen> createState() => _ExtraCardScreenState();
}

class _ExtraCardScreenState extends State<ExtraCardScreen> {
  String? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
        title: AppStrings.extraCard,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.h.ph,
              Text(
                AppStrings.nameOnCard,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: AppStrings.userNameHint),
              25.h.ph,
              Text(
                AppStrings.cardNumber,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: '----/----/----/-----'),
              25.h.ph,
              CustomDropDown(
                selectedValue: selectedCountry,
                hintText: 'Select card type',
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                labelTextColor: AppColors.black,
                sufixColor: AppColors.black,
                labelText: AppStrings.cardType,
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
                AppStrings.expiryDate,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: 'MM/YY'),
              25.h.ph,
              Text(
                AppStrings.cvv,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: '------'),
              25.h.ph,
              Text(
                AppStrings.billingAddress,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: 'Enter address'),
              81.h.ph,
              CustomButton(
                text: AppStrings.saveCard,
                color: AppColors.yellow3,
                textColor: AppColors.black,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
