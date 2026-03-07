import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/chat/chat_models.dart';
import 'package:jet_picks_app/App/repo/chat_repository.dart';

// ─────────────────────────────────────────────────────────────
// Chat List State & ViewModel (for chat list screens)
// ─────────────────────────────────────────────────────────────
class ChatListState {
  final bool isLoading;
  final String? errorMessage;
  final List<ChatListItemModel> chatRooms;

  const ChatListState({
    this.isLoading = false,
    this.errorMessage,
    this.chatRooms = const [],
  });

  ChatListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ChatListItemModel>? chatRooms,
    bool clearError = false,
  }) {
    return ChatListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }
}

class ChatListViewModel extends Notifier<ChatListState> {
  late final ChatRepository _repo;

  @override
  ChatListState build() {
    _repo = ChatRepository();
    return const ChatListState();
  }

  Future<void> fetchChatRooms() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');
      final rooms = await _repo.getChatRooms(token: token);
      state = state.copyWith(isLoading: false, chatRooms: rooms);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final chatListProvider =
    NotifierProvider<ChatListViewModel, ChatListState>(ChatListViewModel.new);

// ─────────────────────────────────────────────────────────────
// Conversation State & ViewModel (for a single chat room)
// ─────────────────────────────────────────────────────────────
class ConversationState {
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;
  final ChatRoomModel? room;
  final List<ChatMessageModel> messages;

  const ConversationState({
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
    this.room,
    this.messages = const [],
  });

  ConversationState copyWith({
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    ChatRoomModel? room,
    List<ChatMessageModel>? messages,
    bool clearError = false,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      room: room ?? this.room,
      messages: messages ?? this.messages,
    );
  }
}

class ConversationViewModel extends Notifier<ConversationState> {
  late final ChatRepository _repo;
  Timer? _pollingTimer;
  String? _currentRoomId;

  @override
  ConversationState build() {
    _repo = ChatRepository();
    ref.onDispose(() {
      stopPolling();
    });
    return const ConversationState();
  }

  /// Load room details + messages, then start polling
  Future<void> openRoom(String roomId) async {
    stopPolling();
    _currentRoomId = roomId;
    state = state.copyWith(isLoading: true, clearError: true, messages: []);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final room = await _repo.getChatRoomDetail(token: token, roomId: roomId);
      final messages =
          await _repo.getMessages(token: token, roomId: roomId);

      state = state.copyWith(
        isLoading: false,
        room: room,
        messages: messages,
      );

      // Mark unread messages as read
      final userId = await UserPreferences.getUserId();
      if (userId != null) {
        _markUnreadAsRead(token, userId);
      }

      // Start polling every 2 seconds (same as web)
      _startPolling(roomId);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _startPolling(String roomId) {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final token = await UserPreferences.getToken();
        if (token == null || _currentRoomId != roomId) return;

        final newMessages =
            await _repo.getMessages(token: token, roomId: roomId);

        if (newMessages.isNotEmpty) {
          final existingIds = state.messages.map((m) => m.id).toSet();
          final uniqueNew =
              newMessages.where((m) => !existingIds.contains(m.id)).toList();

          if (uniqueNew.isNotEmpty) {
            state = state.copyWith(
              messages: [...state.messages, ...uniqueNew],
            );

            // Mark new messages as read
            final userId = await UserPreferences.getUserId();
            if (userId != null) {
              _markUnreadAsRead(token, userId);
            }
          }
        }
      } catch (e) {
        log('Error polling messages: $e');
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentRoomId = null;
  }

  Future<void> _markUnreadAsRead(String token, String currentUserId) async {
    final unread = state.messages
        .where((m) => !m.isRead && m.senderId != currentUserId)
        .toList();
    for (final msg in unread) {
      try {
        await _repo.markMessageAsRead(token: token, messageId: msg.id);
      } catch (_) {}
    }
  }

  Future<void> sendMessage(String content, {bool translate = false}) async {
    if (_currentRoomId == null || content.trim().isEmpty) return;
    state = state.copyWith(isSending: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final newMessage = await _repo.sendMessage(
        token: token,
        roomId: _currentRoomId!,
        content: content.trim(),
        translate: translate,
      );

      state = state.copyWith(
        isSending: false,
        messages: [...state.messages, newMessage],
      );
    } catch (e) {
      state = state.copyWith(isSending: false, errorMessage: e.toString());
    }
  }

  void closeRoom() {
    stopPolling();
    state = const ConversationState();
  }
}

final conversationProvider =
    NotifierProvider<ConversationViewModel, ConversationState>(
  ConversationViewModel.new,
);

// ─────────────────────────────────────────────────────────────
// Start Chat helper — getOrCreateChatRoom (returns chatRoomId)
// ─────────────────────────────────────────────────────────────
class StartChatState {
  final bool isStarting;
  final String? errorMessage;

  const StartChatState({this.isStarting = false, this.errorMessage});

  StartChatState copyWith({
    bool? isStarting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StartChatState(
      isStarting: isStarting ?? this.isStarting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class StartChatViewModel extends Notifier<StartChatState> {
  late final ChatRepository _repo;

  @override
  StartChatState build() {
    _repo = ChatRepository();
    return const StartChatState();
  }

  /// Calls getOrCreateChatRoom and returns the chatRoomId, or null on failure
  Future<String?> startChat({
    required String orderId,
    required String pickerId,
  }) async {
    state = state.copyWith(isStarting: true, clearError: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final result = await _repo.getOrCreateChatRoom(
        token: token,
        orderId: orderId,
        pickerId: pickerId,
      );

      state = state.copyWith(isStarting: false);

      if (result['success'] == true && result['chatRoomId'] != null) {
        return result['chatRoomId'] as String;
      } else {
        state = state.copyWith(
          errorMessage: result['message'] ?? 'Failed to start chat',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isStarting: false, errorMessage: e.toString());
      return null;
    }
  }
}

final startChatProvider =
    NotifierProvider<StartChatViewModel, StartChatState>(
  StartChatViewModel.new,
);
