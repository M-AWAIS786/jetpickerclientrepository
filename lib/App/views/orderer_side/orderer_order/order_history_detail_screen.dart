import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/view_model/order/order_detail_view_model.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';

class OrderHistorydetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderHistorydetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderHistorydetailScreen> createState() =>
      _OrderHistorydetailScreenState();
}

class _OrderHistorydetailScreenState
    extends ConsumerState<OrderHistorydetailScreen> {
  // Delivery status
  bool _deliveryConfirmed = false;
  bool _issueReported = false;

  // Review & tip
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  String _selectedTip = '5';
  final TextEditingController _customTipController = TextEditingController();
  bool _reviewSubmitted = false;

  // Image carousel
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderDetailProvider.notifier).fetchOrderDetail(widget.orderId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _customTipController.dispose();
    super.dispose();
  }

  // ── Fee Calculations (matching React) ──
  double _getItemsTotal(OrderDetailModel order) =>
      order.itemsCost;

  double _getRewardAmount(OrderDetailModel order) =>
      order.rewardAmount;

  double _getCounterOfferAmount(OrderDetailModel order) =>
      order.acceptedCounterOfferAmount ?? 0;

  double _getSubtotal(OrderDetailModel order) {
    final counter = _getCounterOfferAmount(order);
    if (counter > 0) return _getItemsTotal(order) + counter;
    return _getItemsTotal(order) + _getRewardAmount(order);
  }

  double _getJetPickerFee(OrderDetailModel order) =>
      _getSubtotal(order) * 0.065;

  double _getPaymentProcessingFee(OrderDetailModel order) =>
      _getSubtotal(order) * 0.04;

  double _getTotal(OrderDetailModel order) =>
      _getSubtotal(order) + _getJetPickerFee(order) + _getPaymentProcessingFee(order);

  String _formatPrice(double price, String symbol) =>
      '$symbol${price.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailProvider);

    // Listen for success/error snackbars
    ref.listen<OrderDetailState>(orderDetailProvider, (prev, next) {
      if (next.successMessage != null &&
          next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.green1E,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(orderDetailProvider.notifier).clearMessages();
      }
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage &&
          next.order != null) {
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
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
        title: 'Order Details',
        titleColor: AppColors.black,
        fontSize: 16.sp,
        fontWeight: TextWeight.semiBold,
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, OrderDetailState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.yellow3),
      );
    }

    if (state.errorMessage != null && state.order == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: AppColors.red57),
              16.h.ph,
              Text(
                'Failed to load order',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              8.h.ph,
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.labelGray, fontSize: 13.sp),
              ),
              24.h.ph,
              SizedBox(
                width: 160.w,
                child: CustomButton(
                  text: 'Retry',
                  color: AppColors.yellow3,
                  textColor: AppColors.black,
                  onPressed: () => ref
                      .read(orderDetailProvider.notifier)
                      .fetchOrderDetail(widget.orderId),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final order = state.order;
    if (order == null) return const SizedBox.shrink();

    final sym = order.currencySymbol;
    final status = order.status.toUpperCase();
    final hasPicker = order.picker != null && order.picker!.id.isNotEmpty;
    final isCancelled = status == 'CANCELLED';
    final isDelivered = status == 'DELIVERED';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.ph,

            // ═══════════════════════════════════════════
            // 1. ROUTE HEADER + STATUS BADGE
            // ═══════════════════════════════════════════
            _buildRouteHeader(context, order, status, isCancelled),
            20.h.ph,

            // ═══════════════════════════════════════════
            // 2. ORDER SUMMARY CARD (items list)
            // ═══════════════════════════════════════════
            _buildOrderSummaryCard(context, order, sym),
            16.h.ph,

            // ═══════════════════════════════════════════
            // 3. FEE BREAKDOWN CARD
            // ═══════════════════════════════════════════
            _buildFeeBreakdownCard(context, order, sym),
            16.h.ph,

            // ═══════════════════════════════════════════
            // 4. PRODUCT IMAGE + PICKER INFO
            // ═══════════════════════════════════════════
            _buildProductAndPickerSection(context, order, hasPicker),
            16.h.ph,

            // ═══════════════════════════════════════════
            // 5. DELIVERY STATUS SECTION (only if picker assigned & not cancelled)
            // ═══════════════════════════════════════════
            if (hasPicker && !isCancelled)
              _buildDeliveryStatusSection(context, order, state, isDelivered),

            // ═══════════════════════════════════════════
            // 6. RATE & TIP SECTION (only if picker assigned & not cancelled)
            if (hasPicker && !isCancelled)
              _buildRateAndTipSection(context, order, state),

            40.h.ph,
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 1. ROUTE HEADER + STATUS BADGE
  // ─────────────────────────────────────────
  Widget _buildRouteHeader(
      BuildContext context, OrderDetailModel order, String status, bool isCancelled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${order.originCity ?? order.originCountry ?? ''}, ${order.originCountry ?? ''} - '
          '${order.destinationCity ?? order.destinationCountry ?? ''}, ${order.destinationCountry ?? ''}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: TextWeight.bold,
                color: AppColors.black,
                fontSize: 18.sp,
              ),
        ),
        12.h.ph,
        Row(
          children: [
            _buildStatusBadge(context, status),
            if (isCancelled) ...[
              12.w.pw,
              Expanded(
                child: Text(
                  'This order has been cancelled and cannot be proceeded further.',
                  style: TextStyle(color: AppColors.red57, fontSize: 11.sp),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case 'CANCELLED':
        bgColor = AppColors.red57.withOpacity(0.12);
        textColor = AppColors.red57;
        break;
      case 'DELIVERED':
        bgColor = AppColors.green1E.withOpacity(0.12);
        textColor = AppColors.green1E;
        break;
      case 'ACCEPTED':
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        break;
      default: // PENDING
        bgColor = AppColors.yellow3.withOpacity(0.25);
        textColor = const Color(0xFFB8860B);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        status[0] + status.substring(1).toLowerCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: TextWeight.semiBold,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 2. ORDER SUMMARY CARD
  // ─────────────────────────────────────────
  Widget _buildOrderSummaryCard(
      BuildContext context, OrderDetailModel order, String sym) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route label at top
          Center(
            child: Text(
              '${order.originCity ?? ''}, ${order.originCountry ?? ''} to '
              '${order.destinationCity ?? ''}, ${order.destinationCountry ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: TextWeight.semiBold,
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
          ),
          if (order.items.isNotEmpty) ...[
            16.h.ph,
            Divider(color: AppColors.greyDD, height: 1),
            16.h.ph,
            // Items list
            ...order.items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: idx < order.items.length - 1 ? 10.h : 0),
                child: _buildItemCard(context, item, sym),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, OrderItemDetail item, String sym) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          // Name + Qty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemName ?? '-',
                  style: TextStyle(
                    fontWeight: TextWeight.semiBold,
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Qty: ${item.quantity}',
                style: TextStyle(
                  color: AppColors.labelGray,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          8.h.ph,
          // Store link
          if (item.storeLink != null && item.storeLink!.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Store:',
                    style: TextStyle(
                        color: AppColors.labelGray, fontSize: 13.sp)),
                Expanded(
                  child: Text(
                    item.storeLink!,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColors.red2,
                      fontSize: 13.sp,
                      fontWeight: TextWeight.semiBold,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            6.h.ph,
          ],
          // Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight:',
                  style:
                      TextStyle(color: AppColors.labelGray, fontSize: 13.sp)),
              Text(
                item.weight ?? '-',
                style: TextStyle(color: AppColors.black, fontSize: 13.sp),
              ),
            ],
          ),
          6.h.ph,
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price:',
                  style:
                      TextStyle(color: AppColors.labelGray, fontSize: 13.sp)),
              Text(
                '$sym${item.price.toStringAsFixed(2)} × ${item.quantity}',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 13.sp,
                  fontWeight: TextWeight.semiBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 3. FEE BREAKDOWN CARD
  // ─────────────────────────────────────────
  Widget _buildFeeBreakdownCard(
      BuildContext context, OrderDetailModel order, String sym) {
    final counterOffer = _getCounterOfferAmount(order);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Cost Breakdown',
            style: TextStyle(
              fontWeight: TextWeight.bold,
              color: AppColors.black,
              fontSize: 15.sp,
            ),
          ),
          16.h.ph,
          _feeRow(context, 'Items Amount',
              _formatPrice(_getItemsTotal(order), sym)),
          10.h.ph,
          _feeRow(context, 'Reward Amount',
              _formatPrice(_getRewardAmount(order), sym)),

          // Counter offer (highlighted)
          if (counterOffer > 0) ...[
            10.h.ph,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.yellow1,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: _feeRow(context, 'Counter Offer Amount',
                  _formatPrice(counterOffer, sym),
                  isBold: true),
            ),
          ],

          10.h.ph,
          _feeRow(context, 'JetPicker Fee (6.5%)',
              _formatPrice(_getJetPickerFee(order), sym)),
          10.h.ph,
          _feeRow(context, 'Payment Processing (4%)',
              _formatPrice(_getPaymentProcessingFee(order), sym)),

          // Total
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: AppColors.greyDD, height: 1),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8D6),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: TextWeight.bold,
                    color: AppColors.black,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  _formatPrice(_getTotal(order), sym),
                  style: TextStyle(
                    fontWeight: TextWeight.bold,
                    color: AppColors.black,
                    fontSize: 17.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feeRow(BuildContext context, String label, String value,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.black : AppColors.labelGray,
            fontWeight: isBold ? TextWeight.semiBold : TextWeight.medium,
            fontSize: 13.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: TextWeight.semiBold,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 4. PRODUCT IMAGE + PICKER INFO
  // ─────────────────────────────────────────
  Widget _buildProductAndPickerSection(
      BuildContext context, OrderDetailModel order, bool hasPicker) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final images = firstItem?.productImages ?? [];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product image carousel
        _buildImageCarousel(images),
        16.w.pw,
        // Picker info or waiting message
        Expanded(
          child: hasPicker
              ? _buildPickerInfo(context, order.picker!)
              : _buildWaitingForPicker(context),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return Container(
      width: 140.w,
      height: 140.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: images.isNotEmpty
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    AppUrls.resolveUrl(images[_currentImageIndex]),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildNoImagePlaceholder(),
                  ),
                  // Forward arrow
                  if (images.length > 1)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentImageIndex =
                                (_currentImageIndex + 1) % images.length;
                          });
                        },
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: AppColors.yellow3,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(Icons.chevron_right,
                              color: AppColors.black, size: 20.sp),
                        ),
                      ),
                    ),
                  // Image counter
                  if (images.length > 1)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${images.length}',
                          style: TextStyle(
                              color: Colors.white, fontSize: 10.sp),
                        ),
                      ),
                    ),
                ],
              )
            : _buildNoImagePlaceholder(),
      ),
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 36.sp, color: AppColors.labelGray),
          4.h.ph,
          Text(
            'No image',
            style: TextStyle(
                color: AppColors.labelGray,
                fontSize: 11.sp,
                fontWeight: TextWeight.medium),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerInfo(BuildContext context, OrderUserModel picker) {
    final avatarUrl = picker.avatarUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'JetPicker',
          style: TextStyle(
            fontWeight: TextWeight.bold,
            color: AppColors.black,
            fontSize: 15.sp,
          ),
        ),
        10.h.ph,
        Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.lightGray,
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                  ? NetworkImage(AppUrls.resolveUrl(avatarUrl))
                  : null,
              child: avatarUrl == null || avatarUrl.isEmpty
                  ? Text(
                      picker.initials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelGray,
                        fontSize: 14.sp,
                      ),
                    )
                  : null,
            ),
            10.w.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  picker.fullName ?? 'Unknown',
                  style: TextStyle(
                    fontWeight: TextWeight.semiBold,
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star,
                        color: AppColors.starsColor, size: 15.sp),
                    4.w.pw,
                    Text(
                      picker.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: TextWeight.semiBold,
                        color: AppColors.black,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaitingForPicker(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8D6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.starsColor,
            ),
          ),
          12.w.pw,
          Expanded(
            child: Text(
              'Waiting for a picker to accept your order...',
              style: TextStyle(
                color: AppColors.labelGray,
                fontWeight: TextWeight.semiBold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 5. DELIVERY STATUS SECTION
  // ─────────────────────────────────────────
  Widget _buildDeliveryStatusSection(BuildContext context,
      OrderDetailModel order, OrderDetailState state, bool isDelivered) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER MARKED AS DELIVERED BY JETPICKER',
            style: TextStyle(
              fontWeight: TextWeight.bold,
              color: AppColors.black,
              fontSize: 13.sp,
            ),
          ),
          16.h.ph,

          // Delivery Completed toggle
          GestureDetector(
            onTap: isDelivered && !_deliveryConfirmed
                ? () async {
                    setState(() => _deliveryConfirmed = true);
                    await ref
                        .read(orderDetailProvider.notifier)
                        .confirmDeliveryOrderer();
                  }
                : null,
            child: Opacity(
              opacity: isDelivered && !_deliveryConfirmed ? 1.0 : 0.5,
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _deliveryConfirmed
                            ? AppColors.green1E
                            : AppColors.greyDD,
                        width: 2,
                      ),
                    ),
                    child: _deliveryConfirmed
                        ? Center(
                            child: Container(
                              width: 12.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.green1E,
                              ),
                            ),
                          )
                        : null,
                  ),
                  12.w.pw,
                  Text(
                    AppStrings.deliveryCompleted,
                    style: TextStyle(
                      fontWeight: TextWeight.semiBold,
                      color: AppColors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (state.isActionLoading && _deliveryConfirmed) ...[
                    8.w.pw,
                    SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.green1E),
                    ),
                  ],
                ],
              ),
            ),
          ),
          12.h.ph,

          // Issue with delivery toggle
          GestureDetector(
            onTap: isDelivered
                ? () {
                    setState(() => _issueReported = !_issueReported);
                    if (_issueReported) {
                      _showReportIssueDialog(context);
                    }
                  }
                : null,
            child: Opacity(
              opacity: isDelivered ? 1.0 : 0.5,
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _issueReported
                            ? AppColors.red57
                            : AppColors.greyDD,
                        width: 2,
                      ),
                    ),
                    child: _issueReported
                        ? Center(
                            child: Container(
                              width: 12.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.red57,
                              ),
                            ),
                          )
                        : null,
                  ),
                  12.w.pw,
                  Text(
                    AppStrings.issueWithDelivery,
                    style: TextStyle(
                      fontWeight: TextWeight.semiBold,
                      color: AppColors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          20.h.ph,

          // Remaining time banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.yellow1,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${AppStrings.remainingTime} 47h : 12m',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: TextWeight.semiBold,
                color: AppColors.black,
                fontSize: 13.sp,
              ),
            ),
          ),
          12.h.ph,

          // Confirmation message
          Text(
            AppStrings.confirmOrder,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 6. RATE & TIP SECTION
  // ─────────────────────────────────────────
  Widget _buildRateAndTipSection(
      BuildContext context, OrderDetailModel order, OrderDetailState state) {
    final pickerName = order.picker?.fullName ?? 'JetPicker';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFACD),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'Rate your experience with $pickerName',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: TextWeight.bold,
              color: AppColors.black,
              fontSize: 16.sp,
            ),
          ),
          20.h.ph,

          // ── Interactive Star Rating ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starNum = index + 1;
              return GestureDetector(
                onTap: _reviewSubmitted
                    ? null
                    : () => setState(() => _rating = starNum),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    Icons.star,
                    size: 36.sp,
                    color: starNum <= _rating
                        ? AppColors.starsColor
                        : AppColors.greyDD,
                  ),
                ),
              );
            }),
          ),
          24.h.ph,

          // ── Comment Box ──
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              enabled: !_reviewSubmitted,
              style: TextStyle(color: AppColors.black, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: AppStrings.writeYourComment,
                hintStyle:
                    TextStyle(color: AppColors.labelGray, fontSize: 14.sp),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14.w),
              ),
            ),
          ),
          20.h.ph,

          // ── Tip Option Card ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tipOption,
                  style: TextStyle(
                    fontWeight: TextWeight.semiBold,
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                ),
                16.h.ph,
                Row(
                  children: [
                    _buildTipOption('\$5', '5'),
                    16.w.pw,
                    _buildTipOption('\$10', '10'),
                    16.w.pw,
                    _buildTipOption('Custom', 'custom'),
                  ],
                ),
                // Custom tip input
                if (_selectedTip == 'custom') ...[
                  14.h.ph,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyDD),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _customTipController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      enabled: !_reviewSubmitted,
                      style:
                          TextStyle(color: AppColors.black, fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: 'Enter custom amount',
                        hintStyle: TextStyle(
                            color: AppColors.labelGray, fontSize: 13.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 12.h),
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          color: AppColors.black,
                          fontWeight: TextWeight.semiBold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          20.h.ph,

          // ── Submit Button ──
          if (_reviewSubmitted)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.green1E.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.green1E.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle,
                      color: AppColors.green1E, size: 20.sp),
                  8.w.pw,
                  Text(
                    'Review & tip submitted successfully!',
                    style: TextStyle(
                      color: AppColors.green1E,
                      fontWeight: TextWeight.semiBold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            )
          else
            CustomButton(
              text: state.isActionLoading ? 'Submitting...' : AppStrings.submit,
              color: AppColors.yellow3,
              textColor: AppColors.black,
              isLoading: state.isActionLoading,
              radius: 10.r,
              onPressed: (state.isActionLoading || _rating == 0)
                  ? null
                  : () => _handleSubmitReviewAndTip(order),
            ),

          if (_rating == 0 && !_reviewSubmitted) ...[
            8.h.ph,
            Text(
              'Please select a rating to submit',
              style: TextStyle(
                color: AppColors.labelGray,
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipOption(String label, String value) {
    final isSelected = _selectedTip == value;
    return Expanded(
      child: GestureDetector(
        onTap: _reviewSubmitted
            ? null
            : () => setState(() => _selectedTip = value),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.green1E : AppColors.greyDD,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green1E,
                        ),
                      ),
                    )
                  : null,
            ),
            6.w.pw,
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: TextWeight.semiBold,
                  color: AppColors.black,
                  fontSize: 13.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // ACTION HANDLERS
  // ─────────────────────────────────────────

  Future<void> _handleSubmitReviewAndTip(OrderDetailModel order) async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: AppColors.red57,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final vm = ref.read(orderDetailProvider.notifier);
    final revieweeId = order.picker?.id ?? '';
    final comment = _commentController.text.trim();

    // Submit review
    await vm.submitReviewOrderer(
      rating: _rating,
      comment: comment,
      revieweeId: revieweeId,
    );

    // Submit tip
    double tipAmount = 0;
    if (_selectedTip == 'custom') {
      tipAmount = double.tryParse(_customTipController.text.trim()) ?? 0;
    } else {
      tipAmount = double.tryParse(_selectedTip) ?? 0;
    }

    if (tipAmount > 0) {
      await vm.submitTipOrderer(tipAmount);
    }

    setState(() => _reviewSubmitted = true);

    // Reset after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _reviewSubmitted = false;
          _rating = 0;
          _commentController.clear();
          _selectedTip = '5';
          _customTipController.clear();
        });
      }
    });
  }

  void _showReportIssueDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Report Issue',
          style: TextStyle(fontWeight: TextWeight.bold, fontSize: 18.sp),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Describe the issue with your delivery',
              style: TextStyle(color: AppColors.labelGray, fontSize: 13.sp),
            ),
            12.h.ph,
            TextField(
              controller: controller,
              maxLines: 4,
              style: TextStyle(color: AppColors.black, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                hintStyle:
                    TextStyle(color: AppColors.labelGray, fontSize: 13.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColors.greyDD),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                      const BorderSide(color: AppColors.yellow3, width: 1.5),
                ),
                contentPadding: EdgeInsets.all(14.w),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _issueReported = false);
            },
            child: Text('Cancel',
                style: TextStyle(color: AppColors.labelGray, fontSize: 14.sp)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow3,
              foregroundColor: AppColors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () async {
              final reason = controller.text.trim();
              if (reason.isEmpty) return;
              Navigator.of(ctx).pop();
              await ref
                  .read(orderDetailProvider.notifier)
                  .reportIssueOrderer(reason);
            },
            child: Text(AppStrings.submit,
                style: TextStyle(fontWeight: TextWeight.semiBold)),
          ),
        ],
      ),
    );
  }
}
