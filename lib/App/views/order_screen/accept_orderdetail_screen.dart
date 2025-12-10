import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';

import '../../utils/share_pictures.dart';

class AcceptOrderdetailScreen extends StatefulWidget {
  const AcceptOrderdetailScreen({super.key});

  @override
  State<AcceptOrderdetailScreen> createState() =>
      _AcceptOrderdetailScreenState();
}

class _AcceptOrderdetailScreenState extends State<AcceptOrderdetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(leadingIcon: true, appBarColor: AppColors.white),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'London - Madrid',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.red3),
              ),
              20.h.ph,
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        _detailText(
                          AppStrings.route,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.itemList,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.store,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.weight,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.price,
                          textColor: AppColors.black,
                        ),
                        _detailText(
                          AppStrings.reward,
                          textColor: AppColors.black,
                        ),
                      ],
                    ),
                    26.w.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        _detailText(AppStrings.fromLondonToMadrid),
                        _detailText(AppStrings.watch),
                        _detailText(AppStrings.egAmazone),
                        _detailText('1/4 kg'),
                        _detailText('\$50'),
                        _detailText('\$10'),
                      ],
                    ),
                  ],
                ),
              ),
              35.h.ph,
              Container(
                width: 150.w,
                height: 150.h,
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
              20.h.ph,
              Text(
                '${AppStrings.totalCost}: \$70',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              24.h.ph,
              Text(
                'JetOrderer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              11.h.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColors.lightGray,
                    child: Center(child: Text('A')),
                  ),
                  8.w.pw,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sarah M.',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.black,
                        ),
                      ),

                      Row(
                        children: [
                          Text(
                            '4.8',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.black),
                          ),

                          Icon(
                            Icons.star,
                            color: AppColors.starColor,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              60.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: RadioText(
                  text: AppStrings.markAsDelivered,
                  isSelected: true,
                  onChanged: () {},
                ),
              ),
              18.h.ph,

              Container(
                width: double.infinity,
                height: 150.h,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.w, color: AppColors.labelGray),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SharePictures(imagePath: AppImages.uploadIcon),
                    4.h.ph,
                    _detailText(AppStrings.uploadProofOfDelivery),
                  ],
                ),
              ),
              30.h.ph,
              SizedBox(
                width: 150.w,
                child: CustomButton(text: AppStrings.upload, onPressed: () {}),
              ),
              30.h.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailText(String title, {Color? textColor}) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: textColor ?? AppColors.labelGray),
    );
  }
}
