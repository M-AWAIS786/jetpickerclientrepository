import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class CustomDropDown extends StatelessWidget {
  final String? selectedValue;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? labelText;
  final Color? labelTextColor;
  final String? prefixIcon;
  final Color? preficIconColor;
  final Color? hintTextColor;
  final Color? sufixColor;
  final Color? dropDownTextColor;

  const CustomDropDown({
    super.key,
    this.selectedValue,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.labelTextColor,
    this.prefixIcon,
    this.preficIconColor,
    this.dropDownTextColor,
    this.hintTextColor,
    this.sufixColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              if (prefixIcon != null)
                SharePictures(
                  imagePath: prefixIcon!,
                  width: 18.w,
                  height: 18.h,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    preficIconColor ?? AppColors.red3,
                    BlendMode.srcIn,
                  ),
                ),

              if (prefixIcon != null) 8.w.pw,

              Text(
                labelText!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: labelTextColor ?? AppColors.red1,
                ),
              ),
            ],
          ),

        Padding(
          padding: EdgeInsets.only(left: prefixIcon != null ? 30.w : 30.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: AppColors.white,
              value: selectedValue,
              isExpanded: true,
              hint: Text(
                hintText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: hintTextColor ?? AppColors.red3,
                ),
              ),
              icon: SharePictures(
                imagePath: AppImages.dropDownIcon,
                width: 10.w,
                height: 6.h,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  sufixColor ?? AppColors.red3,
                  BlendMode.srcIn,
                ),
              ),

              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: dropDownTextColor ?? AppColors.red3,
                    ),
                  ),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
