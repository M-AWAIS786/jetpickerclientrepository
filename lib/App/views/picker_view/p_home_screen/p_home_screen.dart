import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/order/picker_dashboard_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/picker_dashboard_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pickerDashboardProvider.notifier).fetchDashboard();
      _loadUserName();
      _animController.forward();
    });
  }

  Future<void> _loadUserName() async {
    final name = await UserPreferences.getFullName() ?? '';
    if (mounted) setState(() => _userName = name);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(pickerDashboardProvider.notifier).fetchDashboard(silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pickerDashboardProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FA),
        body: RefreshIndicator(
          color: AppColors.red1,
          onRefresh: () =>
              ref.read(pickerDashboardProvider.notifier).refresh(),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // ── Custom Header ──
                _buildSliverHeader(state),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      20.h.ph,

                      // ── Hero Banner ──
                      _buildHeroBanner(state),
                      24.h.ph,

                      // ── Quick Stats ──
                      _buildQuickStats(state),
                      28.h.ph,

                      // ── Available Orders Section ──
                      _buildSectionHeader(
                        'Available Orders',
                        'Orders matching your travel routes',
                        onSeeAll: state.hasOrders ? () {} : null,
                      ),
                      14.h.ph,
                    ]),
                  ),
                ),

                // ── Order Cards List ──
                _buildOrdersList(state),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      28.h.ph,

                      // ── How It Works ──
                      _buildHowItWorksCard(),
                      32.h.ph,
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SLIVER HEADER — Greeting + Avatar + Bell
  // ═══════════════════════════════════════════════════════════
  Widget _buildSliverHeader(PickerDashboardState state) {
    final firstName = _userName.split(' ').first;
    final greeting = _getGreeting();

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12.h,
          left: 20.w,
          right: 20.w,
          bottom: 4.h,
        ),
        decoration: const BoxDecoration(color: Color(0xFFF8F8FA)),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFB3002D), Color(0xFF800020)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red1.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: TextWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            12.w.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting 👋',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.labelGray,
                      fontWeight: TextWeight.medium,
                    ),
                  ),
                  2.h.ph,
                  Text(
                    firstName.isNotEmpty ? firstName : 'Welcome',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: TextWeight.bold,
                      color: AppColors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            // Notification Bell
            _buildIconButton(
              AppImages.bellIcon,
              onTap: () {},
              badgeCount: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String iconPath,
      {VoidCallback? onTap, int badgeCount = 0}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: AppColors.red57,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HERO BANNER — Create New Journey
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeroBanner(PickerDashboardState state) {
    final journey = state.hasJourneys
        ? state.dashboardData!.travelJourneys.first
        : null;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.travelDetailSetupScreen),
      child: Container(
        height: 175.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              SvgPicture.asset(
                AppImages.jetPickerImage,
                fit: BoxFit.cover,
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4D0013).withOpacity(0.6),
                      const Color(0xFF800020).withOpacity(0.85),
                    ],
                  ),
                ),
              ),
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
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top label — show active journey if available
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        journey != null
                            ? '✈️  ${journey.routeLabel}  •  ${journey.formattedArrivalDate}'
                            : '✈️  Earn while you travel',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: TextWeight.medium,
                        ),
                      ),
                    ),
                    // Bottom CTA
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 210.w,
                        height: 46.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB3002D), Color(0xFF800020)],
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.red3.withOpacity(0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.white, size: 20.sp),
                            8.w.pw,
                            Text(
                              AppStrings.createNewJourney,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: TextWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK STATS ROW
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickStats(PickerDashboardState state) {
    final stats = state.dashboardData?.statistics;
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.inventory_2_outlined,
          label: 'Available\nOrders',
          value: '${stats?.totalAvailableOrders ?? 0}',
          color: const Color(0xFFB3002D),
          bgColor: const Color(0xFFFFE5EC),
        ),
        12.w.pw,
        _buildStatCard(
          icon: Icons.flight_rounded,
          label: 'Active\nJourneys',
          value: '${stats?.activeJourneys ?? 0}',
          color: const Color(0xFF6C63FF),
          bgColor: const Color(0xFFF0EEFF),
        ),
        12.w.pw,
        _buildStatCard(
          icon: Icons.check_circle_outline_rounded,
          label: 'Completed\nDeliveries',
          value: '${stats?.completedDeliveries ?? 0}',
          color: const Color(0xFF00B894),
          bgColor: const Color(0xFFE8F8F5),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            10.h.ph,
            Text(
              value,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: TextWeight.bold,
                color: AppColors.black,
              ),
            ),
            4.h.ph,
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.labelGray,
                fontWeight: TextWeight.medium,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionHeader(String title, String subtitle,
      {VoidCallback? onSeeAll}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: TextWeight.bold,
                  color: AppColors.black,
                  letterSpacing: -0.3,
                ),
              ),
              4.h.ph,
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.labelGray,
                  fontWeight: TextWeight.regular,
                ),
              ),
            ],
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.redLight,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: TextWeight.semiBold,
                  color: AppColors.red1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ORDERS LIST
  // ═══════════════════════════════════════════════════════════
  Widget _buildOrdersList(PickerDashboardState state) {
    if (state.isLoading && state.dashboardData == null) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200.h,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.red1,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    if (state.errorMessage != null && state.dashboardData == null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildErrorCard(state.errorMessage!),
        ),
      );
    }

    if (!state.hasOrders) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildEmptyOrdersCard(),
        ),
      );
    }

    final orders = state.dashboardData!.availableOrders.data;
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: _DashboardOrderCard(order: orders[index]),
            );
          },
          childCount: orders.length,
        ),
      ),
    );
  }

  Widget _buildEmptyOrdersCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE5EC), Color(0xFFFFF0F3)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.red1.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.red1.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.red1,
              size: 28.sp,
            ),
          ),
          14.h.ph,
          Text(
            'No Orders Available Yet',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.black,
            ),
          ),
          6.h.ph,
          Text(
            'Create a journey to see matching\norders from orderers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.labelGray,
              height: 1.4,
            ),
          ),
          16.h.ph,
          SizedBox(
            width: 180.w,
            height: 40.h,
            child: CustomButton(
              text: AppStrings.createNewJourney,
              radius: 20.r,
              fontSize: 13.sp,
              btnHeight: 40.h,
              onPressed: () =>
                  context.push(AppRoutes.travelDetailSetupScreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: AppColors.red57),
          12.h.ph,
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.black,
            ),
          ),
          6.h.ph,
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.labelGray,
              height: 1.4,
            ),
          ),
          16.h.ph,
          SizedBox(
            width: 140.w,
            height: 40.h,
            child: CustomButton(
              text: 'Retry',
              radius: 20.r,
              fontSize: 13.sp,
              btnHeight: 40.h,
              onPressed: () =>
                  ref.read(pickerDashboardProvider.notifier).fetchDashboard(),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HOW IT WORKS CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildHowItWorksCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4D0013), Color(0xFF800020)],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How JetPicks Works',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.white,
            ),
          ),
          16.h.ph,
          _buildStep(
              '1', 'Add your journey', 'Share your travel route & dates'),
          12.h.ph,
          _buildStep(
              '2', 'Browse orders', 'Find orders matching your route'),
          12.h.ph,
          _buildStep('3', 'Deliver & earn',
              'Pick up items, deliver & get your reward'),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.yellow3.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: TextWeight.bold,
                color: AppColors.yellow3,
              ),
            ),
          ),
        ),
        14.w.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: TextWeight.semiBold,
                color: AppColors.white,
              ),
            ),
            2.h.ph,
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Greeting based on time ──
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

// ─────────────────────────────────────────────────────────────
// DASHBOARD ORDER CARD — Modern polished card
// ─────────────────────────────────────────────────────────────
class _DashboardOrderCard extends StatelessWidget {
  final DashboardOrderModel order;
  const _DashboardOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.pickerOrderDetailScreen}?orderId=${order.id}',
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header: Avatar + Orderer Info ──
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
              child: Row(
                children: [
                  _buildAvatar(context),
                  10.w.pw,
                  Expanded(child: _buildOrdererInfo(context)),
                  // Route badge
                  if (order.originCity != null || order.destinationCity != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.redLight,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_rounded,
                              size: 12.sp, color: AppColors.red1),
                          4.w.pw,
                          Text(
                            '${order.originCity ?? '?'} → ${order.destinationCity ?? '?'}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: TextWeight.semiBold,
                              color: AppColors.red1,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            12.h.ph,

            // ── Items strip + Cost info ──
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
                    _buildItemImages(context),
                    const Spacer(),
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
                radius: 12.r,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = order.orderer.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.red1.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                AppUrls.resolveUrl(avatarUrl),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildAvatarFallback(context),
              )
            : _buildAvatarFallback(context),
      ),
    );
  }

  Widget _buildAvatarFallback(BuildContext context) {
    return Container(
      color: AppColors.red1.withOpacity(0.1),
      child: Center(
        child: Text(
          order.orderer.initials,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: TextWeight.bold,
            color: AppColors.red1,
          ),
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
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: TextWeight.semiBold,
            color: AppColors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (order.orderer.rating > 0) ...[
          2.h.ph,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded,
                  size: 14.sp, color: AppColors.starsColor),
              3.w.pw,
              Text(
                order.orderer.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: TextWeight.semiBold,
                  color: AppColors.black,
                ),
              ),
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
                border: Border.all(
                  color: const Color(0xFFF0F0F0),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.r),
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
              color: AppColors.redLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '+$remaining',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: TextWeight.bold,
                  color: AppColors.red3,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
