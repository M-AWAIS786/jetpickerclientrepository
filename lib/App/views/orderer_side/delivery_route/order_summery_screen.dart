import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';

import '../../../constants/app_fontweight.dart';
import '../../../widgets/radio_text.dart';

class OrderSummeryScreen extends ConsumerWidget {
  const OrderSummeryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOrderProvider);
    final vm = ref.read(createOrderProvider.notifier);
    final order = state.orderDetail;
    final symbol = state.currencySymbol;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.orderSummary,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              24.h.ph,

              // ── Order Details Card ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _summaryRow(context, AppStrings.route,
                        order?.routeLabel ?? '${state.originCountry} → ${state.destinationCountry}'),
                    12.h.ph,
                    if (order != null && order.items.isNotEmpty) ...[
                      ...order.items.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return Column(
                          children: [
                            if (idx > 0) Divider(color: AppColors.greyDD, height: 20.h),
                            _summaryRow(context, 'Item ${idx + 1}', item.itemName ?? '-'),
                            8.h.ph,
                            if (item.storeLink != null && item.storeLink!.isNotEmpty)
                              _summaryRow(context, AppStrings.store, item.storeLink!),
                            if (item.storeLink != null && item.storeLink!.isNotEmpty) 8.h.ph,
                            _summaryRow(context, AppStrings.weight, item.weight ?? '-'),
                            8.h.ph,
                            _summaryRow(context, AppStrings.price,
                                '$symbol${item.price.toStringAsFixed(2)}'),
                            8.h.ph,
                            _summaryRow(context, AppStrings.quantity, '${item.quantity}'),
                          ],
                        );
                      }),
                    ] else ...[
                      ...state.items.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return Column(
                          children: [
                            if (idx > 0) Divider(color: AppColors.greyDD, height: 20.h),
                            _summaryRow(context, 'Item ${idx + 1}', item.name),
                            8.h.ph,
                            if (item.storeLink.isNotEmpty)
                              _summaryRow(context, AppStrings.store, item.storeLink),
                            if (item.storeLink.isNotEmpty) 8.h.ph,
                            _summaryRow(context, AppStrings.weight,
                                item.weight.isNotEmpty ? '${item.weight} ${item.weightUnit}' : '-'),
                            8.h.ph,
                            _summaryRow(context, AppStrings.price, '$symbol${item.price}'),
                            8.h.ph,
                            _summaryRow(context, AppStrings.quantity, item.quantity),
                          ],
                        );
                      }),
                    ],
                  ],
                ),
              ),
              20.h.ph,

              // ── Fee Breakdown Card ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cost Breakdown',
                      style: TextStyle(
                        fontWeight: TextWeight.bold,
                        color: AppColors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    14.h.ph,
                    _feeRow(context, 'Items Amount',
                        '$symbol${state.itemsTotal.toStringAsFixed(2)}'),
                    10.h.ph,
                    _feeRow(context, 'Reward Amount',
                        '$symbol${state.rewardAmount.toStringAsFixed(2)}'),
                    10.h.ph,
                    _feeRow(context, 'JetPicker Fee (6.5%)',
                        '$symbol${state.jetPickerFee.toStringAsFixed(2)}'),
                    10.h.ph,
                    _feeRow(context, 'Payment Processing (4%)',
                        '$symbol${state.paymentProcessingFee.toStringAsFixed(2)}'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: const Divider(color: AppColors.greyDD),
                    ),
                    _feeRow(context, AppStrings.total,
                        '$symbol${state.totalCost.toStringAsFixed(2)}',
                        isBold: true, isLarge: true),
                  ],
                ),
              ),
              30.h.ph,

              // ── Terms Checkboxes ──
              Align(
                alignment: Alignment.centerLeft,
                child: RadioText(
                  text: AppStrings.iAgreetoTermConditions,
                  isSelected: state.termsAgreed,
                  fontSize: 14.sp,
                  fontWeight: TextWeight.regular,
                  iAgree: true,
                  checkContainerColor:
                      state.termsAgreed ? AppColors.green1E : AppColors.labelGray,
                  textColor: AppColors.labelGray,
                  checkColor: AppColors.white,
                  onChanged: () => vm.setTermsAgreed(!state.termsAgreed),
                ),
              ),
              8.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: RadioText(
                  text: AppStrings.iAgreetoCustomLaws,
                  isSelected: state.lawsAgreed,
                  fontSize: 14.sp,
                  fontWeight: TextWeight.regular,
                  iAgree: true,
                  checkContainerColor:
                      state.lawsAgreed ? AppColors.green1E : AppColors.labelGray,
                  textColor: AppColors.labelGray,
                  checkColor: AppColors.white,
                  onChanged: () => vm.setLawsAgreed(!state.lawsAgreed),
                ),
              ),
              30.h.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: TextWeight.semiBold,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.labelGray,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _feeRow(BuildContext context, String label, String value,
      {bool isBold = false, bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isBold ? AppColors.black : AppColors.labelGray,
                fontWeight: isBold ? TextWeight.semiBold : TextWeight.regular,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.black,
                fontWeight: isBold ? TextWeight.bold : TextWeight.semiBold,
                fontSize: isLarge ? 18.sp : null,
              ),
        ),
      ],
    );
  }
}
