import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_fontweight.dart';

class CustomTextFormfeild extends StatelessWidget {
  final String hintText;
  final Color? fillColor;
  final Color? borderColor;
  final Color? cursorColor;
  final Color? hintColor;
  final Color? textColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? dividerWidth;

  const CustomTextFormfeild({
    super.key,

    required this.hintText,
    this.fillColor,
    this.borderColor,
    this.cursorColor,
    this.hintColor,
    this.textColor,
    this.controller,
    this.validator,
    this.dividerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      cursorColor: cursorColor ?? AppColors.red3,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: hintColor ?? AppColors.labelGray,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.labelGray,
            width: dividerWidth ?? 0.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.labelGray),
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: hintColor ?? AppColors.labelGray,
        fontWeight: TextWeight.semiBold,
      ),
    );
  }
}
