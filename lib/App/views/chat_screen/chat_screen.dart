import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/chat/chat_view_model.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_fontweight.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatListProvider.notifier).fetchChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatListProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.chatList,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.red3,
                      fontSize: 28.sp,
                      fontWeight: TextWeight.bold,
                    ),
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
              12.h.ph,
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.red3))
                    : state.errorMessage != null && state.chatRooms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Failed to load chats',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.labelGray),
                                ),
                                12.h.ph,
                                TextButton(
                                  onPressed: () => ref
                                      .read(chatListProvider.notifier)
                                      .fetchChatRooms(),
                                  child: Text('Retry',
                                      style:
                                          TextStyle(color: AppColors.red3)),
                                ),
                              ],
                            ),
                          )
                        : state.chatRooms.isEmpty
                            ? Center(
                                child: Text(
                                  'No conversations yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.labelGray),
                                ),
                              )
                            : RefreshIndicator(
                                color: AppColors.red3,
                                onRefresh: () => ref
                                    .read(chatListProvider.notifier)
                                    .fetchChatRooms(),
                                child: ListView.builder(
                                  itemCount: state.chatRooms.length,
                                  itemBuilder: (context, index) {
                                    final room = state.chatRooms[index];
                                    final name =
                                        room.otherUser?.fullName ?? 'User';
                                    final lastMsg =
                                        room.lastMessage ?? 'No messages yet';
                                    final time =
                                        _formatTime(room.lastMessageTime);
                                    final avatarUrl =
                                        room.otherUser?.avatarUrl;
                                    final hasAvatar = avatarUrl != null &&
                                        avatarUrl.isNotEmpty;

                                    return Padding(
                                      padding: EdgeInsets.only(top: 14.h),
                                      child: _ChatRoomCard(
                                        name: name,
                                        lastMessage: lastMsg,
                                        time: time,
                                        unreadCount: room.unreadCount,
                                        avatarUrl: hasAvatar
                                            ? AppUrls.resolveUrl(avatarUrl)
                                            : null,
                                        initials:
                                            room.otherUser?.initials ?? '?',
                                        nameColor: AppColors.red3,
                                        iconColor: AppColors.red3,
                                        onTap: () {
                                          context.push(
                                            '${AppRoutes.conversationScreen}?chatRoomId=${room.id}',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        return DateFormat('HH:mm').format(date);
      }
      return DateFormat('MMM d').format(date);
    } catch (_) {
      return '';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Chat Room Card (reusable)
// ─────────────────────────────────────────────────────────────
class _ChatRoomCard extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? avatarUrl;
  final String initials;
  final Color nameColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _ChatRoomCard({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
    required this.initials,
    required this.nameColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.lightGray,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      initials,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: nameColor,
                            fontWeight: TextWeight.bold,
                          ),
                    )
                  : null,
            ),
            10.w.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: TextWeight.bold,
                          fontSize: 14.sp,
                          color: nameColor,
                        ),
                  ),
                  4.h.ph,
                  Text(
                    lastMessage,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.labelGray,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.labelGray,
                      ),
                ),
                4.h.ph,
                if (unreadCount > 0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 11.sp,
                          fontWeight: TextWeight.bold),
                    ),
                  )
                else
                  Icon(Icons.done_all, size: 20.sp, color: iconColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
