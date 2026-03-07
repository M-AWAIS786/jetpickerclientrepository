import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/chat/chat_models.dart';

class ChatRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  /// POST /api/chat-rooms/get-or-create
  Future<Map<String, dynamic>> getOrCreateChatRoom({
    required String token,
    required String orderId,
    required String pickerId,
  }) async {
    final response = await _apiServices.postApi(
      {'order_id': orderId, 'picker_id': pickerId},
      AppUrls.getOrCreateChatRoomUrl,
      token,
    );
    if (response is Map<String, dynamic>) return response;
    return <String, dynamic>{};
  }

  /// GET /api/chat-rooms?page=&limit=
  Future<List<ChatListItemModel>> getChatRooms({
    required String token,
    int page = 1,
    int limit = 50,
  }) async {
    final url = '${AppUrls.chatRoomsUrl}?page=$page&limit=$limit';
    final response = await _apiServices.getApi(url, token);

    // The API may return: { "data": [ ... ] }  OR  [ ... ] directly
    final List<dynamic> items = _extractList(response);
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => ChatListItemModel.fromJson(e))
        .toList();
  }

  /// GET /api/chat-rooms/{roomId}
  Future<ChatRoomModel> getChatRoomDetail({
    required String token,
    required String roomId,
  }) async {
    final url = AppUrls.chatRoomDetailUrl(roomId);
    final response = await _apiServices.getApi(url, token);

    // The API may return: { "data": { ... } }  OR  { ... } directly
    final Map<String, dynamic> data =
        response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map
            ? Map<String, dynamic>.from(response['data'])
            : (response is Map<String, dynamic> ? response : <String, dynamic>{});
    return ChatRoomModel.fromJson(data);
  }

  /// GET /api/chat-rooms/{roomId}/messages?page=&limit=
  Future<List<ChatMessageModel>> getMessages({
    required String token,
    required String roomId,
    int page = 1,
    int limit = 50,
  }) async {
    final url =
        '${AppUrls.chatRoomMessagesUrl(roomId)}?page=$page&limit=$limit';
    final response = await _apiServices.getApi(url, token);

    // The API may return:
    //   { "data": { "data": [...] } }   (paginated)
    //   { "data": [...] }               (flat list under data)
    //   [ ... ]                          (direct list)
    final List<dynamic> items = _extractList(response);
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => ChatMessageModel.fromJson(e))
        .toList();
  }

  /// POST /api/chat-rooms/{roomId}/messages
  Future<ChatMessageModel> sendMessage({
    required String token,
    required String roomId,
    required String content,
    bool translate = false,
  }) async {
    final url = AppUrls.chatRoomMessagesUrl(roomId);
    final response = await _apiServices.postApi(
      {'content': content, 'translate': translate},
      url,
      token,
    );

    // The API may return:
    //   { "data": { "data": { ... } } }
    //   { "data": { ... } }
    //   { ... }  (message directly)
    final Map<String, dynamic> data = _extractMap(response);
    return ChatMessageModel.fromJson(data);
  }

  /// PUT /api/chat-messages/{messageId}/read
  Future<void> markMessageAsRead({
    required String token,
    required String messageId,
  }) async {
    final url = AppUrls.markMessageReadUrl(messageId);
    await _apiServices.putApi({}, url, token);
  }

  // ── Helpers to safely navigate unknown response shapes ──

  /// Drills into a response to find the inner-most List.
  List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;

    if (response is Map<String, dynamic>) {
      final dataField = response['data'];

      // { "data": { "data": [...] } }  (paginated)
      if (dataField is Map<String, dynamic> && dataField['data'] is List) {
        return dataField['data'] as List<dynamic>;
      }

      // { "data": [...] }
      if (dataField is List) return dataField;
    }

    return [];
  }

  /// Drills into a response to find the inner-most single Map object.
  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      final dataField = response['data'];

      // { "data": { "data": { ... } } }
      if (dataField is Map<String, dynamic>) {
        final innerData = dataField['data'];
        if (innerData is Map<String, dynamic>) return innerData;
        return dataField;
      }

      // No "data" key — the response itself is the object
      return response;
    }

    return <String, dynamic>{};
  }
}
