import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
// removed unused import
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';
import 'package:jet_picks_app/App/view_model/order/order_detail_view_model.dart';
import '../../../utils/share_pictures.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';

class OrderHistorydetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderHistorydetailScreen({super.key, required this.orderId});
  @override
  ConsumerState<OrderHistorydetailScreen> createState() =>
      _OrderHistorydetailScreenState();
}

class _OrderHistorydetailScreenState
    extends ConsumerState<OrderHistorydetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderDetailProvider.notifier).fetchOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailProvider);

    // Listen for success/error messages from the view model
    ref.listen<OrderDetailState>(orderDetailProvider, (prev, next) {
      if (next.successMessage != null && next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.green1E,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(orderDetailProvider.notifier).clearMessages();
      }
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red57,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(orderDetailProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, OrderDetailState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.order == null) {
      return Center(child: Text(state.errorMessage!));
    }

    final OrderDetailModel? order = state.order;
    if (order == null) return const SizedBox.shrink();

    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final productImage = firstItem?.productImages != null && firstItem!.productImages!.isNotEmpty
        ? firstItem.productImages!.first
        : AppImages.cameraIcon;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              order.routeLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            20.h.ph,
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    children: [
                      _detailText(order.routeLabel),
                      _detailText(firstItem?.itemName ?? '-'),
                      _detailText(firstItem?.storeLink ?? '-'),
                      _detailText(firstItem?.weight ?? '-'),
                      _detailText('${order.currencySymbol}${order.itemsCost.toStringAsFixed(2)}'),
                      _detailText('${order.currencySymbol}${order.rewardAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
            35.h.ph,
            Container(
              width: 153.w,
              height: 148.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 0),
                    blurRadius: 14,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: SharePictures(imagePath: productImage),
              ),
            ),
            20.h.ph,
            Text(
              '${AppStrings.totalCost}: ${order.currencySymbol}${order.totalCost.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            24.h.ph,
            Text(order.picker?.fullName ?? 'JetPicker', style: Theme.of(context).textTheme.titleMedium),
            11.h.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.lightGray,
                  child: Center(child: Text(order.picker?.initials ?? 'M')),
                ),
                8.w.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.picker?.fullName ?? 'Unknown',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),

                    Row(
                      children: [
                        Text(
                          (order.picker?.rating ?? 0).toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelLarge,
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
            43.h.ph,
            Text(
              AppStrings.orderMarkedasDelivered.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            13.h.ph,
            Align(
              alignment: Alignment.centerLeft,
              child: RadioText(
                text: AppStrings.deliveryCompleted,
                isSelected: true,
                onChanged: () {},
              ),
            ),
            10.h.ph,
            Align(
              alignment: Alignment.centerLeft,
              child: RadioText(
                text: AppStrings.issueWithDelivery,
                selectedColor: AppColors.red57,
                isSelected: false,
                onChanged: () {},
              ),
            ),
            12.h.ph,
            // Orderer action buttons: Confirm Delivery, Report Issue
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Confirm Delivery',
                    onPressed: state.isActionLoading
                        ? null
                        : () => ref.read(orderDetailProvider.notifier).confirmDeliveryOrderer(),
                    isLoading: state.isActionLoading,
                    btnHeight: 48.h,
                    radius: 10.r,
                    color: AppColors.green1E,
                    textColor: Colors.white,
                  ),
                ),
                12.w.pw,
                Expanded(
                  child: CustomButton(
                    text: 'Report Issue',
                    onPressed: state.isActionLoading ? null : () => _showReportIssueDialog(context),
                    btnHeight: 48.h,
                    radius: 10.r,
                    color: AppColors.white,
                    textColor: AppColors.red3,
                    borderColor: AppColors.red3,
                  ),
                ),
              ],
            ),
            18.h.ph,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.yellow1,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                '${AppStrings.remainingTime} 47h : 12m',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            13.h.ph,
            Text(
              AppStrings.confirmOrder,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            37.h.ph,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: AppColors.yellow1,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.rateYourExperience,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: TextWeight.bold,
                    ),
                  ),
                  20.h.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: 32, color: AppColors.starsColor),
                      Icon(Icons.star, size: 32, color: AppColors.starsColor),
                      Icon(Icons.star, size: 32, color: AppColors.starsColor),
                      Icon(Icons.star, size: 32, color: AppColors.starsColor),
                      Icon(Icons.star, size: 32, color: AppColors.starsColor),
                    ],
                  ),
                  20.h.ph,
                  Container(
                    width: double.infinity,
                    height: 92.h,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text('Write your comment'),
                  ),
                  12.h.ph,
                  Container(
                    width: double.infinity,
                    height: 92.h,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.tipOption,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        17.h.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RadioText(
                              text: '\$5',
                              fontSize: 12.sp,
                              isSelected: true,
                              onChanged: () {},
                            ),
                            RadioText(
                              text: '\$10',
                              fontSize: 12.sp,
                              isSelected: false,
                              onChanged: () {},
                            ),
                            RadioText(
                              text: 'Custom amount',
                              fontSize: 12.sp,
                              isSelected: false,
                              onChanged: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  20.h.ph,
                  // Review submit and Tip actions
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Submit Review',
                          onPressed: state.isActionLoading
                              ? null
                              : () => _showReviewDialog(context, order),
                          isLoading: state.isActionLoading,
                          btnHeight: 48.h,
                          radius: 10.r,
                          color: AppColors.yellow3,
                          textColor: AppColors.black,
                        ),
                      ),
                      12.w.pw,
                      Expanded(
                        child: CustomButton(
                          text: 'Tip Picker',
                          onPressed: state.isActionLoading ? null : () => _showTipDialog(context),
                          btnHeight: 48.h,
                          radius: 10.r,
                          color: AppColors.white,
                          textColor: AppColors.black,
                          borderColor: AppColors.greyDD,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            30.h.ph,
          ],
        ),
      ),
    );
  }

  // ---------- Dialogs and helpers for orderer actions ----------
  void _showReportIssueDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Issue'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Describe the issue'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final reason = controller.text.trim();
              if (reason.isEmpty) return;
              Navigator.of(ctx).pop();
              await ref.read(orderDetailProvider.notifier).reportIssueOrderer(reason);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, OrderDetailModel order) {
    final commentController = TextEditingController();
    int selectedRating = 5;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) {
        return AlertDialog(
          title: const Text('Submit Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final idx = i + 1;
                  return IconButton(
                    onPressed: () => setState(() => selectedRating = idx),
                    icon: Icon(
                      Icons.star,
                      color: selectedRating >= idx ? AppColors.starsColor : AppColors.labelGray,
                    ),
                  );
                }),
              ),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Write your review'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                final comment = commentController.text.trim();
                final revieweeId = order.picker?.id ?? '';
                Navigator.of(ctx).pop();
                await ref.read(orderDetailProvider.notifier).submitReviewOrderer(
                  rating: selectedRating,
                  comment: comment,
                  revieweeId: revieweeId,
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      }),
    );
  }

  void _showTipDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send Tip'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: 'Amount (e.g. 5.00)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final text = controller.text.trim();
              final amount = double.tryParse(text);
              if (amount == null) return;
              Navigator.of(ctx).pop();
              await ref.read(orderDetailProvider.notifier).submitTipOrderer(amount);
            },
            child: const Text('Send'),
          ),
        ],
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
