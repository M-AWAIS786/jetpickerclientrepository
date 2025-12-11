// conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_chat/orderer_message_list.dart';

import '../../../constants/app_strings.dart';
import '../../../models/message_model.dart';
import '../../../widgets/chat_typebar.dart';

class OrdererConversationScreen extends StatefulWidget {
  const OrdererConversationScreen({super.key});

  @override
  State<OrdererConversationScreen> createState() =>
      _OrdererConversationScreenState();
}

class _OrdererConversationScreenState extends State<OrdererConversationScreen> {
  final List<Message> messages = [
    Message('Do you have fixed delivery fee?', true, false, '09.15'),
    Message('Yes i have fixed rates', false, true, '09.00'),
    Message('Okay, I\'m waiting 🥳', true, false, '09.15'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
        titleColor: AppColors.black,
        title: 'Methew M.',
        fontSize: 14.sp,
        fontWeight: TextWeight.semiBold,
        phoneIcon: true,
      ),

      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '${AppStrings.formLondonMadrid}   12 Dec',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          20.h.ph,

          Expanded(child: OrdererMessageList(messages: messages)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: ChatSearchBar(
              prefixColor: AppColors.black,
              sufixColor: AppColors.black,
              sendContainerColor: AppColors.yellow3,
              sendIconColor: AppColors.black,
              borderColor: AppColors.yellow1,
            ),
          ),
        ],
      ),
    );
  }
}
