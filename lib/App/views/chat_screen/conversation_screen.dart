// conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import '../../constants/app_strings.dart';
import '../../models/message_model.dart';
import '../../widgets/chat_typebar.dart';

import 'message_list.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<Message> messages = [
    Message('Accepted your order', true, false, '09.15'),
    Message('Yes i have fixed rates', false, true, '09.00'),
    Message('Okay, I\'m waiting 🥳', true, false, '09.15'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        leadingIcon: true,
        appBarColor: AppColors.white,
        title: 'Sarah M.',
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
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.red3),
            ),
          ),
          20.h.ph,

          Expanded(child: MessageList(messages: messages)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: ChatSearchBar(),
          ),
        ],
      ),
    );
  }
}
