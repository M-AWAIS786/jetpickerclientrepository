import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? shadowColor;
  final double? radius;
  final double? btnHeight;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.textColor,
    this.borderColor,
    this.shadowColor,
    this.radius,
    this.btnHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: btnHeight ?? 48.h,
        decoration: BoxDecoration(
          color: color ?? AppColors.red3,
          borderRadius: BorderRadius.circular(radius ?? 8.r),
          border: Border.all(color: borderColor ?? Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black.withValues(alpha: 0.1),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.w700,
              fontSize: fontSize ?? 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
