import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/picker_orders_view_model.dart';
import 'package:jet_picks_app/App/view_model/chat/chat_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final tabs = ['All', 'Pending', 'Accepted', 'Delivered', 'Cancelled'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pickerOrdersProvider.notifier).fetchOrders();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(pickerOrdersProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pickerOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: ProfileAppBar(
        title: AppStrings.orders,
        appBarColor: AppColors.white,
        bellColor: AppColors.red3,
      ),
      body: Column(
        children: [
          12.h.ph,
          _buildTabs(state.selectedTab),
          12.h.ph,
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

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
                ref.read(pickerOrdersProvider.notifier).selectTab(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.red3 : AppColors.white,
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: isSelected ? AppColors.red3 : AppColors.greyDD,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.red3.withOpacity(0.25),
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
                        color: isSelected
                            ? AppColors.white
                            : AppColors.labelGray,
                        fontWeight:
                            isSelected ? TextWeight.semiBold : TextWeight.medium,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(PickerOrdersState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.red3),
      );
    }

    if (state.errorMessage != null && state.orders.isEmpty) {
      return _buildErrorView(state.errorMessage!);
    }

    if (state.orders.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      color: AppColors.red3,
      onRefresh: () =>
          ref.read(pickerOrdersProvider.notifier).fetchOrders(refresh: true),
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
                child: CircularProgressIndicator(color: AppColors.red3),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _PickerOrderCard(order: state.orders[index]),
          );
        },
      ),
    );
  }

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
                onPressed: () =>
                    ref.read(pickerOrdersProvider.notifier).fetchOrders(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Picker Order Card Widget
// ─────────────────────────────────────────────────────────────
class _PickerOrderCard extends ConsumerWidget {
  final PickerOrderModel order;
  const _PickerOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startChatState = ref.watch(startChatProvider);

    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.pickerOrderDetailScreen}?orderId=${order.id}',
      ),
      child: Container(
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
            // ── Header: Avatar + Orderer Info + Status Badge ──
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
              child: Row(
                children: [
                  _buildAvatar(context),
                  10.w.pw,
                  Expanded(child: _buildOrdererInfo(context)),
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

            // ── Route ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(Icons.flight_takeoff_rounded,
                      size: 18.sp, color: AppColors.red1),
                  8.w.pw,
                  Expanded(
                    child: Text(
                      order.routeLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.black,
                            fontWeight: TextWeight.semiBold,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            12.h.ph,

            // ── Items strip + Cost info ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  _buildItemStrip(context),
                  16.w.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.itemsCount} ${order.itemsCount == 1 ? 'Item' : 'Items'}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.labelGray,
                                  ),
                        ),
                        4.h.ph,
                        Text(
                          'Reward: ${order.currencySymbol}${order.rewardAmount.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.red3,
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

            // ── View Order Details button ──
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
              child: CustomButton(
                text: AppStrings.viewOrderDetails,
                onPressed: () => context.push(
                  '${AppRoutes.pickerOrderDetailScreen}?orderId=${order.id}',
                ),
                btnHeight: 42.h,
                radius: 10.r,
              ),
            ),

            // ── Start Chat Button (Accepted orders only) ──
            if (order.status.toUpperCase() == 'ACCEPTED') ...[
              8.h.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomButton(
                  text: startChatState.isStarting
                      ? 'Starting Chat...'
                      : AppStrings.startChat,
                  isLoading: startChatState.isStarting,
                  onPressed: startChatState.isStarting
                      ? null
                      : () async {
                          final ordererId = order.ordererId ?? order.orderer?.id;
                          if (ordererId == null || ordererId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Orderer information not available')),
                            );
                            return;
                          }
                          final chatRoomId = await ref
                              .read(startChatProvider.notifier)
                              .startChat(
                                orderId: order.id,
                                pickerId: ordererId,
                              );
                          if (chatRoomId != null && context.mounted) {
                            context.push(
                              '${AppRoutes.conversationScreen}?chatRoomId=$chatRoomId',
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Failed to start chat. Please try again.')),
                            );
                          }
                        },
                  btnHeight: 42.h,
                  radius: 10.r,
                ),
              ),
            ],

            14.h.ph,
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = order.orderer?.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return CircleAvatar(
      radius: 22.r,
      backgroundColor: AppColors.red1.withOpacity(0.1),
      backgroundImage: hasAvatar
          ? NetworkImage(AppUrls.resolveUrl(avatarUrl))
          : null,
      child: hasAvatar
          ? null
          : Text(
              order.orderer?.initials ?? '?',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.red1,
                    fontWeight: TextWeight.bold,
                  ),
            ),
    );
  }

  Widget _buildOrdererInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.orderer?.fullName ?? 'JetOrderer',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black,
                fontWeight: TextWeight.semiBold,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        if (order.orderer != null && order.orderer!.rating > 0) ...[
          2.h.ph,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded,
                  size: 15.sp, color: AppColors.starsColor),
              3.w.pw,
              Text(
                order.orderer!.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.medium,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }

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

  Widget _buildItemStrip(BuildContext context) {
    final images = <String>[];
    for (final item in order.items) {
      if (item.productImages != null && item.productImages!.isNotEmpty) {
        images.add(item.productImages!.first);
      }
    }

    final showImages = images.take(3).toList();
    final remaining = order.itemsCount - showImages.length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.all(5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...showImages.map((img) => _ProductImage(imageUrl: img)),
          if (showImages.isEmpty)
            ...List.generate(
              order.itemsCount.clamp(0, 3),
              (_) => _ProductPlaceholder(),
            ),
          if (remaining > 0) _buildPlusItemsBadge(remaining, context),
        ],
      ),
    );
  }

  Widget _buildPlusItemsBadge(int count, BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.red3,
                fontWeight: TextWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Image.network(
          AppUrls.resolveUrl(imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.image_outlined, size: 20.sp, color: AppColors.lightGray),
        ),
      ),
    );
  }
}

class _ProductPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(Icons.shopping_bag_outlined,
          size: 20.sp, color: AppColors.labelGray),
    );
  }
}
