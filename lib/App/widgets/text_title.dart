import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';

class TextTile extends StatelessWidget {
  final String titleText;
  final String trailingText;
  final Color? titleTextColor;
  final Color? trailingTextColor;
  final FontWeight? fontWeight;
  final double? fontSize;

  const TextTile({
    super.key,
    required this.titleText,
    required this.trailingText,
    this.titleTextColor,
    this.trailingTextColor,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: titleTextColor ?? AppColors.black,
          fontSize: fontSize ?? 14.sp,
          fontWeight: fontWeight ?? TextWeight.regular,
        ),
      ),
      trailing: Text(
        trailingText,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: trailingTextColor ?? AppColors.black,
          fontSize: fontSize ?? 14.sp,
          fontWeight: fontWeight ?? TextWeight.regular,
        ),
      ),
    );
  }
}
