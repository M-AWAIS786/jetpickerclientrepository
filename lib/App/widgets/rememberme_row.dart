import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class RememberTermsWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final bool rememberMe;
  final bool iAgree;
  final Function(bool)? onChange;
  final Color? activeTrackColor;
  final Color? inActiveTrackColor;
  final Color? agreeTextColor;
  final Color? agreeIconinActiveColor;
  final Color? agreeIconActiveColor;
  final String? agreeText;

  const RememberTermsWidget({
    super.key,
    this.text,
    this.textColor,
    this.onChange,
    this.rememberMe = false,
    this.iAgree = false,
    this.activeTrackColor,
    this.inActiveTrackColor,
    this.agreeIconActiveColor,
    this.agreeIconinActiveColor,
    this.agreeText,
    this.agreeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text ?? AppStrings.rememberMe,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor ?? AppColors.red3,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: rememberMe,
                activeTrackColor: activeTrackColor ?? AppColors.red3,
                inactiveTrackColor: inActiveTrackColor ?? AppColors.redLight,
                inactiveThumbColor: Colors.white,
                onChanged: onChange,
              ),
            ),
          ],
        ),

        20.h.ph,

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SharePictures(
              imagePath: AppImages.agreeIcon,
              width: 18.w,
              height: 18.h,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                iAgree
                    ? agreeIconActiveColor ?? AppColors.red3
                    : agreeIconinActiveColor ?? AppColors.redLight,
                BlendMode.srcIn,
              ),
            ),
            10.w.pw,
            Text(
              agreeText ?? AppStrings.iAgree,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: agreeTextColor ?? AppColors.red3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
