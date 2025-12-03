import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class IconText extends StatelessWidget {
  final String labelText;
  final Color? labelTextColor;
  final String? prefixIcon;
  final Color? prefixIconColor;

  const IconText({
    super.key,
    required this.labelText,
    this.labelTextColor,
    this.prefixIcon,
    this.prefixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (prefixIcon != null)
          SharePictures(
            imagePath: prefixIcon!,
            width: 18.w,
            height: 18.h,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              prefixIconColor ?? AppColors.red3,
              BlendMode.srcIn,
            ),
          ),

        8.w.pw,

        Text(
          labelText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: labelTextColor ?? AppColors.red1,
          ),
        ),
      ],
    );
  }
}
