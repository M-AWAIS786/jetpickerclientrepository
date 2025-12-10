import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/profile_setup_data.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/listtile_switch.dart';

class OsettingScreen extends StatefulWidget {
  const OsettingScreen({super.key});

  @override
  State<OsettingScreen> createState() => _OsettingScreenState();
}

class _OsettingScreenState extends State<OsettingScreen> {
  String? selectedlanguage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.settings,
        appBarColor: AppColors.yellow3,
        titleColor: AppColors.black,
        bellColor: AppColors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.ph,
            Text(
              AppStrings.notifications,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: TextWeight.bold),
            ),
            8.h.ph,
            ListTileSwitch(
              text: AppStrings.pushNotification,
              isSwitch: false,
              activeTrackColor: AppColors.yellow3,
              inActiveTrackColor: AppColors.yellow1,
            ),
            ListTileSwitch(
              text: AppStrings.inAppNotifications,
              isSwitch: true,
              activeTrackColor: AppColors.yellow3,
              inActiveTrackColor: AppColors.yellow1,
            ),
            ListTileSwitch(
              text: AppStrings.messages,
              isSwitch: true,
              activeTrackColor: AppColors.yellow3,
              inActiveTrackColor: AppColors.yellow1,
            ),
            ListTileSwitch(
              text: AppStrings.location,
              isSwitch: true,
              activeTrackColor: AppColors.yellow3,
              inActiveTrackColor: AppColors.yellow1,
            ),

            56.h.ph,
            Text(
              AppStrings.languageAndTranslations,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: TextWeight.bold),
            ),
            23.h.ph,
            CustomDropDown(
              selectedValue: selectedlanguage,
              hintText: AppStrings.languages,
              labelText: AppStrings.translationLanguage,
              items: languagesList,
              dropDownTextColor: AppColors.black,
              labelTextColor: AppColors.black,
              hintTextColor: AppColors.black,
              sufixColor: AppColors.black,
              onChanged: (value) {
                setState(() {
                  selectedlanguage = value;
                });
              },
            ),
            CustomDivider(dividerThickness: 1),
            23.h.ph,
            ListTileSwitch(
              text: AppStrings.translateIncomingMessagesAutomatically,
              isSwitch: false,
              activeTrackColor: AppColors.yellow3,
              inActiveTrackColor: AppColors.yellow1,
            ),
            ListTileSwitch(
              text: AppStrings.showOriginalPlusTranslatedText,
              isSwitch: true,
              activeTrackColor: AppColors.yellow3,
              inActiveTrackColor: AppColors.yellow1,
            ),
            43.h.ph,
            Text(
              AppStrings.other,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: TextWeight.bold),
            ),
            4.h.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.privacyPolicy,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.labelGray),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
