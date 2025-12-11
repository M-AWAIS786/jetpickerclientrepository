// message_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

import '../../../models/message_model.dart';

class OrdererMessageBubble extends StatelessWidget {
  final Message message;

  const OrdererMessageBubble({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    final radius = message.isSender
        ? BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(4.r),
          );

    return Align(
      alignment: message.isSender
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (message.hasTranslation)
              Container(
                margin: EdgeInsets.only(bottom: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.yellow3,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Translate',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

            // Bubble
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: message.isSender
                    ? AppColors.yellow1
                    : AppColors.redLight,
                borderRadius: radius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(fontSize: 12.sp),
                  ),

                  if (message.hasTranslation)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        'Si, tengo tarifas fijas.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Time + tick
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(color: AppColors.labelGray, fontSize: 11.sp),
                ),
                if (message.isSender)
                  Icon(Icons.check, size: 14.sp, color: AppColors.yellow3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
