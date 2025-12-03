import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hint;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,

      decoration: InputDecoration(
        prefix: SharePictures(
          imagePath: AppImages.searchIcon,
          width: 20.w,
          height: 20.h,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(AppColors.red3, BlendMode.srcIn),
        ),
        suffixIcon: Transform.scale(
          scale: 0.3,
          child: SharePictures(
            imagePath: AppImages.moreIcon,
            width: 20.w,
            height: 20.h,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(AppColors.red3, BlendMode.srcIn),
          ),
        ),
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 0.w),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.red3, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.red3, width: 1),
        ),
      ),
    );
  }
}
