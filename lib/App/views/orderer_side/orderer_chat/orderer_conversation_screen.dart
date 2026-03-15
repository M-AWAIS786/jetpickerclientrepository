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
  extends ConsumerState<OrdererConversationScreen>
  with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserId();
    Future.microtask(() {
      ref.read(conversationProvider.notifier).openRoom(
        widget.chatRoomId,
        isOrderer: true,
      );
    });
  }

  Future<void> _loadUserId() async {
    final userId = await UserPreferences.getUserId();
    if (mounted) setState(() => _currentUserId = userId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(conversationProvider.notifier).refreshTranslationSettings(
            isOrderer: true,
          );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

  void _onTranslateTap(String messageId) async {
    final viewModel = ref.read(conversationProvider.notifier);
    final state = ref.read(conversationProvider);
    final message = state.messages.firstWhere((m) => m.id == messageId);

    if (message.contentTranslated == null || message.contentTranslated!.isEmpty) {
      await viewModel.translateMessage(messageId);
    }

    viewModel.toggleManualTranslation(messageId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationProvider);
    final otherUserName = state.room?.otherUser?.fullName ?? 'Chat';

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
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      color: const Color(0xFFFFF8F0),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCC6600),
                              shape: BoxShape.circle,
                            ),
                          ),
                          8.w.pw,
                          Expanded(
                            child: Text(
                              'For transparency and protection, keep communication within the app.',
                              style: TextStyle(
                                color: const Color(0xFF994D00),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                  translationSettings: state.translationSettings,
                                  isManuallyTranslated:
                                      state.manuallyTranslatedIds.contains(msg.id),
                                  isTranslating: state.isTranslating,
                                  onTranslateTap: () => _onTranslateTap(msg.id),
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
  final TranslationSettings translationSettings;
  final bool isManuallyTranslated;
  final bool isTranslating;
  final VoidCallback? onTranslateTap;

  const _OrdererMessageBubble({
    required this.message,
    required this.isSender,
    required this.translationSettings,
    this.isManuallyTranslated = false,
    this.isTranslating = false,
    this.onTranslateTap,
  });

  Widget _buildMessageContent(BuildContext context) {
    final hasTranslation =
        message.contentTranslated != null && message.contentTranslated!.isNotEmpty;
    final isAutoTranslate = translationSettings.autoTranslateMessages;
    final isShowBoth = translationSettings.showOriginalAndTranslated;

    if (isSender) {
      return Text(
        message.contentOriginal,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontSize: 12.sp, color: AppColors.black),
      );
    }

    if (hasTranslation) {
      if (isShowBoth) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.contentOriginal,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            Divider(height: 8.h, color: Colors.grey[300]),
            Text(
              'Translation',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
            2.h.ph,
            Text(
              message.contentTranslated!,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: 12.sp, color: AppColors.black),
            ),
          ],
        );
      }

      if (isAutoTranslate || isManuallyTranslated) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isManuallyTranslated && !isAutoTranslate)
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  'Translation',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            Text(
              message.contentTranslated!,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: 12.sp, color: AppColors.black),
            ),
          ],
        );
      }
    }

    return Text(
      message.contentOriginal,
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(fontSize: 12.sp, color: AppColors.black),
    );
  }

  bool _shouldShowTranslateButton() {
    if (isSender) return false;

    final hasTranslation =
        message.contentTranslated != null && message.contentTranslated!.isNotEmpty;

    return !hasTranslation ||
        (!translationSettings.autoTranslateMessages &&
            !translationSettings.showOriginalAndTranslated);
  }

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
                  _buildMessageContent(context),
                  if (_shouldShowTranslateButton())
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: GestureDetector(
                        onTap: isTranslating ? null : onTranslateTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.15),
                              width: 0.5,
                            ),
                          ),
                          child: isTranslating
                              ? SizedBox(
                                  width: 12.w,
                                  height: 12.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: AppColors.black,
                                  ),
                                )
                              : Text(
                                  isManuallyTranslated
                                      ? 'View Original'
                                      : 'Translate',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.createdAt),
                    style:
                        TextStyle(color: AppColors.labelGray, fontSize: 11.sp),
                  ),
                  if (isSender) ...[
                    4.w.pw,
                    Icon(
                      message.isRead ? Icons.done_all : Icons.check,
                      size: 14.sp,
                      color: message.isRead
                          ? AppColors.yellow3
                          : AppColors.labelGray,
                    ),
                  ],
                ],
              ),
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
