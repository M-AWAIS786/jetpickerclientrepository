

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/delivery_reward_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/delivery_route_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/order_information_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/delivery_route/order_summery_screen.dart';
import 'package:jet_picks_app/App/widgets/show_success_dialogue.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/delivery_appbar.dart';
import '../../../widgets/custom_button.dart';

class DeliveryFlowScreen extends StatefulWidget {
  const DeliveryFlowScreen({super.key});

  @override
  State<DeliveryFlowScreen> createState() => _DeliveryFlowScreenState();
}

class _DeliveryFlowScreenState extends State<DeliveryFlowScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  final int totalSteps = 4;

  void goNext() {
    if (currentStep < totalSteps - 1) {
      setState(() => currentStep++);
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      showSuccessDialog();
    }
  }

  void goBack() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = currentStep == totalSteps - 1;
    return Scaffold(
      appBar: DeliveryAppBar(
        totalSteps: totalSteps,
        currentStep: currentStep,
        onTap: goBack,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          DeliveryRouteScreen(),
          OrderInformationScreen(),
          DeliveryRewardScreen(),
          OrderSummeryScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 20.h,
          right: 20.h,
          bottom: 30.h,
        ),
        child: CustomButton(
          text: isLast ? AppStrings.placeOrder : AppStrings.next,
          color: AppColors.yellow3,
          textColor: AppColors.black,
          onPressed: goNext,
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ShowSuccessDialogue();
      },
    );
  }
}
