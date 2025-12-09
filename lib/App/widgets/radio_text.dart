import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class RadioText extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool iAgree;
  final VoidCallback onChanged;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final Color? textColor;
  final Color? checkColor;
  final Color? checkContainerColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const RadioText({
    super.key,
    required this.text,
    required this.isSelected,
    this.iAgree = false,
    required this.onChanged,
    this.selectedColor,
    this.unSelectedColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.checkColor,
    this.checkContainerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (iAgree)
          InkWell(
            onTap: onChanged,
            borderRadius: BorderRadius.circular(100.r),
            child: Container(
              width: 20.w,
              height: 20.h,
              padding: EdgeInsets.all(3.0.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? checkContainerColor ?? AppColors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: isSelected ? AppColors.white : AppColors.white,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 12,
                  color: isSelected
                      ? checkColor ?? AppColors.black
                      : AppColors.black,
                ),
              ),
            ),
          ),

        if (iAgree == false)
          InkWell(
            onTap: onChanged,
            borderRadius: BorderRadius.circular(100.r),
            child: Container(
              width: 22.w,
              height: 22.h,
              padding: EdgeInsets.all(3.0.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? selectedColor ?? AppColors.green1C
                      : unSelectedColor ?? AppColors.red3,
                  width: 2.0,
                ),
              ),
              child: isSelected
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedColor ?? AppColors.green1C,
                      ),
                    )
                  : null,
            ),
          ),

        12.w.pw,

        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: fontSize ?? 16.sp,
            fontWeight: fontWeight ?? TextWeight.semiBold,
            color: textColor ?? AppColors.black,
          ),
        ),
      ],
    );
  }
}
