// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:jet_picks_app/App/constants/app_colors.dart';
// import 'package:jet_picks_app/App/constants/app_images.dart';
// import 'package:jet_picks_app/App/utils/share_pictures.dart';
// import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

// class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final String? imagePath;
//   final Color? titleColor;
//   final Color? appBarColor;
//   final VoidCallback? onBellTap;
//   final Brightness? statusBarIconBrightness;
//   final bool leadingIcon;
//   final Color? backBtnColor;
//   final Color? backIconColor;
//   final Color? bellColor;
//   const HomeAppBar({
//     super.key,
//     required this.title,
//     this.titleColor,
//     this.appBarColor,
//     this.onBellTap,
//     this.backBtnColor,
//     this.backIconColor,
//     this.bellColor,
//     this.statusBarIconBrightness,
//     this.leadingIcon = false,
//     this.imagePath,
//   });

//   @override
//   Size get preferredSize => const Size.fromHeight(90);

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light,
//       ),
//     );
//     return Container(
//       padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
//       decoration: BoxDecoration(color: appBarColor ?? AppColors.white),
//       child: SafeArea(
//         bottom: false,
//         child: SizedBox(
//           height: 60.h,
//           child: Row(
//             children: [
//               if (leadingIcon)
//                 InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     width: 45.w,
//                     height: 45.h,
//                     decoration: BoxDecoration(
//                       color: backBtnColor ?? AppColors.red3,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.arrow_back_sharp,
//                       color: backIconColor ?? AppColors.white,
//                     ),
//                   ),
//                 ),

             

//               if (leadingIcon) Spacer(),
//               if (imagePath != null) 10.w.pw,

//               if (title != null)
//                 Text(
//                   title!,
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     color: titleColor ?? AppColors.red3,
//                   ),
//                 ),

//               Spacer(),

//               if (!leadingIcon)
//                 GestureDetector(
//                   onTap: onBellTap,
//                   child: SharePictures(
//                     imagePath: AppImages.bellIcon,
//                     width: 22.w,
//                     height: 22.h,
//                     fit: BoxFit.cover,
//                     colorFilter: ColorFilter.mode(
//                       bellColor ?? AppColors.white,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),

//               if (leadingIcon) SizedBox(width: 45.w, height: 45.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
