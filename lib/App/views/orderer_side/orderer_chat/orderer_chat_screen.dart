import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_fontweight.dart';
import '../../../widgets/chatlist_card.dart';

class OrdererChatScreen extends StatelessWidget {
  const OrdererChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.chatList,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              30.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.allMessages,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: TextWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 14.h),
                      child: ChatListCard(
                        name: 'Geopart Etdsien',
                        lastMessage: 'Your Order Just Arrived!',
                        time: '13.47',
                        iconColor: AppColors.black,
                        nameColor: AppColors.black,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.ordererConversationScreen,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        shape: CircleBorder(),
        onPressed: () {},
        child: Icon(Icons.add, color: AppColors.white, size: 35.sp),
      ),
    );
  }
}
