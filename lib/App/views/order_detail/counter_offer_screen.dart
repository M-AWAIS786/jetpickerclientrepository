import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../../constants/app_strings.dart';
import '../../widgets/custom_text_formfeild.dart';

class CounterOfferScreen extends StatefulWidget {
  const CounterOfferScreen({super.key});

  @override
  State<CounterOfferScreen> createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends State<CounterOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(appBarColor: AppColors.white, leadingIcon: true),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              40.h.ph,
              Text(
                textAlign: TextAlign.center,
                AppStrings.counterOffertitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.red1),
              ),
              90.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.myCounterOffer,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.red1),
                ),
              ),
              12.h.ph,
              CustomTextFormfeild(hintText: '\$30'),
              270.h.ph,
              CustomButton(text: AppStrings.send, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
