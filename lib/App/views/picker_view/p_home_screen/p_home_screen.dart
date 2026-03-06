import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/models/order/picker_dashboard_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/picker_dashboard_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(pickerDashboardProvider.notifier).fetchDashboard();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Refresh when app comes back to foreground (matches web visibilitychange)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(pickerDashboardProvider.notifier).fetchDashboard(silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pickerDashboardProvider);
    final journey = state.hasJourneys
        ? state.dashboardData!.travelJourneys.first
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      body: Column(
        children: [
          // ── App Bar with journey route ──
          ProfileAppBar(
            title: journey != null
                ? '${journey.routeLabel}  ${journey.formattedArrivalDate}'
                : AppStrings.home,
            titleColor: AppColors.white,
            fontSize: 13.sp,
            fontWeight: TextWeight.medium,
          ),

          // ── Body ──
          Expanded(
            child: _buildBody(state),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PickerDashboardState state) {
    if (state.isLoading && state.dashboardData == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.red3),
      );
    }

    if (state.errorMessage != null && state.dashboardData == null) {
      return _buildErrorView(state.errorMessage!);
    }

    return RefreshIndicator(
      color: AppColors.red3,
      onRefresh: () =>
          ref.read(pickerDashboardProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            16.h.ph,

            // ── Hero Banner with "Create New Journey" ──
            _HeroBanner(
              onCreateJourney: () =>
                  context.push(AppRoutes.travelDetailSetupScreen),
            ),

            20.h.ph,

            // ── Available Orders Grid ──
            if (state.hasOrders) ...[
              _buildOrdersGrid(state.dashboardData!.availableOrders.data),
            ] else ...[
              _buildEmptyView(),
            ],

            24.h.ph,
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersGrid(List<DashboardOrderModel> orders) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => 14.h.ph,
      itemBuilder: (context, index) {
        return _DashboardOrderCard(order: orders[index]);
      },
    );
  }

  Widget _buildEmptyView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 72.sp, color: AppColors.lightGray),
          16.h.ph,
          Text(
            'No orders available for your routes yet.',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.labelGray),
            textAlign: TextAlign.center,
          ),
          8.h.ph,
          Text(
            'Create a journey to see matching orders from orderers.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.labelGray),
            textAlign: TextAlign.center,
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
                onPressed: () => ref
                    .read(pickerDashboardProvider.notifier)
                    .fetchDashboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Hero Banner (matches web dashboard hero section)
// ─────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final VoidCallback onCreateJourney;
  const _HeroBanner({required this.onCreateJourney});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF4D0013), Color(0xFF800020)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.red3.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30.h,
            right: -30.w,
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -40.h,
            left: -20.w,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flight_rounded,
                  size: 40.sp,
                  color: AppColors.yellow3,
                ),
                12.h.ph,
                Text(
                  'Ready to earn while traveling?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: TextWeight.medium,
                      ),
                ),
                16.h.ph,
                GestureDetector(
                  onTap: onCreateJourney,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.red3,
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      AppStrings.createNewJourney,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: TextWeight.bold,
                          ),
                    ),
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
// Dashboard Order Card (matches web frontend order card)
// ─────────────────────────────────────────────────────────────
class _DashboardOrderCard extends StatelessWidget {
  final DashboardOrderModel order;
  const _DashboardOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          // ── Header: Avatar + Orderer Name + Rating ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Row(
              children: [
                _buildAvatar(context),
                10.w.pw,
                Expanded(child: _buildOrdererInfo(context)),
              ],
            ),
          ),

          12.h.ph,

          // ── Items strip + Cost info (white inner card) ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  // Item images
                  _buildItemImages(context),
                  const Spacer(),
                  // Total items + total cost
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total items ${order.itemsCount}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.labelGray,
                                  fontWeight: TextWeight.medium,
                                ),
                      ),
                      4.h.ph,
                      Text(
                        '${order.currencySymbol}${order.totalCost.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.red3,
                                  fontWeight: TextWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          12.h.ph,

          // ── View Order Details Button ──
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 14.h),
            child: CustomButton(
              text: AppStrings.viewOrderDetails,
              onPressed: () => context.push(
                '${AppRoutes.pickerOrderDetailScreen}?orderId=${order.id}',
              ),
              btnHeight: 44.h,
              radius: 10.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = order.orderer.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return CircleAvatar(
      radius: 24.r,
      backgroundColor: AppColors.red1.withOpacity(0.1),
      backgroundImage:
          hasAvatar ? NetworkImage(AppUrls.resolveUrl(avatarUrl)) : null,
      child: hasAvatar
          ? null
          : Text(
              order.orderer.initials,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          order.orderer.fullName ?? 'JetOrderer',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black,
                fontWeight: TextWeight.semiBold,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        if (order.orderer.rating > 0) ...[
          2.h.ph,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                order.orderer.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.semiBold,
                    ),
              ),
              4.w.pw,
              Icon(Icons.star_rounded,
                  size: 15.sp, color: AppColors.starsColor),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildItemImages(BuildContext context) {
    final images = order.itemsImages.take(3).toList();
    final remaining = order.itemsCount - images.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...images.map((img) => Container(
              width: 40.w,
              height: 40.h,
              margin: EdgeInsets.only(right: 6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  AppUrls.resolveUrl(img),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image_outlined,
                    size: 20.sp,
                    color: AppColors.lightGray,
                  ),
                ),
              ),
            )),
        if (images.isEmpty)
          Container(
            width: 40.w,
            height: 40.h,
            margin: EdgeInsets.only(right: 6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.shopping_bag_outlined,
                size: 20.sp, color: AppColors.labelGray),
          ),
        if (remaining > 0)
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '+$remaining',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.red3,
                      fontWeight: TextWeight.bold,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
