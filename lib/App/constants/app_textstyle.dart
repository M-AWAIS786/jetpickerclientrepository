import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_fontweight.dart';

class AppResponsiveTypography {
  static TextTheme get textTheme => TextTheme(

     displayLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
    ),

     headlineMedium: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      height: 1.10,
    ),

     headlineSmall: TextStyle(
      fontSize: 20.sp,
      fontWeight: TextWeight.bold,
    ),

     titleLarge: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w400,
      height: 1.145,
    ),

     titleMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      height: 1.10,
    ),

     titleSmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),

     bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),

     bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),

     bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ),

      labelLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      height: 1.10,
    ),

      labelMedium: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ),

      labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ),
  );


  
}
