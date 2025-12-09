import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';

import '../../constants/app_strings.dart';
import '../../widgets/chat_typebar.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
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
          Expanded(child: _buildMessageList()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: ChatSearchBar(),
          ),
        ],
      ),
    );
  }
}

// --- Data Model Placeholder ---
class Message {
  final String text;
  final bool
  isSender; // True for the user (Pink bubble), False for the contact (Yellow bubble)
  final bool hasTranslation;
  final String time;

  Message(this.text, this.isSender, this.hasTranslation, this.time);
}

// --- Sample Data ---
final List<Message> _messages = [
  Message('Accepted your order', true, false, '09.15'),
  Message('Yes i have fixed rates', false, true, '09.00'),
  Message('Okay, I\'m waiting 🥳', true, false, '09.15'),
];

Widget _buildMessageList() {
  return ListView.builder(
    padding: const EdgeInsets.all(12.0),
    reverse: false, // Set to true for traditional chat scrolling
    itemCount: _messages.length,
    itemBuilder: (context, index) {
      final message = _messages[index];

      // Determine alignment based on sender
      final alignment = message.isSender
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start;

      // Add contact info for incoming messages (like Methew M. with the avatar)
      if (!message.isSender && index == 1) {
        // Specifically for the 'Methew M.' message
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Placeholder
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                // child: Image.network('avatar_url'), // Use Image.asset or NetworkImage
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Methew M.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  _MessageBubble(
                    message: message,
                  ), // Render the actual message bubble
                ],
              ),
            ],
          ),
        );
      }

      // For standard messages (sender messages)
      return _MessageBubble(message: message);
    },
  );
}

// --- Message Bubble Widget ---
class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.isSender
        ? AppColors.redLight
        : AppColors.yellow1;
    final alignment = message.isSender
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final radius = message.isSender
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4), // Subtle change for the tail
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4), // Subtle change for the tail
          );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Optional: Translation Button for incoming messages
            if (message.hasTranslation)
              Container(
                margin: const EdgeInsets.only(bottom: 4.0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.red3, // Use the maroon color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Translate',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),

            // The main text bubble
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: radius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Message Text
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),

                  // Optional: Translation Text (e.g., for the 'Yes i have fixed rates' bubble)
                  if (message.hasTranslation)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Si, tengo tarifas fijas.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Time Stamp and Sent Status Icon
            Row(
              mainAxisSize: MainAxisSize.min, // Essential to keep the row small
              children: [
                Text(
                  message.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                if (message.isSender) // Only show checkmark for sent messages
                  const Icon(Icons.check, size: 14, color: AppColors.red3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
