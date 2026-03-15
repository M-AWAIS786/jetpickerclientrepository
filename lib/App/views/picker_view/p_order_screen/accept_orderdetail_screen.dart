import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/views/picker_view/p_order_screen/picker_order_detail_screen.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

/// Accept Order Detail screen - when orderId is provided, shows the full
/// PickerOrderDetailScreen with Mark as Delivered functionality.
/// When no orderId, shows a fallback directing user to the Orders tab.
class AcceptOrderdetailScreen extends StatelessWidget {
  final String orderId;

  const AcceptOrderdetailScreen({super.key, this.orderId = ''});

  @override
  Widget build(BuildContext context) {
    if (orderId.isNotEmpty) {
      return PickerOrderDetailScreen(orderId: orderId);
    }

    return Scaffold(
      appBar: ProfileAppBar(leadingIcon: true, appBarColor: AppColors.white),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 72.sp, color: AppColors.lightGray),
              24.h.ph,
              Text(
                'View Order Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              12.h.ph,
              Text(
                'Select an order from your Orders tab to view details and mark as delivered.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.labelGray,
                    ),
                textAlign: TextAlign.center,
              ),
              32.h.ph,
              CustomButton(
                text: 'Go to Orders',
                color: AppColors.red3,
                textColor: Colors.white,
                onPressed: () => context.go(AppRoutes.pickerBottomBarScreen),
                btnHeight: 48.h,
                radius: 12.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
