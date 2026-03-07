// conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/chat/chat_view_model.dart';
import 'package:jet_picks_app/App/models/chat/chat_models.dart';
import 'package:intl/intl.dart';

class OrdererConversationScreen extends ConsumerStatefulWidget {
  final String chatRoomId;
  const OrdererConversationScreen({super.key, required this.chatRoomId});

  @override
  ConsumerState<OrdererConversationScreen> createState() =>
      _OrdererConversationScreenState();
}

class _OrdererConversationScreenState
    extends ConsumerState<OrdererConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    Future.microtask(() {
      ref.read(conversationProvider.notifier).openRoom(widget.chatRoomId);
    });
  }

  Future<void> _loadUserId() async {
    final userId = await UserPreferences.getUserId();
    if (mounted) setState(() => _currentUserId = userId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    ref.read(conversationProvider.notifier).stopPolling();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    ref.read(conversationProvider.notifier).sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationProvider);
    final otherUserName = state.room?.otherUser?.fullName ?? 'Chat';

    // Auto-scroll when new messages arrive
    ref.listen<ConversationState>(conversationProvider, (prev, next) {
      if ((prev?.messages.length ?? 0) < next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        leadingIcon: true,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
        titleColor: AppColors.black,
        title: otherUserName,
        fontSize: 14.sp,
        fontWeight: TextWeight.semiBold,
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.yellow3))
          : state.errorMessage != null && state.messages.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.labelGray),
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Route info header
                    if (state.room != null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'Order Chat',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.black),
                        ),
                      ),
                    // Messages list
                    Expanded(
                      child: state.messages.isEmpty
                          ? Center(
                              child: Text(
                                'No messages yet. Start the conversation!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.labelGray),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(16.w),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final msg = state.messages[index];
                                final isSender =
                                    msg.senderId == _currentUserId;
                                return _OrdererMessageBubble(
                                  message: msg,
                                  isSender: isSender,
                                );
                              },
                            ),
                    ),
                    // Type bar
                    _OrdererChatInputBar(
                      controller: _messageController,
                      isSending: state.isSending,
                      onSend: _sendMessage,
                    ),
                  ],
                ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Orderer Message Bubble
// ─────────────────────────────────────────────────────────────
class _OrdererMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSender;

  const _OrdererMessageBubble({
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isSender
        ? BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(4.r),
          );

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name for received messages
            if (!isSender && message.sender?.fullName != null)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h, left: 4.w),
                child: Text(
                  message.sender!.fullName!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.labelGray,
                        fontWeight: TextWeight.medium,
                      ),
                ),
              ),

            // Translation badge
            if (message.translationEnabled &&
                message.contentTranslated != null)
              Container(
                margin: EdgeInsets.only(bottom: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.yellow3,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Translate',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

            // Bubble
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSender ? AppColors.yellow1 : AppColors.redLight,
                borderRadius: radius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.contentOriginal,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 12.sp),
                  ),
                  if (message.translationEnabled &&
                      message.contentTranslated != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        message.contentTranslated!,
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Time + read tick
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style:
                      TextStyle(color: AppColors.labelGray, fontSize: 11.sp),
                ),
                if (isSender)
                  Icon(
                    message.isRead ? Icons.done_all : Icons.check,
                    size: 14.sp,
                    color:
                        message.isRead ? AppColors.yellow3 : AppColors.labelGray,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Orderer Chat Input Bar
// ─────────────────────────────────────────────────────────────
class _OrdererChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _OrdererChatInputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.yellow1, width: 0.5),
                ),
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    hintText: 'Type something...',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: AppColors.labelGray),
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.black),
                ),
              ),
            ),
            10.w.pw,
            GestureDetector(
              onTap: isSending ? null : onSend,
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.yellow3,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: isSending
                    ? Padding(
                        padding: EdgeInsets.all(12.w),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.black,
                        ),
                      )
                    : Icon(Icons.send_rounded,
                        color: AppColors.black, size: 22.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
