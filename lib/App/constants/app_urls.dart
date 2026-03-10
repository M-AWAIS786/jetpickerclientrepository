class AppUrls {
  static const String baseUrl = 'https://api.jetpicks.com/api';
  static const String storageUrl = 'https://api.jetpicks.com'; 
  static const String loginUrl = '$baseUrl/auth/login';
  static const String signupUrl = '$baseUrl/auth/register';
  static const String googleLoginUrl = '$baseUrl/auth/google-login';
  static const String countriesUrl = '$baseUrl/locations/countries';
  static const String citiesUrl = '$baseUrl/locations/cities';
  static const String travelJourneysUrl = '$baseUrl/travel-journeys';
  // User Profile
  static const String userProfileUrl = '$baseUrl/user/profile';
  static const String userAvatarUrl = '$baseUrl/user/avatar';
  // Picker Orders
  static const String pickerOrdersUrl = '$baseUrl/orders/picker/history';
  // Picker Dashboard
  static const String pickerDashboardUrl = '$baseUrl/dashboard/picker';
  // Orderer Orders
  static const String ordererOrdersUrl = '$baseUrl/orders';
  static String cancelOrderUrl(String orderId) => '$baseUrl/orders/$orderId';
  static String orderDetailUrl(String orderId) => '$baseUrl/orders/$orderId';
  static String acceptOrderUrl(String orderId) => '$baseUrl/orders/$orderId/accept';
  static String markDeliveredUrl(String orderId) => '$baseUrl/orders/$orderId/mark-delivered';
  static String deliveryStatusUrl(String orderId) => '$baseUrl/orders/$orderId/delivery-status';
  // Orderer specific actions
  static String confirmDeliveryUrl(String orderId) => '$baseUrl/orders/$orderId/confirm-delivery';
  static String reportIssueUrl(String orderId) => '$baseUrl/orders/$orderId/report-issue';
  static const String reviewsUrl = '$baseUrl/reviews';
  static const String tipsUrl = '$baseUrl/tips';
  // Offers
  static String offerHistoryUrl(String orderId) => '$baseUrl/orders/$orderId/offers';
  static const String createOfferUrl = '$baseUrl/offers';
  static String acceptOfferUrl(String offerId) => '$baseUrl/offers/$offerId/accept';
  static String rejectOfferUrl(String offerId) => '$baseUrl/offers/$offerId/reject';
  // Orderer Dashboard
  static const String ordererDashboardUrl = '$baseUrl/orders/available';

  // ── Create Order Flow ──
  static const String createOrderUrl = '$baseUrl/orders';
  static String updateOrderUrl(String orderId) => '$baseUrl/orders/$orderId';
  static String orderItemsUrl(String orderId) => '$baseUrl/orders/$orderId/items';
  static String deleteOrderItemsUrl(String orderId) => '$baseUrl/orders/$orderId/items';
  static String setRewardUrl(String orderId) => '$baseUrl/orders/$orderId/reward';
  static String finalizeOrderUrl(String orderId) => '$baseUrl/orders/$orderId/finalize';
  // Orderer Dashboard (available pickers)
  static const String ordererDashboardPickersUrl = '$baseUrl/dashboard/orderer';
  // Active draft
  static const String activeDraftOrderUrl = '$baseUrl/orders?status=DRAFT&page=1&limit=1';

  // ── Chat ──
  static const String chatRoomsUrl = '$baseUrl/chat-rooms';
  static const String getOrCreateChatRoomUrl = '$baseUrl/chat-rooms/get-or-create';
  static String chatRoomDetailUrl(String roomId) => '$baseUrl/chat-rooms/$roomId';
  static String chatRoomMessagesUrl(String roomId) => '$baseUrl/chat-rooms/$roomId/messages';
  static String markMessageReadUrl(String messageId) => '$baseUrl/chat-messages/$messageId/read';

  // ── Notifications ──
  static const String notificationsUrl = '$baseUrl/notifications';
  static const String unreadCountUrl = '$baseUrl/notifications/unread-count';
  static String markNotificationReadUrl(String id) =>
      '$baseUrl/notifications/$id/read';
  static String deleteNotificationUrl(String id) =>
      '$baseUrl/notifications/$id';

  /// Converts a relative path e.g. /storage/avatars/x.jpg → full URL
  static String resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path; // already full URL
    return '$storageUrl$path';
  }
}