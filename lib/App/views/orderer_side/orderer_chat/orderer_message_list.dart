// message_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../models/message_model.dart';
import 'orderer_message_bubble.dart';


class OrdererMessageList extends StatelessWidget {
  final List<Message> messages;

  const OrdererMessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        // Special UI for incoming message “Methew M.”
        if (!message.isSender && index == 1) {
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.lightGray,
                ),
                8.w.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Methew M.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    4.h.ph,
                    OrdererMessageBubble(message: message),
                  ],
                ),
              ],
            ),
          );
        }

        return OrdererMessageBubble(message: message);
      },
    );
  }
}
