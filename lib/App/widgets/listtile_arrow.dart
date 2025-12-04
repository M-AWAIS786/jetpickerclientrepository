import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class ListTileArrow extends StatelessWidget {
  final String text;
  final String prefixIcon;
  final String? sufixIcon;
  final Color? textColor;
  final Color? prefixIconColor;
  final Color? sufixIconColor;
  final Color? containerColor;

  const ListTileArrow({
    super.key,
    required this.text,
    required this.prefixIcon,
    this.sufixIcon,
    this.textColor,
    this.prefixIconColor,
    this.sufixIconColor,
    this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: containerColor ?? AppColors.redLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          SharePictures(
            imagePath: prefixIcon,
            width: 20.w,
            height: 20.h,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              prefixIconColor ?? AppColors.red3,
              BlendMode.srcIn,
            ),
          ),
          8.w.pw,
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor ?? AppColors.red3,
            ),
          ),
          Spacer(),
          if (sufixIcon != null)
            SharePictures(
              imagePath: sufixIcon!,
              width: 12.w,
              height: 12.h,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                sufixIconColor ?? AppColors.red3,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
