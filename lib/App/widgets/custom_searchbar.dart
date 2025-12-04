import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../utils/share_pictures.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Color? searchBarColor;
  final Color? prefixColor;
  final Color? sufixColor;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onFilterTap,
    this.onChanged,
    this.focusNode,
    this.searchBarColor,
    this.prefixColor,
    this.sufixColor,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: searchBarColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          SharePictures(
            imagePath: AppImages.searchIcon,
            width: 20.w,
            height: 20.h,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              prefixColor ?? AppColors.red3,
              BlendMode.srcIn,
            ),
          ),

          10.w.pw,

          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText ?? "Browse jet orders",
                hintStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.labelGray),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.labelGray),
            ),
          ),

          GestureDetector(
            onTap: onFilterTap,
            child: SharePictures(
              imagePath: AppImages.moreIcon,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                sufixColor ?? AppColors.red3,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
