import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/models/order/orderer_order_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/orderer_orders_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class OrdererOrderScreen extends ConsumerStatefulWidget {
  const OrdererOrderScreen({super.key});

  @override
  ConsumerState<OrdererOrderScreen> createState() =>
      _OrdererOrderScreenState();
}

class _OrdererOrderScreenState extends ConsumerState<OrdererOrderScreen> {
  final tabs = ['All', 'Pending', 'Accepted', 'Delivered', 'Cancelled'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ordererOrdersProvider.notifier).fetchOrders();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(ordererOrdersProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordererOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: ProfileAppBar(
        title: 'My Orders',
        titleColor: AppColors.black,
        appBarColor: AppColors.yellow3,
        bellColor: AppColors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.h.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Order History',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: TextWeight.bold,
                  ),
            ),
          ),
          12.h.ph,
          _buildTabs(state.selectedTab),
          12.h.ph,
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  // ── Filter Tabs ──
  Widget _buildTabs(String selectedTab) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => 8.w.pw,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = selectedTab == tab;

          return GestureDetector(
            onTap: () =>
                ref.read(ordererOrdersProvider.notifier).selectTab(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.yellow3 : AppColors.white,
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: isSelected ? AppColors.yellow3 : AppColors.greyDD,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.yellow3.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  tab,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color:
                            isSelected ? AppColors.black : AppColors.labelGray,
                        fontWeight: isSelected
                            ? TextWeight.semiBold
                            : TextWeight.medium,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Body ──
  Widget _buildBody(OrdererOrdersState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.yellow3),
      );
    }

    if (state.errorMessage != null && state.orders.isEmpty) {
      return _buildErrorView(state.errorMessage!);
    }

    if (state.orders.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      color: AppColors.yellow3,
      onRefresh: () =>
          ref.read(ordererOrdersProvider.notifier).fetchOrders(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: state.orders.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.orders.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.yellow3),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _OrdererOrderCard(
              order: state.orders[index],
              isCancelling: state.isCancelling,
              onCancel: () => _showCancelDialog(state.orders[index]),
            ),
          );
        },
      ),
    );
  }

  // ── Empty ──
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 72.sp, color: AppColors.lightGray),
          16.h.ph,
          Text(
            'No orders found',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.labelGray),
          ),
          8.h.ph,
          Text(
            'Pull down to refresh',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.labelGray),
          ),
        ],
      ),
    );
  }

  // ── Error ──
  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.red57),
            16.h.ph,
            Text(
              'Something went wrong',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.black),
            ),
            8.h.ph,
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.labelGray),
            ),
            24.h.ph,
            SizedBox(
              width: 160.w,
              child: CustomButton(
                text: 'Retry',
                color: AppColors.yellow3,
                textColor: AppColors.black,
                onPressed: () =>
                    ref.read(ordererOrdersProvider.notifier).fetchOrders(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Cancel Order Dialog ──
  void _showCancelDialog(OrdererOrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) {
        final itemsCost = order.itemsCost;
        final rewardAmount = order.rewardAmount;
        final counterOffer = order.acceptedCounterOfferAmount;
        final baseAmount = itemsCost + rewardAmount;
        final jetPickerFee = baseAmount * 0.065;
        final paymentFee = baseAmount * 0.04;
        final symbol = order.currencySymbol;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          contentPadding: EdgeInsets.all(20.w),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Cancel Order',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: TextWeight.bold,
                        ),
                  ),
                  8.w.pw,
                  Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.labelGray, width: 2),
                    ),
                    child: Center(
                      child: Text('?',
                          style: TextStyle(
                              color: AppColors.labelGray,
                              fontWeight: TextWeight.bold,
                              fontSize: 12.sp)),
                    ),
                  ),
                ],
              ),
              16.h.ph,

              // Fee Breakdown
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _feeRow(ctx, 'Item Cost',
                        '$symbol${itemsCost.toStringAsFixed(2)}'),
                    8.h.ph,
                    _feeRow(ctx, 'Reward',
                        '$symbol${rewardAmount.toStringAsFixed(2)}'),
                    if (counterOffer != null && counterOffer > 0) ...[
                      8.h.ph,
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.yellow1,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: _feeRow(ctx, 'Counter Offer',
                            '$symbol${counterOffer.toStringAsFixed(2)}',
                            isBold: true),
                      ),
                    ],
                    8.h.ph,
                    _feeRow(ctx, 'JetPicker Fee (6.5%)',
                        '$symbol${jetPickerFee.toStringAsFixed(2)}'),
                    8.h.ph,
                    _feeRow(ctx, 'Payment Processing (4%)',
                        '$symbol${paymentFee.toStringAsFixed(2)}'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Divider(color: AppColors.greyDD),
                    ),
                    _feeRow(
                        ctx, 'Total', order.formattedTotalCost,
                        isBold: true, isLarge: true),
                  ],
                ),
              ),
              16.h.ph,

              Text(
                'Are you sure you want to cancel this order?',
                style: Theme.of(ctx)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.labelGray),
              ),
              20.h.ph,

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Keep Order',
                      color: AppColors.white,
                      textColor: AppColors.black,
                      borderColor: AppColors.greyDD,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  12.w.pw,
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final cancelling =
                            ref.watch(ordererOrdersProvider).isCancelling;
                        return CustomButton(
                          text: cancelling ? 'Cancelling...' : 'Cancel Order',
                          color: AppColors.yellow3,
                          textColor: AppColors.black,
                          isLoading: cancelling,
                          onPressed: cancelling
                              ? null
                              : () async {
                                  final success = await ref
                                      .read(ordererOrdersProvider.notifier)
                                      .cancelOrder(order.id);
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                  }
                                  if (!success && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to cancel order. Please try again.'),
                                      ),
                                    );
                                  }
                                },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

// ─────────────────────────────────────────────────────────────
// Orderer Order Card Widget
// ─────────────────────────────────────────────────────────────
class _OrdererOrderCard extends StatelessWidget {
  final OrdererOrderModel order;
  final bool isCancelling;
  final VoidCallback onCancel;

  const _OrdererOrderCard({
    required this.order,
    required this.isCancelling,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header: Route + Date + Status Badge ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.routeLabel,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: TextWeight.semiBold,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.h.ph,
                      Text(
                        _formatDate(order.createdAt),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.labelGray,
                                ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
          ),

          Divider(
            color: AppColors.lightGray.withOpacity(0.5),
            height: 24.h,
            indent: 16.w,
            endIndent: 16.w,
          ),

          // ── Items Count + Total Cost ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.yellow3, width: 2.5),
                  ),
                  child: Text(
                    '${order.itemsCount} ${order.itemsCount == 1 ? 'Item' : 'Items'}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.black,
                          fontWeight: TextWeight.semiBold,
                        ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Total Cost: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.labelGray,
                        ),
                    children: [
                      TextSpan(
                        text: order.formattedTotalCost,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: TextWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          14.h.ph,

          // ── View Order Details Button ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
            child: CustomButton(
              text: AppStrings.viewOrderDetails,
              color: AppColors.yellow3,
              textColor: AppColors.black,
              onPressed: () => context.push(
                '${AppRoutes.orderHistoryDetailScreen}?orderId=${order.id}',
              ),
              btnHeight: 42.h,
              radius: 10.r,
            ),
          ),

          // ── Start Chat Button (Accepted orders only) ──
          if (order.statusLower == 'accepted') ...[
            8.h.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppStrings.startChat,
                color: AppColors.yellow3,
                textColor: AppColors.black,
                onPressed: () {
                  // Navigate to orderer chat
                  context.push(AppRoutes.ordererConversationScreen);
                },
                btnHeight: 42.h,
                radius: 10.r,
              ),
            ),
          ],

          // ── Cancel Order Button (Pending orders only) ──
          if (order.statusLower == 'pending') ...[
            8.h.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppStrings.cancelOrder,
                color: AppColors.yellow3,
                textColor: AppColors.black,
                isLoading: isCancelling,
                onPressed: isCancelling ? null : onCancel,
                btnHeight: 42.h,
                radius: 10.r,
              ),
            ),
          ],

          14.h.ph,
        ],
      ),
    );
  }

  // ── Status Badge ──
  Widget _buildStatusBadge(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (order.status.toUpperCase()) {
      case 'PENDING':
        bgColor = AppColors.yellow3.withOpacity(0.2);
        textColor = const Color(0xFFB8860B);
        break;
      case 'ACCEPTED':
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        break;
      case 'DELIVERED':
        bgColor = AppColors.green1E.withOpacity(0.12);
        textColor = AppColors.green1E;
        break;
      case 'CANCELLED':
        bgColor = AppColors.red57.withOpacity(0.12);
        textColor = AppColors.red57;
        break;
      default:
        bgColor = AppColors.lightGray;
        textColor = AppColors.labelGray;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        order.status[0] + order.status.substring(1).toLowerCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: TextWeight.semiBold,
            ),
      ),
    );
  }

  // ── Format Date ──
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
