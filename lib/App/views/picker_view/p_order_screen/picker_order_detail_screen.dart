import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/order_detail_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class PickerOrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const PickerOrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<PickerOrderDetailScreen> createState() =>
      _PickerOrderDetailScreenState();
}

class _PickerOrderDetailScreenState
    extends ConsumerState<PickerOrderDetailScreen> {
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

    // Listen for success/error messages
    ref.listen<OrderDetailState>(orderDetailProvider, (prev, next) {
      if (next.successMessage != null &&
          next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.green1E,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        );
        ref.read(orderDetailProvider.notifier).clearMessages();
      }
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red57,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        );
        ref.read(orderDetailProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: ProfileAppBar(
        leadingIcon: true,
        title: AppStrings.orderDetails,
        appBarColor: AppColors.white,
        titleColor: AppColors.red3,
        backBtnColor: AppColors.white,
        backIconColor: AppColors.red3,
        fontSize: 20.sp,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(OrderDetailState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.red3),
      );
    }

    if (state.errorMessage != null && state.order == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: AppColors.red57),
              16.h.ph,
              Text(state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.labelGray)),
              24.h.ph,
              SizedBox(
                width: 160.w,
                child: CustomButton(
                  text: 'Retry',
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          16.h.ph,
          // ── Status Header ──
          _StatusHeader(order: order),
          16.h.ph,
          // ── Route Card ──
          _RouteCard(order: order),
          16.h.ph,
          // ── Orderer Card ──
          _OrdererInfoCard(orderer: order.orderer),
          16.h.ph,
          // ── Items List Card ──
          _ItemsCard(order: order),
          16.h.ph,
          // ── Fee Breakdown Card ──
          _FeeBreakdownCard(order: order),
          // ── Special Notes Card ──
          if (order.specialNotes != null &&
              order.specialNotes!.isNotEmpty) ...[
            16.h.ph,
            _SpecialNotesCard(notes: order.specialNotes!),
          ],
          // ── Offers History Card ──
          if (order.offers.isNotEmpty) ...[
            16.h.ph,
            _OffersCard(offers: order.offers, currency: order.currencySymbol),
          ],
          24.h.ph,
          // ── Action Buttons ──
          _ActionButtons(
            order: order,
            isLoading: state.isActionLoading,
            onAccept: () =>
                ref.read(orderDetailProvider.notifier).acceptOrder(),
            onMarkDelivered: () =>
                ref.read(orderDetailProvider.notifier).markDelivered(),
          ),
          32.h.ph,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Status Header
// ─────────────────────────────────────────────────────────────
class _StatusHeader extends StatelessWidget {
  final OrderDetailModel order;
  const _StatusHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: _gradientColors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(_statusIcon, size: 36.sp, color: Colors.white),
            10.h.ph,
            Text(
              _statusTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: TextWeight.bold,
                  ),
            ),
            6.h.ph,
            Text(
              order.routeLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> get _gradientColors {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
      case 'ACCEPTED':
        return [const Color(0xFF1976D2), const Color(0xFF1565C0)];
      case 'DELIVERED':
        return [const Color(0xFF388E3C), const Color(0xFF2E7D32)];
      case 'CANCELLED':
        return [const Color(0xFFD32F2F), const Color(0xFFC62828)];
      default:
        return [AppColors.red2, AppColors.red3];
    }
  }

  IconData get _statusIcon {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return Icons.hourglass_top_rounded;
      case 'ACCEPTED':
        return Icons.handshake_rounded;
      case 'DELIVERED':
        return Icons.check_circle_rounded;
      case 'CANCELLED':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String get _statusTitle {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return 'Pending Order';
      case 'ACCEPTED':
        return 'Order Accepted';
      case 'DELIVERED':
        return 'Order Delivered';
      case 'CANCELLED':
        return 'Order Cancelled';
      default:
        return order.status;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Route Card
// ─────────────────────────────────────────────────────────────
class _RouteCard extends StatelessWidget {
  final OrderDetailModel order;
  const _RouteCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Row(
        children: [
          // Origin
          Expanded(
            child: Column(
              children: [
                Icon(Icons.flight_takeoff_rounded,
                    size: 24.sp, color: AppColors.red1),
                8.h.ph,
                Text(
                  order.originCity ?? '—',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.black,
                        fontWeight: TextWeight.semiBold,
                      ),
                  textAlign: TextAlign.center,
                ),
                4.h.ph,
                Text(
                  order.originCountry ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.labelGray),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Arrow
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                Icon(Icons.arrow_forward_rounded,
                    size: 22.sp, color: AppColors.red3),
                8.h.ph,
                if (order.waitingDays != null)
                  Text(
                    '~${order.waitingDays}d',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.labelGray),
                  ),
              ],
            ),
          ),
          // Destination
          Expanded(
            child: Column(
              children: [
                Icon(Icons.flight_land_rounded,
                    size: 24.sp, color: AppColors.green1E),
                8.h.ph,
                Text(
                  order.destinationCity ?? '—',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.black,
                        fontWeight: TextWeight.semiBold,
                      ),
                  textAlign: TextAlign.center,
                ),
                4.h.ph,
                Text(
                  order.destinationCountry ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.labelGray),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Orderer Info Card
// ─────────────────────────────────────────────────────────────
class _OrdererInfoCard extends StatelessWidget {
  final OrderUserModel? orderer;
  const _OrdererInfoCard({this.orderer});

  @override
  Widget build(BuildContext context) {
    if (orderer == null) return const SizedBox.shrink();

    final avatarUrl = orderer!.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return _SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundColor: AppColors.red1.withOpacity(0.1),
            backgroundImage:
                hasAvatar ? NetworkImage(AppUrls.resolveUrl(avatarUrl)) : null,
            child: hasAvatar
                ? null
                : Text(
                    orderer!.initials,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.red1,
                          fontWeight: TextWeight.bold,
                        ),
                  ),
          ),
          14.w.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JetOrderer',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.labelGray),
                ),
                4.h.ph,
                Text(
                  orderer!.fullName ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.black,
                        fontWeight: TextWeight.semiBold,
                      ),
                ),
              ],
            ),
          ),
          if (orderer!.rating > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.starsColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded,
                      size: 16.sp, color: AppColors.starsColor),
                  4.w.pw,
                  Text(
                    orderer!.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.starsColor,
                          fontWeight: TextWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Items Card
// ─────────────────────────────────────────────────────────────
class _ItemsCard extends StatelessWidget {
  final OrderDetailModel order;
  const _ItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 20.sp, color: AppColors.red3),
              8.w.pw,
              Text(
                'Items (${order.itemsCount})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.bold,
                    ),
              ),
            ],
          ),
          14.h.ph,
          ...order.items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (idx > 0)
                  Divider(
                      color: AppColors.lightGray.withOpacity(0.5),
                      height: 20.h),
                _OrderItemRow(
                    item: item, currencySymbol: order.currencySymbol),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItemDetail item;
  final String currencySymbol;
  const _OrderItemRow({required this.item, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        item.productImages != null && item.productImages!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    AppUrls.resolveUrl(item.productImages!.first),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                        Icons.image_outlined,
                        size: 24.sp,
                        color: AppColors.lightGray),
                  ),
                )
              : Icon(Icons.shopping_bag_outlined,
                  size: 24.sp, color: AppColors.labelGray),
        ),
        12.w.pw,
        // Item Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.itemName ?? 'Unknown Item',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.semiBold,
                    ),
              ),
              6.h.ph,
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.scale_rounded,
                    label: item.weight ?? '—',
                  ),
                  8.w.pw,
                  _InfoChip(
                    icon: Icons.close,
                    label: '${item.quantity}',
                  ),
                ],
              ),
              if (item.storeLink != null && item.storeLink!.isNotEmpty) ...[
                4.h.ph,
                Row(
                  children: [
                    Icon(Icons.store_rounded,
                        size: 13.sp, color: AppColors.labelGray),
                    4.w.pw,
                    Expanded(
                      child: Text(
                        item.storeLink!,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.labelGray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Price
        Text(
          '$currencySymbol${item.subtotal.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.red3,
                fontWeight: TextWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.labelGray),
          4.w.pw,
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.labelGray),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Fee Breakdown Card
// ─────────────────────────────────────────────────────────────
class _FeeBreakdownCard extends StatelessWidget {
  final OrderDetailModel order;
  const _FeeBreakdownCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = order.currencySymbol;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded,
                  size: 20.sp, color: AppColors.red3),
              8.w.pw,
              Text(
                AppStrings.freeBreakdown,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.bold,
                    ),
              ),
            ],
          ),
          16.h.ph,
          _FeeRow(
            label: AppStrings.itemCost,
            value: '$cs${order.itemsCost.toStringAsFixed(2)}',
          ),
          10.h.ph,
          _FeeRow(
            label: AppStrings.reward,
            value: '$cs${order.rewardAmount.toStringAsFixed(2)}',
            valueColor: AppColors.green1E,
          ),
          if (order.acceptedCounterOfferAmount != null) ...[
            10.h.ph,
            _FeeRow(
              label: 'Counter Offer',
              value:
                  '$cs${order.acceptedCounterOfferAmount!.toStringAsFixed(2)}',
              valueColor: AppColors.starsColor,
            ),
          ],
          Divider(
            color: AppColors.lightGray.withOpacity(0.5),
            height: 24.h,
          ),
          _FeeRow(
            label: AppStrings.total,
            value: '$cs${order.totalCost.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  const _FeeRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isBold ? AppColors.black : AppColors.labelGray,
                fontWeight: isBold ? TextWeight.bold : TextWeight.regular,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? (isBold ? AppColors.red3 : AppColors.black),
                fontWeight: isBold ? TextWeight.bold : TextWeight.semiBold,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Special Notes Card
// ─────────────────────────────────────────────────────────────
class _SpecialNotesCard extends StatelessWidget {
  final String notes;
  const _SpecialNotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note_alt_outlined,
                  size: 20.sp, color: AppColors.red3),
              8.w.pw,
              Text(
                AppStrings.specialNotes,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.bold,
                    ),
              ),
            ],
          ),
          12.h.ph,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              notes,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Offers History Card
// ─────────────────────────────────────────────────────────────
class _OffersCard extends StatelessWidget {
  final List<OrderOfferModel> offers;
  final String currency;
  const _OffersCard({required this.offers, required this.currency});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_rounded,
                  size: 20.sp, color: AppColors.red3),
              8.w.pw,
              Text(
                'Offer History',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.bold,
                    ),
              ),
            ],
          ),
          14.h.ph,
          ...offers.map((offer) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _offerStatusColor(offer.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    10.w.pw,
                    Expanded(
                      child: Text(
                        offer.offerType ?? 'Offer',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.labelGray),
                      ),
                    ),
                    Text(
                      '$currency${offer.offerAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.black,
                            fontWeight: TextWeight.semiBold,
                          ),
                    ),
                    8.w.pw,
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: _offerStatusColor(offer.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        offer.status ?? '—',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _offerStatusColor(offer.status),
                              fontWeight: TextWeight.medium,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Color _offerStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACCEPTED':
        return AppColors.green1E;
      case 'REJECTED':
        return AppColors.red57;
      case 'PENDING':
        return const Color(0xFFFF9800);
      default:
        return AppColors.labelGray;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Action Buttons
// ─────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final OrderDetailModel order;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onMarkDelivered;

  const _ActionButtons({
    required this.order,
    required this.isLoading,
    required this.onAccept,
    required this.onMarkDelivered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          if (order.status.toUpperCase() == 'PENDING')
            CustomButton(
              text: AppStrings.acceptDelivery,
              onPressed: isLoading ? null : onAccept,
              isLoading: isLoading,
              btnHeight: 50.h,
              radius: 12.r,
            ),
          if (order.status.toUpperCase() == 'ACCEPTED') ...[
            CustomButton(
              text: AppStrings.markAsDelivered,
              onPressed: isLoading ? null : onMarkDelivered,
              isLoading: isLoading,
              btnHeight: 50.h,
              radius: 12.r,
            ),
            12.h.ph,
            if (order.chatRoomId != null)
              CustomButton(
                text: AppStrings.startChat,
                onPressed: () {
                  // Navigate to chat conversation
                  context.push(AppRoutes.conversationScreen);
                },
                color: AppColors.white,
                textColor: AppColors.red3,
                borderColor: AppColors.red3,
                btnHeight: 50.h,
                radius: 12.r,
              ),
          ],
          if (order.status.toUpperCase() == 'DELIVERED')
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.green1E.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColors.green1E.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.green1E, size: 22.sp),
                  10.w.pw,
                  Text(
                    AppStrings.deliveryCompleted,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.green1E,
                          fontWeight: TextWeight.semiBold,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reusable Section Card Wrapper
// ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
