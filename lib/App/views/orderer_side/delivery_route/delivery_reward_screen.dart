import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_text_formfeild.dart';

class DeliveryRewardScreen extends StatefulWidget {
  const DeliveryRewardScreen({super.key});

  @override
  State<DeliveryRewardScreen> createState() => _DeliveryRewardScreenState();
}

class _DeliveryRewardScreenState extends State<DeliveryRewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.enterDeliveryReward,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            34.h.ph,
            Text(
              AppStrings.enterReward,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            10.h.ph,
            CustomTextFormfeild(hintText: '\$ 10'),
          ],
        ),
      ),
    );
  }
}
