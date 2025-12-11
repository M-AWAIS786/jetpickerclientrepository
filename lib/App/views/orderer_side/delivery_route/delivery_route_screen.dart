import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';
import 'package:jet_picks_app/App/widgets/custom_text_formfeild.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/profile_setup_data.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/radio_text.dart';

class DeliveryRouteScreen extends StatefulWidget {
  const DeliveryRouteScreen({super.key});

  @override
  State<DeliveryRouteScreen> createState() => _DeliveryRouteScreenState();
}

class _DeliveryRouteScreenState extends State<DeliveryRouteScreen> {
  String? selectedCountry;
  String? selectedcity;
  bool useMyLocation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.deliveryRoute,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              35.h.ph,
              CustomDropDown(
                selectedValue: selectedCountry,
                hintText: AppStrings.country,
                labelText: AppStrings.chooseCountryAndCity,
                prefixIcon: AppImages.locationLineIcon,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                labelTextColor: AppColors.black,
                preficIconColor: AppColors.black,
                sufixColor: AppColors.black,
                items: countryList,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              CustomDivider(indent: 20),
              10.h.ph,
              CustomDropDown(
                selectedValue: selectedcity,
                hintText: AppStrings.city,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                sufixColor: AppColors.black,
                items: cityList,
                onChanged: (value) {
                  setState(() {
                    selectedcity = value;
                  });
                },
              ),
              32.h.ph,
              CustomDropDown(
                selectedValue: selectedCountry,
                hintText: AppStrings.country,
                labelText: AppStrings.chooseReceivingCountryAndCity,
                prefixIcon: AppImages.locationLineIcon,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                labelTextColor: AppColors.black,
                preficIconColor: AppColors.black,
                sufixColor: AppColors.black,
                items: countryList,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              CustomDivider(indent: 20),
              10.h.ph,
              CustomDropDown(
                selectedValue: selectedcity,
                hintText: AppStrings.city,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                sufixColor: AppColors.black,
                items: cityList,
                onChanged: (value) {
                  setState(() {
                    selectedcity = value;
                  });
                },
              ),
              40.h.ph,
              Align(
                alignment: Alignment.center,
                child: RadioText(
                  text: 'Use my location',
                  isSelected: useMyLocation,
                  onChanged: () {
                    setState(() {
                      useMyLocation = !useMyLocation;
                    });
                  },
                ),
              ),
              51.h.ph,
              Text(
                AppStrings.specialNotes,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              16.h.ph,
              CustomTextFormfeild(hintText: 'Write here'),
            ],
          ),
        ),
      ),
    );
  }
}
