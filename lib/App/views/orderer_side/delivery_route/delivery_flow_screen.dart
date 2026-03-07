import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/delivery_reward_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/delivery_route_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/order_information_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/order_summery_screen.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/delivery_appbar.dart';
import '../../../widgets/custom_button.dart';

class DeliveryFlowScreen extends ConsumerStatefulWidget {
  const DeliveryFlowScreen({super.key});

  @override
  ConsumerState<DeliveryFlowScreen> createState() => _DeliveryFlowScreenState();
}

class _DeliveryFlowScreenState extends ConsumerState<DeliveryFlowScreen> {
  final PageController _pageController = PageController();
  final int totalSteps = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _syncPage(int step) {
    if (_pageController.hasClients && _pageController.page?.round() != step) {
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> goNext() async {
    final vm = ref.read(createOrderProvider.notifier);
    final currentStep = ref.read(createOrderProvider).currentStep;

    bool success = false;
    switch (currentStep) {
      case 0:
        success = await vm.submitStep1();
        break;
      case 1:
        success = await vm.submitStep2();
        break;
      case 2:
        success = await vm.submitStep3();
        break;
      case 3:
        success = await vm.placeOrder();
        if (success) {
          _showSuccessDialog();
        }
        break;
    }
  }

  void goBack() {
    final currentStep = ref.read(createOrderProvider).currentStep;
    if (currentStep > 0) {
      ref.read(createOrderProvider.notifier).goBack();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createOrderProvider);

    // Sync the page whenever currentStep changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPage(state.currentStep);
    });

    final bool isLast = state.currentStep == totalSteps - 1;

    return Scaffold(
      appBar: DeliveryAppBar(
        totalSteps: totalSteps,
        currentStep: state.currentStep,
        onTap: goBack,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          DeliveryRouteScreen(),
          OrderInformationScreen(),
          DeliveryRewardScreen(),
          OrderSummeryScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          left: 20.w,
          right: 20.w,
          bottom: 30.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Validation error
            if (state.validationError != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: Text(
                    state.validationError!,
                    style: TextStyle(
                      color: AppColors.red57,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            CustomButton(
              text: isLast ? AppStrings.placeOrder : AppStrings.next,
              color: AppColors.yellow3,
              textColor: AppColors.black,
              isLoading: state.isLoading,
              onPressed: state.isLoading ? null : goNext,
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.yellow2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flight_takeoff_rounded,
                    size: 72.sp, color: AppColors.black),
                24.verticalSpace,
                Text(
                  AppStrings.orderSuccessfulPosted,
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                ),
                32.verticalSpace,
                CustomButton(
                  text: 'Go to Dashboard',
                  color: AppColors.white,
                  textColor: AppColors.black,
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Pop back to the dashboard
                    context.go(AppRoutes.ordererBottomBarScreen);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto-close after 3 seconds and navigate to dashboard
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        context.go(AppRoutes.ordererBottomBarScreen);
      }
    });
  }
}
