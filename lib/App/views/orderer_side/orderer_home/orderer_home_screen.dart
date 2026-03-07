import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/orderer_dashboard_view_model.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrdererHomeScreen extends ConsumerStatefulWidget {
  const OrdererHomeScreen({super.key});

  @override
  ConsumerState<OrdererHomeScreen> createState() => _OrdererHomeScreenState();
}

class _OrdererHomeScreenState extends ConsumerState<OrdererHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordererDashboardProvider.notifier).fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordererDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        title: 'Dashboard',
        fontSize: 16.sp,
        fontWeight: TextWeight.semiBold,
        titleColor: AppColors.black,
        appBarColor: AppColors.white,
        bellColor: AppColors.black,
      ),
      body: RefreshIndicator(
        color: AppColors.yellow3,
        onRefresh: () =>
            ref.read(ordererDashboardProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.h.ph,
              // ── Hero Banner with "Create An Order" ──
              _buildHeroBanner(),
              20.h.ph,
              // ── Available Pickers Section ──
              Text(
                'Available JetPickers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.bold,
                    ),
              ),
              12.h.ph,
              _buildPickersSection(state),
              20.h.ph,
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Banner ──
  Widget _buildHeroBanner() {
    return GestureDetector(
      onTap: _navigateToCreateOrder,
      child: Container(
        height: 170.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                AppImages.jetPickerImage,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: SizedBox(
                      width: 180.w,
                      height: 42.h,
                      child: CustomButton(
                        text: 'Create An Order',
                        color: AppColors.yellow3,
                        textColor: AppColors.black,
                        radius: 25.r,
                        fontSize: 14.sp,
                        onPressed: _navigateToCreateOrder,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCreateOrder() {
    ref.read(createOrderProvider.notifier).reset();
    context.push(AppRoutes.deliveryFlowScreen);
  }

  // ── Pickers Section ──
  Widget _buildPickersSection(OrdererDashboardState state) {
    if (state.isLoading) {
      return SizedBox(
        height: 200.h,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.yellow3),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFFE69C)),
        ),
        child: Text(
          'No available pickers at the moment.\nTry creating an order to find matching pickers.',
          style: TextStyle(color: const Color(0xFF856404), fontSize: 13.sp),
        ),
      );
    }

    if (state.pickers.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFFE69C)),
        ),
        child: Text(
          'No available pickers at the moment.\nTry creating an order to find matching pickers.',
          style: TextStyle(color: const Color(0xFF856404), fontSize: 13.sp),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.pickers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _PickerCard(
            picker: state.pickers[index],
            onViewDetails: () => context.push(
              '${AppRoutes.jetPickerDetailsScreen}?pickerIndex=$index',
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Picker Card Widget
// ─────────────────────────────────────────────────────────────
class _PickerCard extends StatelessWidget {
  final AvailablePicker picker;
  final VoidCallback onViewDetails;

  const _PickerCard({required this.picker, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + Name + Rating ──
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.lightGray,
                backgroundImage: picker.pickerAvatarUrl != null
                    ? NetworkImage(
                        AppUrls.resolveUrl(picker.pickerAvatarUrl))
                    : null,
                child: picker.pickerAvatarUrl == null
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
                    picker.pickerName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: TextWeight.bold,
                          color: AppColors.black,
                        ),
                  ),
                  Row(
                    children: [
                      Text(
                        picker.pickerRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      2.w.pw,
                      Icon(Icons.star,
                          color: AppColors.starColor, size: 14.sp),
                    ],
                  ),
                ],
              ),
            ],
          ),
          10.h.ph,

          // ── Route Banner ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8D6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Text(
                  '${picker.departureCountry} → ${picker.arrivalCountry}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    fontSize: 13.sp,
                  ),
                ),
                4.h.ph,
                Text(
                  _formatDate(picker.departureDate),
                  style: TextStyle(
                    color: AppColors.labelGray,
                    fontSize: 12.sp,
                    fontWeight: TextWeight.medium,
                  ),
                ),
              ],
            ),
          ),
          10.h.ph,

          // ── Available space ──
          Text(
            'Available space: ${picker.luggageWeightCapacity.toStringAsFixed(0)}kg',
            style: TextStyle(
              fontWeight: TextWeight.semiBold,
              color: AppColors.black,
              fontSize: 12.sp,
            ),
          ),
          10.h.ph,

          // ── View Details Button ──
          CustomButton(
            text: 'View Details',
            color: AppColors.yellow3,
            textColor: AppColors.black,
            btnHeight: 40.h,
            radius: 8.r,
            fontSize: 14.sp,
            onPressed: onViewDetails,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}