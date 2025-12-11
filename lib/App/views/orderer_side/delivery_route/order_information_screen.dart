import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/share_pictures.dart';

import '../../../widgets/custom_text_formfeild.dart';

class OrderInformationScreen extends StatefulWidget {
  const OrderInformationScreen({super.key});

  @override
  State<OrderInformationScreen> createState() => _OrderInformationScreenState();
}

class _OrderInformationScreenState extends State<OrderInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.orderInformation,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              19.h.ph,
              Text(
                AppStrings.uploadProductImages,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              19.h.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 153.w,
                    height: 148.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: Offset(0, 0),
                          blurRadius: 14,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SharePictures(imagePath: AppImages.cameraIcon),
                    ),
                  ),
                  Container(
                    width: 153.w,
                    height: 148.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        width: 1.w,
                        color: AppColors.labelGray,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SharePictures(
                          imagePath: AppImages.uploadPhotoIcon,
                          width: 24.w,
                          height: 24.h,
                        ),
                        6.h.ph,
                        Text(
                          AppStrings.addMorePhotos,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              43.h.ph,
              Text(
                AppStrings.itemName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: AppStrings.watch),
              33.h.ph,
              Text(
                AppStrings.storeLink,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: AppStrings.egAmazone),
              33.h.ph,
              Text(
                AppStrings.weight,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: '1/4 Kg'),
              33.h.ph,
              Text(
                AppStrings.priceOfItem,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: '\$ 50'),
              33.h.ph,
              Text(
                AppStrings.quantity,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              10.h.ph,
              CustomTextFormfeild(hintText: '01'),

              33.h.ph,
              Text(
                AppStrings.specialNotes,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              16.h.ph,
              CustomTextFormfeild(hintText: 'Write here'),
            ],
          ),
        ),
      ),
    );
  }
}
