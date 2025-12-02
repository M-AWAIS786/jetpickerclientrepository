import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final VoidCallback? onTogglePassword;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.onTogglePassword,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        border: Border(bottom: BorderSide(color: AppColors.redLight, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SharePictures(
                imagePath: AppImages.profileIcon,
                width: 20.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
              14.w.pw,
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.labelGray),
              ),
            ],
          ),

          Row(
            children: [
              34.w.pw,
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    isDense: true,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.red3,
                      fontWeight: TextWeight.semiBold,
                    ),
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.red3),
                ),
              ),

              if (isPassword)
                GestureDetector(
                  onTap: onTogglePassword,
                  child: SharePictures(
                    imagePath: obscureText
                        ? AppImages.eyeClosedIcon
                        : AppImages.eyeOpenedIcon,
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
