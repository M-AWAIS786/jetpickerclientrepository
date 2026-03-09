import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/notification/notification_model.dart';

class NotificationRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  /// GET /api/notifications?page=&limit=
  Future<NotificationsResponse> getNotifications({
    required String token,
    int page = 1,
    int limit = 100,
  }) async {
    final url = '${AppUrls.notificationsUrl}?page=$page&limit=$limit';
    final response = await _apiServices.getApi(url, token);
    return NotificationsResponse.fromJson(response);
  }

  /// GET /api/notifications/unread-count
  Future<int> getUnreadCount({required String token}) async {
    final response = await _apiServices.getApi(AppUrls.unreadCountUrl, token);
    return response['count'] as int? ?? response['data'] as int? ?? 0;
  }

  /// PUT /api/notifications/{id}/read
  Future<void> markAsRead({
    required String token,
    required String notificationId,
  }) async {
    final url = AppUrls.markNotificationReadUrl(notificationId);
    await _apiServices.putApi({}, url, token);
  }

  /// DELETE /api/notifications/{id}
  Future<void> deleteNotification({
    required String token,
    required String notificationId,
  }) async {
    final url = AppUrls.deleteNotificationUrl(notificationId);
    await _apiServices.deleteApi(url, token, null);
  }
}
