import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
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
    final productImage =
        firstItem?.productImages != null && firstItem!.productImages!.isNotEmpty
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
                      _detailText(AppStrings.route, textColor: AppColors.black),
                      _detailText(
                        AppStrings.itemList,
                        textColor: AppColors.black,
                      ),
                      _detailText(AppStrings.store, textColor: AppColors.black),
                      _detailText(
                        AppStrings.weight,
                        textColor: AppColors.black,
                      ),
                      _detailText(AppStrings.price, textColor: AppColors.black),
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
                      _detailText(
                        '${order.currencySymbol}${order.itemsCost.toStringAsFixed(2)}',
                      ),
                      _detailText(
                        '${order.currencySymbol}${order.rewardAmount.toStringAsFixed(2)}',
                      ),
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
              child: Center(child: SharePictures(imagePath: productImage)),
            ),
            20.h.ph,
            Text(
              '${AppStrings.totalCost}: ${order.currencySymbol}${order.totalCost.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            24.h.ph,
            Text(
              order.picker?.fullName ?? 'JetPicker',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
                  CustomButton(
                    text: AppStrings.submit,
                    color: AppColors.yellow3,
                    textColor: AppColors.black,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.orderAcceptedScreen,
                      );
                    },
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

  Widget _detailText(String title, {Color? textColor}) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: textColor ?? AppColors.labelGray),
    );
  }
}
