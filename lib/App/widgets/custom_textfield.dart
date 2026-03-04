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
  final String? prefixIcon;
  final Color? prefixColor;
  final String? sufixIcon;
  final Color? sufixColor;
  final Color? fillColor;
  final Color? borderColor;
  final Color? labelColor;
  final Color? cursorColor;
  final Color? hintColor;
  final Color? textColor;
  final TextEditingController? controller;
  final VoidCallback? onTogglePassword;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.onTogglePassword,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.prefixColor,
    this.sufixIcon,
    this.sufixColor,
    this.fillColor,
    this.borderColor,
    this.labelColor,
    this.cursorColor,
    this.hintColor,
    this.textColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.redLight,
        borderRadius: BorderRadius.circular(8.r),
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? AppColors.redLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              prefixIcon == null
                  ? SizedBox(width: 20.w, height: 20.h)
                  : SharePictures(
                      imagePath: prefixIcon!,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        prefixColor ?? AppColors.red3.withValues(alpha:0.50 ),
                        BlendMode.srcIn,
                      ),
                    ),
              14.w.pw,
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: labelColor ?? AppColors.labelGray,
                  fontWeight: TextWeight.bold
                ),
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
                  validator: validator,
                  keyboardType: keyboardType,
                  cursorColor: cursorColor ?? AppColors.red3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    isDense: true,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: hintColor ?? AppColors.red3,
                      fontWeight: TextWeight.regular,
                    ),
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor ?? AppColors.red3,
                  ),
                ),
              ),

              if (isPassword)
                GestureDetector(
                  onTap: onTogglePassword,
                  child: Transform.scale(
                    scale: 0.7,
                    child: SharePictures(
                      imagePath: obscureText
                          ? AppImages.eyeClosedIcon
                          : AppImages.eyeOpenedIcon,
                      width: obscureText ? 35.w : 35.w,
                      height: obscureText ? 35.w : 35.w,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        sufixColor ?? AppColors.red3,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

              if (sufixIcon != null)
                Transform.scale(
                  scale: 1.3,
                  child: SharePictures(
                    imagePath: sufixIcon!,
                    colorFilter: ColorFilter.mode(
                      sufixColor ?? AppColors.red3,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
