import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

class ChatListCard extends StatelessWidget {
  final Color? containerColor;
  final Color? avaterBackgoundColor;
  final String name;
  final String lastMessage;
  final String time;
  final Color? nameColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ChatListCard({
    super.key,
    this.containerColor,
    this.avaterBackgoundColor,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.iconColor,
    this.nameColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: containerColor ?? Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: avaterBackgoundColor ?? AppColors.labelGray,
              child: SharePictures(imagePath: AppImages.phoneIcon1),
            ),
            10.w.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: TextWeight.bold,
                      fontSize: 14.sp,
                      color: nameColor ?? AppColors.red3,
                    ),
                  ),
      
                  4.h.ph,
                  Text(
                    lastMessage,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.labelGray,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.labelGray,
                  ),
                ),
                4.h.ph,
                Icon(
                  Icons.done_all,
                  size: 20.sp,
                  color: iconColor ?? AppColors.red3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
