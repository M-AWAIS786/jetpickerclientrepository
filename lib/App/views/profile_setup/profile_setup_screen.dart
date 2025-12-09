import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/profile_setup_data.dart';
import '../../utils/profile_appbar.dart';
import '../../widgets/custom_dropdown.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? selectedCountry;
  String? selectedlanguage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        leadingIcon: true,
        appBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.profileSetup,
        alignment: Alignment.bottomCenter,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              20.h.ph,
              profileImage(),
              12.h.ph,
              Text(
                AppStrings.uploadProfilePhoto,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              48.h.ph,

              CustomDropDown(
                selectedValue: selectedCountry,
                hintText: AppStrings.country,
                labelText: AppStrings.yourNationality,
                prefixIcon: AppImages.flagIcon,
                items: countryList,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              CustomDivider(dividerThickness: 1),
              7.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.usedToConnect,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              32.h.ph,
              CustomDropDown(
                selectedValue: selectedlanguage,
                hintText: AppStrings.languages,
                labelText: AppStrings.languages,
                prefixIcon: AppImages.languageIcon,
                items: languagesList,
                onChanged: (value) {
                  setState(() {
                    selectedlanguage = value;
                  });
                },
              ),
              CustomDivider(dividerThickness: 1),
              7.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.selectMultipleLanguages,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              118.h.ph,
              CustomButton(
                text: AppStrings.continueText,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.travelDetailSetupScreen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileImage() {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            shape: BoxShape.circle,
            border: Border.all(width: 1.w, color: AppColors.red3),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.redLight,
              shape: BoxShape.circle,
              border: Border.all(width: 1.w, color: AppColors.red3),
            ),
            child: Transform.scale(
              scale: 0.6,
              child: SharePictures(imagePath: AppImages.cameraIcon),
            ),
          ),
        ),
      ],
    );
  }
}
