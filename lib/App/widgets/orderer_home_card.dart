import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/models/orderer_discovery/orderer_discovery_model.dart';

import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../routes/app_routes.dart';



class OrdererHomeCard extends StatelessWidget {
  final OrderDiscovery order;

  const OrdererHomeCard({
    super.key,
    required this.order,
  });

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return '?';
    final names = fullName.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 10.w, top: 10.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.lightGray,
                  child: Center(
                    child: Text(
                      _getInitials(order.orderer.fullName),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                8.w.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderer.fullName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          order.orderer.rating.toString(),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.black,
                          ),
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 17.h),
            child: Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(color: AppColors.yellow1),
              child: Center(
                child: Text(
                  'From ${order.originCity} - ${order.destinationCity}\n'
                  '${_formatDate(order.earliestDeliveryDate)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Items: ${order.itemsCount}    Reward: ${order.rewardAmount} ${order.currency}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          10.h.ph,
          CustomButton(
            text: 'View Details',
            color: AppColors.yellow3,
            textColor: AppColors.black,
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.deliveryFlowScreen,
                arguments: order, // Pass order data to details screen
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}