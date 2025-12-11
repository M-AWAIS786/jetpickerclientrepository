import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../constants/app_colors.dart';

class ShowSuccessDialogue extends StatelessWidget {
  const ShowSuccessDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.yellow2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 57.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SharePictures(imagePath: AppImages.planIcon),
            40.h.ph,
            Text(
              "Order successfully posted",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            67.h.ph,
            CustomButton(
              text: AppStrings.cancelOrder,
              color: AppColors.white,
              textColor: AppColors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
