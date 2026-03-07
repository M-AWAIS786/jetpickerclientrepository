import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/models/order/orderer_order_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
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

class _OrdererHomeScreenState extends ConsumerState<OrdererHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordererDashboardProvider.notifier).fetchDashboard();
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordererDashboardProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9FB),
        body: RefreshIndicator(
          color: AppColors.yellow3,
          onRefresh: () =>
              ref.read(ordererDashboardProvider.notifier).refresh(),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // ── Custom App Bar Header ──
                _buildSliverHeader(state),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      20.h.ph,

                      // ── Hero Banner ──
                      _buildHeroBanner(),
                      24.h.ph,

                      // ── Quick Stats ──
                      _buildQuickStats(state),
                      28.h.ph,

                      // ── Available JetPickers Section ──
                      _buildSectionHeader(
                        'Available JetPickers',
                        'Nearby travelers ready to deliver',
                        onSeeAll: state.pickers.isNotEmpty ? () {} : null,
                      ),
                      14.h.ph,
                    ]),
                  ),
                ),

                // ── Horizontal Picker Cards ──
                _buildPickersList(state),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      28.h.ph,

                      // ── Active Orders Section ──
                      if (state.activeOrders.isNotEmpty) ...[
                        _buildSectionHeader(
                          'My Active Orders',
                          'Track your current orders',
                        ),
                        14.h.ph,
                        ...state.activeOrders.map(
                          (order) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _ActiveOrderCard(order: order),
                          ),
                        ),
                        20.h.ph,
                      ],

                      // ── How It Works Section ──
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
  Widget _buildSliverHeader(OrdererDashboardState state) {
    final firstName = state.userName.split(' ').first;
    final greeting = _getGreeting();

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12.h,
          left: 20.w,
          right: 20.w,
          bottom: 4.h,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9FB),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFDF57), Color(0xFFFFCA28)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellow3.withOpacity(0.3),
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
                    color: AppColors.black,
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
  // HERO BANNER — Create An Order
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeroBanner() {
    return GestureDetector(
      onTap: _navigateToCreateOrder,
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
              // Background Image
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
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.55),
                    ],
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
                    // Top label
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '🌍  Order from anywhere',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: TextWeight.medium,
                        ),
                      ),
                    ),
                    // Bottom CTA button
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 200.w,
                        height: 46.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE566), Color(0xFFFFD700)],
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.yellow3.withOpacity(0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.black, size: 20.sp),
                            8.w.pw,
                            Text(
                              'Create An Order',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: TextWeight.bold,
                                color: AppColors.black,
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
  Widget _buildQuickStats(OrdererDashboardState state) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.local_shipping_outlined,
          label: 'Active\nOrders',
          value: '${state.activeOrders.length}',
          color: const Color(0xFF6C63FF),
          bgColor: const Color(0xFFF0EEFF),
        ),
        12.w.pw,
        _buildStatCard(
          icon: Icons.people_outline_rounded,
          label: 'Pickers\nAvailable',
          value: '${state.pickers.length}',
          color: const Color(0xFF00B894),
          bgColor: const Color(0xFFE8F8F5),
        ),
        12.w.pw,
        _buildStatCard(
          icon: Icons.star_outline_rounded,
          label: 'Total\nDeliveries',
          value: '—',
          color: const Color(0xFFFF9F43),
          bgColor: const Color(0xFFFFF5EB),
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
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: TextWeight.semiBold,
                  color: const Color(0xFFD4A017),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PICKERS HORIZONTAL LIST
  // ═══════════════════════════════════════════════════════════
  Widget _buildPickersList(OrdererDashboardState state) {
    if (state.isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 220.h,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.yellow3,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    if (state.pickers.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildEmptyPickersCard(),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 235.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 20.w, right: 8.w),
          physics: const BouncingScrollPhysics(),
          itemCount: state.pickers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: _PickerCard(
                picker: state.pickers[index],
                onViewDetails: () => context.push(
                  '${AppRoutes.jetPickerDetailsScreen}?pickerIndex=$index',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyPickersCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF8E1),
            const Color(0xFFFFFDE7),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFFFE082).withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.yellow3.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: const Color(0xFFD4A017),
              size: 28.sp,
            ),
          ),
          14.h.ph,
          Text(
            'No JetPickers Available Yet',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: TextWeight.bold,
              color: AppColors.black,
            ),
          ),
          6.h.ph,
          Text(
            'Create an order to find matching\ntravelers heading your way!',
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
              text: 'Create Order',
              color: AppColors.yellow3,
              textColor: AppColors.black,
              radius: 20.r,
              fontSize: 13.sp,
              btnHeight: 40.h,
              onPressed: _navigateToCreateOrder,
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
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
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
          _buildStep('1', 'Create your order', 'Add items & set delivery reward'),
          12.h.ph,
          _buildStep('2', 'Get matched', 'We find travelers heading your way'),
          12.h.ph,
          _buildStep('3', 'Receive & confirm', 'Meet, get items & confirm delivery'),
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

  // ── Navigation ──
  void _navigateToCreateOrder() {
    ref.read(createOrderProvider.notifier).reset();
    context.push(AppRoutes.deliveryFlowScreen);
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
// PICKER CARD — Modern horizontal card
// ─────────────────────────────────────────────────────────────
class _PickerCard extends StatelessWidget {
  final AvailablePicker picker;
  final VoidCallback onViewDetails;

  const _PickerCard({required this.picker, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        width: 200.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar + Name + Rating ──
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.yellow3.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: picker.pickerAvatarUrl != null
                        ? Image.network(
                            AppUrls.resolveUrl(picker.pickerAvatarUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                          )
                        : _buildAvatarFallback(),
                  ),
                ),
                8.w.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        picker.shortName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: TextWeight.bold,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: AppColors.starsColor, size: 14.sp),
                          3.w.pw,
                          Text(
                            picker.pickerRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: TextWeight.semiBold,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            ' · ${picker.completedDeliveries} trips',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.labelGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.h.ph,

            // ── Route Banner ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8D6), Color(0xFFFFF3BD)],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        picker.departureCountry,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: TextWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          Icons.flight_rounded,
                          size: 16.sp,
                          color: const Color(0xFFD4A017),
                        ),
                      ),
                      Text(
                        picker.arrivalCountry,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: TextWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  4.h.ph,
                  Text(
                    _formatDate(picker.departureDate),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.labelGray,
                      fontWeight: TextWeight.medium,
                    ),
                  ),
                ],
              ),
            ),
            12.h.ph,

            // ── Capacity Bar ──
            Row(
              children: [
                Icon(Icons.luggage_outlined,
                    size: 14.sp, color: AppColors.labelGray),
                6.w.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${picker.luggageWeightCapacity.toStringAsFixed(0)}kg available',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.labelGray,
                          fontWeight: TextWeight.medium,
                        ),
                      ),
                      4.h.ph,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: 1 - picker.capacityUsedPercent,
                          minHeight: 4.h,
                          backgroundColor: const Color(0xFFE8E8E8),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCapacityColor(
                                1 - picker.capacityUsedPercent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ── View Details Button ──
            Container(
              width: double.infinity,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE566), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onViewDetails,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Center(
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: TextWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: const Color(0xFFE8E8E8),
      child: Center(
        child: Text(
          picker.initials,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: TextWeight.bold,
            color: AppColors.labelGray,
          ),
        ),
      ),
    );
  }

  Color _getCapacityColor(double value) {
    if (value > 0.6) return const Color(0xFF00B894);
    if (value > 0.3) return const Color(0xFFFFAA33);
    return const Color(0xFFFF6B6B);
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// ACTIVE ORDER CARD — Compact order status card
// ─────────────────────────────────────────────────────────────
class _ActiveOrderCard extends StatelessWidget {
  final OrdererOrderModel order;

  const _ActiveOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.orderHistoryDetailScreen}?orderId=${order.id}',
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
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
        child: Row(
          children: [
            // ── Status Icon ──
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                _statusIcon,
                color: _statusColor,
                size: 22.sp,
              ),
            ),
            14.w.pw,

            // ── Order Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.routeLabel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: TextWeight.semiBold,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.h.ph,
                  Row(
                    children: [
                      _buildInfoChip(
                        '${order.itemsCount} ${order.itemsCount == 1 ? 'item' : 'items'}',
                      ),
                      8.w.pw,
                      Text(
                        order.formattedTotalCost,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: TextWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Status Badge ──
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                order.status[0] + order.status.substring(1).toLowerCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: TextWeight.semiBold,
                  color: _statusColor,
                ),
              ),
            ),

            8.w.pw,
            Icon(Icons.chevron_right_rounded,
                color: AppColors.labelGray, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: AppColors.labelGray,
          fontWeight: TextWeight.medium,
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFFF9F43);
      case 'ACCEPTED':
        return const Color(0xFF6C63FF);
      default:
        return AppColors.labelGray;
    }
  }

  IconData get _statusIcon {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return Icons.schedule_rounded;
      case 'ACCEPTED':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.local_shipping_outlined;
    }
  }
}