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

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? selectedlanguage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.settings,
        titleColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.ph,
            Text(
              AppStrings.notifications,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: TextWeight.bold,
                color: AppColors.red3,
              ),
            ),
            8.h.ph,
            ListTileSwitch(text: AppStrings.pushNotification, isSwitch: false),
            ListTileSwitch(text: AppStrings.inAppNotifications, isSwitch: true),
            ListTileSwitch(text: AppStrings.messages, isSwitch: true),
            ListTileSwitch(text: AppStrings.location, isSwitch: true),

            56.h.ph,
            Text(
              AppStrings.languageAndTranslations,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: TextWeight.bold,
                color: AppColors.red3,
              ),
            ),
            23.h.ph,
            CustomDropDown(
              selectedValue: selectedlanguage,
              hintText: AppStrings.languages,
              labelText: AppStrings.translationLanguage,

              items: languagesList,
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
            ),
            ListTileSwitch(
              text: AppStrings.showOriginalPlusTranslatedText,
              isSwitch: true,
            ),
            43.h.ph,
            Text(
              AppStrings.other,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: TextWeight.bold,
                color: AppColors.red3,
              ),
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
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
