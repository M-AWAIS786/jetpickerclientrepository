import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/notification/global_notification_view_model.dart';

/// notification dropdown (Bell → list of all notifications).
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalNotificationProvider);

    // Merge all notification types into a single sorted list
    final allItems = <_NotificationItem>[
      ...state.newOrdersHistory.map((n) => _NotificationItem(
            id: n.id,
            type: _NotifType.newOrder,
            title: 'New Order: ${n.originCountry} → ${n.destinationCountry}',
            subtitle: 'From ${n.ordererName}  •  \$${n.rewardAmount.toStringAsFixed(0)} reward',
            isRead: n.isRead,
            timestamp: n.timestamp,
            orderId: n.orderId,
          )),
      ...state.acceptedOrdersHistory.map((n) => _NotificationItem(
            id: n.id,
            type: _NotifType.accepted,
            title: '${n.pickerName} accepted your order',
            subtitle: 'Tap to view order details',
            isRead: n.isRead,
            timestamp: n.timestamp,
            orderId: n.orderId,
          )),
      ...state.counterOffersHistory.map((n) => _NotificationItem(
            id: n.id,
            type: _NotifType.counterOffer,
            title: '${n.pickerName} sent a counter offer',
            subtitle: 'Tap to review the offer',
            isRead: n.isRead,
            timestamp: n.timestamp,
            orderId: n.orderId,
            offerId: n.offerId,
          )),
    ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FA),
        body: Column(
          children: [
            // ── App Bar ──
            _buildAppBar(context, state.unreadCount),

            // ── List ──
            Expanded(
              child: allItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      physics: const BouncingScrollPhysics(),
                      itemCount: allItems.length,
                      separatorBuilder: (_, __) => 8.h.ph,
                      itemBuilder: (context, index) {
                        final item = allItems[index];
                        return _NotificationTile(
                          item: item,
                          onTap: () => _handleTap(context, ref, item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App Bar ──
  Widget _buildAppBar(BuildContext context, int unreadCount) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18.sp, color: AppColors.black),
            ),
          ),
          16.w.pw,
          Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: TextWeight.bold,
                color: AppColors.black,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.red57.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '$unreadCount new',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: TextWeight.semiBold,
                  color: AppColors.red57,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 36.sp,
              color: AppColors.labelGray,
            ),
          ),
          16.h.ph,
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: TextWeight.semiBold,
              color: AppColors.black,
            ),
          ),
          6.h.ph,
          Text(
            'When you get notifications,\nthey\'ll show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.labelGray,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ── Handle tap — mark as read + navigate ──
  void _handleTap(
      BuildContext context, WidgetRef ref, _NotificationItem item) {
    final notifier = ref.read(globalNotificationProvider.notifier);

    switch (item.type) {
      case _NotifType.newOrder:
        notifier.markNewOrderRead(item.id);
        context.push(
          '${AppRoutes.pickerOrderDetailScreen}?orderId=${item.orderId}',
        );
        break;
      case _NotifType.accepted:
        notifier.markAcceptedOrderRead(item.id);
        context.push(
          '${AppRoutes.orderHistoryDetailScreen}?orderId=${item.orderId}',
        );
        break;
      case _NotifType.counterOffer:
        notifier.markCounterOfferRead(item.id);
        context.push(
          '${AppRoutes.counterOfferScreen}?orderId=${item.orderId}',
        );
        break;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Notification Tile — individual list item
// ─────────────────────────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.white : const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(16.r),
          border: item.isRead
              ? null
              : Border.all(
                  color: _accentColor.withOpacity(0.2),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(_icon, color: _accentColor, size: 22.sp),
            ),
            12.w.pw,

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: item.isRead
                                ? TextWeight.medium
                                : TextWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item.isRead) ...[
                        6.w.pw,
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: _accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  4.h.ph,
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.labelGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.h.ph,
                  Text(
                    _timeAgo(item.timestamp),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.labelGray.withOpacity(0.7),
                      fontWeight: TextWeight.medium,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right_rounded,
                size: 20.sp, color: AppColors.labelGray),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (item.type) {
      case _NotifType.newOrder:
        return Icons.local_shipping_rounded;
      case _NotifType.accepted:
        return Icons.check_circle_rounded;
      case _NotifType.counterOffer:
        return Icons.swap_horiz_rounded;
    }
  }

  Color get _accentColor {
    switch (item.type) {
      case _NotifType.newOrder:
        return const Color(0xFFB3002D);
      case _NotifType.accepted:
        return const Color(0xFF00B894);
      case _NotifType.counterOffer:
        return const Color(0xFF6C63FF);
    }
  }

  String _timeAgo(int timestampMs) {
    if (timestampMs == 0) return '';
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ─────────────────────────────────────────────────────────────
// Internal models
// ─────────────────────────────────────────────────────────────
enum _NotifType { newOrder, accepted, counterOffer }

class _NotificationItem {
  final String id;
  final _NotifType type;
  final String title;
  final String subtitle;
  final bool isRead;
  final int timestamp;
  final String orderId;
  final String? offerId;

  _NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isRead,
    required this.timestamp,
    required this.orderId,
    this.offerId,
  });
}
