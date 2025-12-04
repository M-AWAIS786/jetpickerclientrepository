import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? titleColor;
  final Color? appBarColor;
  final VoidCallback? onBellTap;
  final Brightness? statusBarIconBrightness;

  const ProfileAppBar({
    super.key,
    required this.title,
    this.titleColor,
    this.appBarColor,
    this.onBellTap,
    this.statusBarIconBrightness,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light,
      ),
    );
    return Container(
      padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
      decoration: BoxDecoration(color: appBarColor ?? AppColors.red3),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: titleColor ?? AppColors.white,
                ),
              ),

              GestureDetector(
                onTap: onBellTap,
                child: SharePictures(
                  imagePath: AppImages.bellIcon,
                  width: 22.w,
                  height: 22.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
