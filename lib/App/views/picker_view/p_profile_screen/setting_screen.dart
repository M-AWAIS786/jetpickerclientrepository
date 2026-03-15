import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/user_profile/user_settings_view_model.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/profile_setup_data.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/listtile_switch.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userSettingsProvider.notifier).loadSettings(UserSettingsRole.picker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userSettingsProvider);

    ref.listen<UserSettingsState>(userSettingsProvider, (prev, next) {
      if (next.successMessage != null && next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: Colors.green),
        );
        ref.read(userSettingsProvider.notifier).clearMessages();
      }

      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
        ref.read(userSettingsProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.settings,
        titleColor: AppColors.white,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red3))
          : Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
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
            ListTileSwitch(
              text: AppStrings.pushNotification,
              isSwitch: state.settings.pushNotificationsEnabled,
              onChange: state.isUpdating
                  ? null
                  : (value) => ref.read(userSettingsProvider.notifier).updateSettings(
                        UserSettingsRole.picker,
                        {'push_notifications_enabled': value},
                      ),
            ),
            ListTileSwitch(
              text: AppStrings.inAppNotifications,
              isSwitch: state.settings.inAppNotificationsEnabled,
              onChange: state.isUpdating
                  ? null
                  : (value) => ref.read(userSettingsProvider.notifier).updateSettings(
                        UserSettingsRole.picker,
                        {'in_app_notifications_enabled': value},
                      ),
            ),
            ListTileSwitch(
              text: AppStrings.messages,
              isSwitch: state.settings.messageNotificationsEnabled,
              onChange: state.isUpdating
                  ? null
                  : (value) => ref.read(userSettingsProvider.notifier).updateSettings(
                        UserSettingsRole.picker,
                        {'message_notifications_enabled': value},
                      ),
            ),
            ListTileSwitch(
              text: AppStrings.location,
              isSwitch: state.settings.locationServicesEnabled,
              onChange: state.isUpdating
                  ? null
                  : (value) => ref.read(userSettingsProvider.notifier).updateSettings(
                        UserSettingsRole.picker,
                        {'location_services_enabled': value},
                      ),
            ),

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
              selectedValue: state.settings.translationLanguage,
              hintText: AppStrings.languages,
              labelText: AppStrings.translationLanguage,

              items: languagesList,
              onChanged: (value) {
                if (value == null || state.isUpdating) return;
                ref.read(userSettingsProvider.notifier).updateSettings(
                  UserSettingsRole.picker,
                  {'translation_language': value},
                );
              },
            ),
            CustomDivider(dividerThickness: 1),
            23.h.ph,
            ListTileSwitch(
              text: AppStrings.translateIncomingMessagesAutomatically,
              isSwitch: state.settings.autoTranslateMessages,
              onChange: state.isUpdating
                  ? null
                  : (value) => ref.read(userSettingsProvider.notifier).updateSettings(
                        UserSettingsRole.picker,
                        {'auto_translate_messages': value},
                      ),
            ),
            ListTileSwitch(
              text: AppStrings.showOriginalPlusTranslatedText,
              isSwitch: state.settings.showOriginalAndTranslated,
              onChange: state.isUpdating
                  ? null
                  : (value) => ref.read(userSettingsProvider.notifier).updateSettings(
                        UserSettingsRole.picker,
                        {'show_original_and_translated': value},
                      ),
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
      ),
    );
  }
}
