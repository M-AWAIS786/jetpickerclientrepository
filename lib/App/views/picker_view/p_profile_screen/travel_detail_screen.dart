import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/views/picker_view/p_profile_screen/widget/c_text_row.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_text_formfeild.dart';

class TravelDetailScreen extends StatelessWidget {
  const TravelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.travelDetails,
        titleColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.ph,
            Text(
              AppStrings.travelHistory,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            17.h.ph,
            textRow(context, AppStrings.fromLondonToMadrid, '12 Dec'),
            12.h.ph,
            textRow(context, AppStrings.fromLondonToMadrid, '12 Dec'),
            12.h.ph,
            textRow(context, AppStrings.fromLondonToMadrid, '12 Dec'),
            63.h.ph,
            CustomButton(text: AppStrings.createNewJourney, onPressed: () {
              goRouter.push(AppRoutes.travelDetailSetupScreen);
            }),
            58.h.ph,
            Text(
              AppStrings.updateWeightCapacity,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppColors.red3),
            ),
            CustomTextFormfeild(hintText: '10kg'),
            200.h.ph,

            CustomButton(text: AppStrings.save, onPressed: () {

            }),
          ],
        ),
      ),
    );
  }
}
