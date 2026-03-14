import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/models/stripe/stripe_models.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/checkout_sheet.dart';
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
  bool _showPaymentNotice = true;
  bool _paymentSuccess = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderDetailProvider.notifier).fetchOrderDetail(widget.orderId);
    });
  }

  void _handlePayNow(OrderDetailModel order) {
    final amountInCents = formatAmountToCents(order.totalPayable);
    
    if (amountInCents <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment amount is zero. Please refresh and try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    CheckoutSheet.show(
      context: context,
      ref: ref,
      amount: amountInCents,
      currency: (order.currency ?? 'usd').toLowerCase(),
      description: 'Payment for order #${order.id}',
      orderId: order.id,
      metadata: {'orderId': order.id, 'order_id': order.id},
      onSuccess: () {
        setState(() {
          _paymentSuccess = true;
          _showPaymentNotice = false;
        });
        // Refresh order to get updated payment status
        ref.read(orderDetailProvider.notifier).fetchOrderDetail(widget.orderId);
      },
    );
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

    final bool showPayButton = !order.isPaid && 
        order.status.toUpperCase() != 'CANCELLED' &&
        order.status.toUpperCase() != 'COMPLETED';

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Route Header
            Text(
              order.routeLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            12.h.ph,
            
            // Status Badges Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Order Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
                8.w.pw,
                // Payment Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getPaymentStatusColor(order.paymentStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Payment: ${order.paymentStatus}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: _getPaymentStatusColor(order.paymentStatus),
                    ),
                  ),
                ),
              ],
            ),
            
            // Payment Notice Banner (like web)
            if (showPayButton && _showPaymentNotice) ...[
              16.h.ph,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.yellow3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Complete Payment to Proceed',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showPaymentNotice = false),
                          child: Icon(Icons.close, size: 18.sp, color: Colors.amber[700]),
                        ),
                      ],
                    ),
                    8.h.ph,
                    Text(
                      'Your order is ready! Please complete the payment to confirm your purchase.',
                      style: TextStyle(fontSize: 12.sp, color: Colors.amber[800]),
                    ),
                    12.h.ph,
                    SizedBox(
                      width: 100.w,
                      child: CustomButton(
                        text: 'Pay Now',
                        btnHeight: 40,
                        radius: 8.r,
                        color: Colors.amber[700],
                        textColor: Colors.white,
                        onPressed: () => _handlePayNow(order),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Payment Success Banner
            if (_paymentSuccess) ...[
              16.h.ph,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 24.sp),
                    12.w.pw,
                    Expanded(
                      child: Text(
                        'Payment completed successfully!',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _paymentSuccess = false),
                      child: Icon(Icons.close, size: 18.sp, color: Colors.green[600]),
                    ),
                  ],
                ),
              ),
            ],
            
            20.h.ph,
            
            // Order Details
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailText(AppStrings.route, textColor: AppColors.black),
                      _detailText(AppStrings.itemList, textColor: AppColors.black),
                      _detailText(AppStrings.store, textColor: AppColors.black),
                      _detailText(AppStrings.weight, textColor: AppColors.black),
                      _detailText(AppStrings.price, textColor: AppColors.black),
                      _detailText(AppStrings.reward, textColor: AppColors.black),
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
            
            // Fee Breakdown Card (matching web)
            24.h.ph,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Cost Breakdown',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  16.h.ph,
                  _feeRow('Items Amount', '${order.currencySymbol}${order.itemsCost.toStringAsFixed(2)}'),
                  8.h.ph,
                  _feeRow('Reward Amount', '${order.currencySymbol}${order.effectiveReward.toStringAsFixed(2)}'),
                  if (order.acceptedCounterOfferAmount != null) ...[
                    8.h.ph,
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.yellow1,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: _feeRow(
                        'Counter Offer',
                        '${order.currencySymbol}${order.acceptedCounterOfferAmount!.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ),
                  ],
                  8.h.ph,
                  _feeRow('JetPicker Fee (6.5%)', '${order.currencySymbol}${order.jetPickerFee.toStringAsFixed(2)}'),
                  8.h.ph,
                  _feeRow('Payment Processing (4%)', '${order.currencySymbol}${order.paymentProcessingFee.toStringAsFixed(2)}'),
                  12.h.ph,
                  Divider(color: Colors.grey[300]),
                  8.h.ph,
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.yellow1,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        Text(
                          '${order.currencySymbol}${order.totalPayable.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Pay Now Button (prominent, like web)
            if (showPayButton) ...[
              20.h.ph,
              CustomButton(
                text: 'Pay Now - ${order.currencySymbol}${order.totalPayable.toStringAsFixed(2)}',
                btnHeight: 56,
                radius: 12.r,
                color: AppColors.yellow3,
                textColor: AppColors.black,
                onPressed: () => _handlePayNow(order),
              ),
            ],
            
            24.h.ph,
            
            // Product Image
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
            
            // Picker Info
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
                        Icon(Icons.star, color: AppColors.starColor, size: 15.sp),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            43.h.ph,
            
            // Delivery Status Section (disabled until payment)
            Opacity(
              opacity: order.isPaid ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !order.isPaid,
                child: Column(
                  children: [
                    Text(
                      AppStrings.orderMarkedasDelivered.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (!order.isPaid) ...[
                      8.h.ph,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          'Complete payment first to mark delivery status',
                          style: TextStyle(fontSize: 11.sp, color: Colors.red[700], fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
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
                  ],
                ),
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
            
            // Rate & Review Section (disabled until payment)
            Opacity(
              opacity: order.isPaid ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !order.isPaid,
                child: Container(
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
                        children: List.generate(5, (index) => 
                          Icon(Icons.star, size: 32, color: AppColors.starsColor),
                        ),
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
                                RadioText(text: '\$5', fontSize: 12.sp, isSelected: true, onChanged: () {}),
                                RadioText(text: '\$10', fontSize: 12.sp, isSelected: false, onChanged: () {}),
                                RadioText(text: 'Custom amount', fontSize: 12.sp, isSelected: false, onChanged: () {}),
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
                        onPressed: order.isPaid ? () {
                          Navigator.pushNamed(context, AppRoutes.orderAcceptedScreen);
                        } : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            30.h.ph,
          ],
        ),
      ),
    );
  }

  Widget _feeRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CANCELLED':
        return Colors.red;
      case 'DELIVERED':
      case 'COMPLETED':
        return Colors.green;
      case 'ACCEPTED':
        return Colors.blue;
      default:
        return Colors.amber[700]!;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'FAILED':
        return Colors.red;
      case 'REFUNDED':
        return Colors.orange;
      default:
        return Colors.amber[700]!;
    }
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
