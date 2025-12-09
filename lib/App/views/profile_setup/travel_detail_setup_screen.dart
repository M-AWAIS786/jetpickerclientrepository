import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';

import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/profile_setup_data.dart';
import '../../utils/profile_appbar.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/radio_text.dart';

class TravelDetailSetupScreen extends StatefulWidget {
  const TravelDetailSetupScreen({super.key});

  @override
  State<TravelDetailSetupScreen> createState() =>
      _TravelDetailSetupScreenState();
}

class _TravelDetailSetupScreenState extends State<TravelDetailSetupScreen> {
  String? selectedCountry;
  String? selectedcity;
  String? selectLuggageWeight;
  bool useMyLocation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        leadingIcon: true,
        appBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.travelAvailabilitySetup,
        alignment: Alignment.bottomCenter,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                AppStrings.shareYourTravelDetail,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.red1),
              ),
              58.h.ph,
              CustomDropDown(
                selectedValue: selectedCountry,
                hintText: AppStrings.country,
                labelText: AppStrings.departureCountryandCity,
                prefixIcon: AppImages.locationLineIcon,
                items: countryList,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              CustomDivider(indent: 20, dividerColor: AppColors.red1),
              10.h.ph,
              CustomDropDown(
                selectedValue: selectedcity,
                hintText: AppStrings.city,
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
                labelText: AppStrings.arrivalCountryandCity,
                prefixIcon: AppImages.locationLineIcon,
                items: countryList,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              CustomDivider(indent: 20, dividerColor: AppColors.red1),
              10.h.ph,
              CustomDropDown(
                selectedValue: selectedcity,
                hintText: AppStrings.city,
                items: cityList,
                onChanged: (value) {
                  setState(() {
                    selectedcity = value;
                  });
                },
              ),
              40.h.ph,
              CustomDivider(dividerThickness: 1),
              40.h.ph,
              RadioText(
                text: 'Use my location',
                isSelected: useMyLocation,
                onChanged: () {
                  setState(() {
                    useMyLocation = !useMyLocation;
                  });
                },
              ),
              30.h.ph,
              CustomDropDown(
                selectedValue: selectLuggageWeight,
                hintText: AppStrings.selectDate,
                labelText: AppStrings.arrivalDate,
                prefixIcon: AppImages.calendarIcon,
                items: weightList,
                onChanged: (value) {
                  setState(() {
                    selectLuggageWeight = value;
                  });
                },
              ),
              25.h.ph,
              CustomDivider(dividerThickness: 1),
              32.h.ph,
              CustomDropDown(
                selectedValue: selectLuggageWeight,
                hintText: AppStrings.selectWeight,
                labelText: AppStrings.luggage,
                prefixIcon: AppImages.lagageIcon,
                items: weightList,
                onChanged: (value) {
                  setState(() {
                    selectLuggageWeight = value;
                  });
                },
              ),
              25.h.ph,
              CustomDivider(dividerThickness: 1),
              40.h.ph,
              CustomButton(
                text: AppStrings.saveAndContinue,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.pickerBottomBarScreen);
                },
              ),

              CustomButton(
                text: AppStrings.skipForNow,
                textColor: AppColors.red3,
                color: AppColors.white,
                fontSize: 14.sp,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
