import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

class DeliveryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalSteps;
  final int currentStep;
  final VoidCallback? onTap;

  const DeliveryAppBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.onTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w, bottom: 0.h),
      decoration: BoxDecoration(color: AppColors.white),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: AppColors.yellow3,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_sharp, color: AppColors.black),
                ),
              ),

              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalSteps, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.5.w),
                    width: 13.w,
                    height: 13.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= currentStep
                          ? AppColors.yellow3
                          : AppColors.greyDD,
                    ),
                  );
                }),
              ),

              Spacer(),
              SizedBox(width: 45.w, height: 45.h),
            ],
          ),
        ),
      ),
    );
  }
}
