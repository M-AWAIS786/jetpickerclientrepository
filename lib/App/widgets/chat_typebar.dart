import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../utils/share_pictures.dart';

class ChatSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Color? searchBarColor;
  final Color? prefixColor;
  final Color? sufixColor;
  final Color? sendContainerColor;
  final Color? sendIconColor;
  final Color? borderColor;
  final String? hintText;

  const ChatSearchBar({
    super.key,
    this.controller,
    this.onFilterTap,
    this.onChanged,
    this.focusNode,
    this.searchBarColor,
    this.prefixColor,
    this.sufixColor,
    this.hintText,
    this.sendContainerColor,
    this.sendIconColor,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: searchBarColor ?? AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color:borderColor?? AppColors.redLight, width: 0.5),
            ),

            child: Row(
              children: [
                SharePictures(
                  imagePath: AppImages.emojiIcon,
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    prefixColor ?? AppColors.red2,
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
                      hintText: hintText ?? AppStrings.typeSometing,
                      hintStyle: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: AppColors.labelGray),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.labelGray,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: onFilterTap,
                  child: SharePictures(
                    imagePath: AppImages.chatLineIcon,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      sufixColor ?? AppColors.red1,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        10.w.pw,
        Container(
          width: 52.w,
          height: 52.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: sendContainerColor ?? AppColors.red3,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SharePictures(
            imagePath: AppImages.sendIcon,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              sendIconColor ?? AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
