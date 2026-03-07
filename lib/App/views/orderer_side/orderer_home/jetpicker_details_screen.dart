import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';
import 'package:jet_picks_app/App/view_model/order/orderer_dashboard_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class JetPickerDetailsScreen extends ConsumerWidget {
  final int pickerIndex;

  const JetPickerDetailsScreen({super.key, required this.pickerIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashState = ref.watch(ordererDashboardProvider);

    if (pickerIndex < 0 || pickerIndex >= dashState.pickers.length) {
      return Scaffold(
        appBar: ProfileAppBar(
          leadingIcon: true,
          appBarColor: AppColors.white,
          backBtnColor: AppColors.yellow3,
          backIconColor: AppColors.black,
        ),
        body: const Center(child: Text('Picker not found')),
      );
    }

    final picker = dashState.pickers[pickerIndex];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
        title: 'Picker Details',
        titleColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar ──
            CircleAvatar(
              radius: 44.r,
              backgroundColor: AppColors.lightGray,
              backgroundImage: picker.pickerAvatarUrl != null
                  ? NetworkImage(AppUrls.resolveUrl(picker.pickerAvatarUrl))
                  : null,
              child: picker.pickerAvatarUrl == null
                  ? Text(
                      picker.initials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelGray,
                        fontSize: 28.sp,
                      ),
                    )
                  : null,
            ),
            12.h.ph,

            // ── Name ──
            Text(
              picker.pickerName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: TextWeight.bold,
                    color: AppColors.black,
                  ),
            ),
            6.h.ph,

            // ── Rating ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  picker.pickerRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: TextWeight.bold,
                    color: AppColors.black,
                    fontSize: 16.sp,
                  ),
                ),
                4.w.pw,
                Icon(Icons.star, color: AppColors.starColor, size: 18.sp),
                if (picker.completedDeliveries > 0) ...[
                  12.w.pw,
                  Text(
                    '${picker.completedDeliveries} deliveries',
                    style: TextStyle(
                      color: AppColors.labelGray,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ],
            ),
            24.h.ph,

            // ── Route Card ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8D6),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                children: [
                  Text(
                    'Travel Route',
                    style: TextStyle(
                      fontWeight: TextWeight.bold,
                      color: AppColors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  12.h.ph,
                  Row(
                    children: [
                      Expanded(
                        child: _routeColumn(
                          context,
                          'From',
                          picker.departureCountry,
                          picker.departureCity,
                          picker.departureDate,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Icon(Icons.flight_takeoff,
                            color: AppColors.black, size: 24.sp),
                      ),
                      Expanded(
                        child: _routeColumn(
                          context,
                          'To',
                          picker.arrivalCountry,
                          picker.arrivalCity,
                          picker.arrivalDate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.h.ph,

            // ── Details Card ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Column(
                children: [
                  _detailRow(context, 'Available Space',
                      '${picker.luggageWeightCapacity.toStringAsFixed(1)} kg'),
                  12.h.ph,
                  _detailRow(context, 'Departure',
                      _formatDate(picker.departureDate)),
                  12.h.ph,
                  _detailRow(
                      context, 'Arrival', _formatDate(picker.arrivalDate)),
                ],
              ),
            ),
            40.h.ph,

            // ── Order with this Picker ──
            CustomButton(
              text: 'Order with this Picker',
              color: AppColors.yellow3,
              textColor: AppColors.black,
              onPressed: () {
                ref.read(createOrderProvider.notifier).reset();
                ref.read(createOrderProvider.notifier).initWithPickerRoute(
                  {
                    'departure_country': picker.departureCountry,
                    'departure_city': picker.departureCity,
                    'arrival_country': picker.arrivalCountry,
                    'arrival_city': picker.arrivalCity,
                  },
                  picker.pickerId,
                );
                context.push(AppRoutes.deliveryFlowScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeColumn(BuildContext context, String label, String country,
      String city, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.labelGray,
            fontSize: 11.sp,
            fontWeight: TextWeight.medium,
          ),
        ),
        4.h.ph,
        Text(
          country,
          style: TextStyle(
            fontWeight: TextWeight.bold,
            color: AppColors.black,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        if (city.isNotEmpty) ...[
          2.h.ph,
          Text(
            city,
            style: TextStyle(
              color: AppColors.labelGray,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        4.h.ph,
        Text(
          _formatDate(date),
          style: TextStyle(
            color: AppColors.labelGray,
            fontSize: 12.sp,
            fontWeight: TextWeight.medium,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.labelGray,
            fontSize: 14.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: TextWeight.semiBold,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
