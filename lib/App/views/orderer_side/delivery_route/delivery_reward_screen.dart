import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_fontweight.dart';
import '../../../constants/app_strings.dart';

class DeliveryRewardScreen extends ConsumerWidget {
  const DeliveryRewardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOrderProvider);
    final vm = ref.read(createOrderProvider.notifier);

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
            12.h.ph,
            Text(
              'Set a reward amount that you\'re willing to pay the JetPicker for delivering your items.',
              style: TextStyle(
                color: AppColors.labelGray,
                fontSize: 13.sp,
              ),
            ),
            34.h.ph,
            Text(
              AppStrings.enterReward,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: TextWeight.semiBold,
                  ),
            ),
            10.h.ph,
            TextFormField(
              initialValue: state.reward,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: vm.setReward,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: TextWeight.semiBold,
              ),
              decoration: InputDecoration(
                hintText: '${state.currencySymbol} 10',
                hintStyle:
                    TextStyle(color: AppColors.labelGray, fontSize: 14.sp),
                prefixText: '${state.currencySymbol} ',
                prefixStyle: TextStyle(
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: TextWeight.semiBold,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.greyDD),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide:
                      const BorderSide(color: AppColors.yellow3, width: 1.5),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),
            24.h.ph,
            // ── Tip box ──
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8D6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: AppColors.starsColor, size: 20.sp),
                  8.w.pw,
                  Expanded(
                    child: Text(
                      'A fair reward helps attract JetPickers faster. Consider the weight, value, and distance of your items.',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12.sp,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
