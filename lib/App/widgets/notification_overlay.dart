import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/models/notification/notification_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/notification/global_notification_view_model.dart';

/// Overlay widget that shows notification modals on top of any screen.
/// Wrap your Scaffold body with this widget (typically inside bottom bar screens).
///
/// Matches the web frontend's notification modal behavior:
/// - Picker: "New Order Available!" modal
/// - Orderer: "Order Accepted!" and "Counter Offer Received!" modals
/// - Auto-dismiss after 5 seconds
/// - Tap to navigate + mark as read
class NotificationOverlay extends ConsumerWidget {
  final Widget child;

  const NotificationOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalNotificationProvider);

    return Stack(
      children: [
        child,

        // ── Picker: New Order Modal ──
        if (state.showNewOrderModal && state.newOrderNotification != null)
          _buildModalBackdrop(
            context,
            onDismiss: () => ref
                .read(globalNotificationProvider.notifier)
                .dismissNewOrderModal(),
            child: _NewOrderModal(
              notification: state.newOrderNotification!,
              onView: () {
                ref
                    .read(globalNotificationProvider.notifier)
                    .markNewOrderRead(state.newOrderNotification!.id);
                context.push(
                  '${AppRoutes.pickerOrderDetailScreen}?orderId=${state.newOrderNotification!.orderId}',
                );
              },
              onDismiss: () => ref
                  .read(globalNotificationProvider.notifier)
                  .dismissNewOrderModal(),
            ),
          ),

        // ── Orderer: Order Accepted Modal ──
        if (state.showAcceptedOrderModal &&
            state.acceptedOrderNotification != null)
          _buildModalBackdrop(
            context,
            onDismiss: () => ref
                .read(globalNotificationProvider.notifier)
                .dismissAcceptedOrderModal(),
            child: _AcceptedOrderModal(
              notification: state.acceptedOrderNotification!,
              onView: () {
                ref
                    .read(globalNotificationProvider.notifier)
                    .markAcceptedOrderRead(
                        state.acceptedOrderNotification!.id);
                context.push(
                  '${AppRoutes.orderAcceptedScreen}',
                );
              },
              onDismiss: () => ref
                  .read(globalNotificationProvider.notifier)
                  .dismissAcceptedOrderModal(),
            ),
          ),

        // ── Orderer: Counter Offer Modal ──
        if (state.showCounterOfferModal &&
            state.counterOfferNotification != null)
          _buildModalBackdrop(
            context,
            onDismiss: () => ref
                .read(globalNotificationProvider.notifier)
                .dismissCounterOfferModal(),
            child: _CounterOfferModal(
              notification: state.counterOfferNotification!,
              onView: () {
                ref
                    .read(globalNotificationProvider.notifier)
                    .markCounterOfferRead(
                        state.counterOfferNotification!.id);
                context.push(
                  '${AppRoutes.counterOfferScreen}?orderId=${state.counterOfferNotification!.orderId}',
                );
              },
              onDismiss: () => ref
                  .read(globalNotificationProvider.notifier)
                  .dismissCounterOfferModal(),
            ),
          ),
      ],
    );
  }

  Widget _buildModalBackdrop(
    BuildContext context, {
    required VoidCallback onDismiss,
    required Widget child,
  }) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {}, // prevent tap-through
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Picker: New Order Available Modal
// Matches web: bg-[#4D0013] icon circle, "New Order Available!" heading
// ─────────────────────────────────────────────────────────────
class _NewOrderModal extends StatelessWidget {
  final NewOrderNotification notification;
  final VoidCallback onView;
  final VoidCallback onDismiss;

  const _NewOrderModal({
    required this.notification,
    required this.onView,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon circle
          Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              color: Color(0xFF4D0013),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_shipping_rounded,
              color: AppColors.white,
              size: 32.sp,
            ),
          ),
          16.h.ph,

          Text(
            'New Order Available!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.black,
            ),
          ),
          8.h.ph,

          // Route
          Text(
            '${notification.originCountry} → ${notification.destinationCountry}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.labelGray,
            ),
          ),
          4.h.ph,

          // Orderer name
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13.sp, color: AppColors.labelGray),
              children: [
                const TextSpan(text: 'From '),
                TextSpan(
                  text: notification.ordererName,
                  style: TextStyle(
                    fontWeight: TextWeight.semiBold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          24.h.ph,

          // View Order button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D0013),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'View Order',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
          8.h.ph,

          // Dismiss button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Dismiss',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Orderer: Order Accepted Modal
// ─────────────────────────────────────────────────────────────
class _AcceptedOrderModal extends StatelessWidget {
  final AcceptedOrderNotification notification;
  final VoidCallback onView;
  final VoidCallback onDismiss;

  const _AcceptedOrderModal({
    required this.notification,
    required this.onView,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.yellow3,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.black,
              size: 32.sp,
            ),
          ),
          16.h.ph,

          Text(
            'Order Accepted!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.black,
            ),
          ),
          8.h.ph,

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 13.sp, color: AppColors.labelGray),
              children: [
                TextSpan(
                  text: notification.pickerName,
                  style: TextStyle(
                    fontWeight: TextWeight.semiBold,
                    color: AppColors.black,
                  ),
                ),
                const TextSpan(text: ' has accepted your order'),
              ],
            ),
          ),
          24.h.ph,

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow3,
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
          8.h.ph,

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Dismiss',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Orderer: Counter Offer Received Modal
// ─────────────────────────────────────────────────────────────
class _CounterOfferModal extends StatelessWidget {
  final CounterOfferNotification notification;
  final VoidCallback onView;
  final VoidCallback onDismiss;

  const _CounterOfferModal({
    required this.notification,
    required this.onView,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              color: Color(0xFF6C63FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.white,
              size: 32.sp,
            ),
          ),
          16.h.ph,

          Text(
            'Counter Offer Received!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.black,
            ),
          ),
          8.h.ph,

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 13.sp, color: AppColors.labelGray),
              children: [
                TextSpan(
                  text: notification.pickerName,
                  style: TextStyle(
                    fontWeight: TextWeight.semiBold,
                    color: AppColors.black,
                  ),
                ),
                const TextSpan(text: ' sent you a counter offer'),
              ],
            ),
          ),
          24.h.ph,

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'View Offer',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
          8.h.ph,

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Dismiss',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
