class AppUrls {
  static const String baseUrl = 'https://api.jetpicks.com/api';
  static const String storageUrl = 'https://api.jetpicks.com'; // for relative paths like /storage/...
  static const String loginUrl = '$baseUrl/auth/login';
  static const String signupUrl = '$baseUrl/auth/register';
  static const String countriesUrl = '$baseUrl/locations/countries';
  static const String citiesUrl = '$baseUrl/locations/cities';
  static const String travelJourneysUrl = '$baseUrl/travel-journeys';

  // User Profile
  static const String userProfileUrl = '$baseUrl/user/profile';
  static const String userAvatarUrl = '$baseUrl/user/avatar';

  // Picker Orders
  static const String pickerOrdersUrl = '$baseUrl/orders/picker/history';
  static String orderDetailUrl(String orderId) => '$baseUrl/orders/$orderId';
  static String acceptOrderUrl(String orderId) => '$baseUrl/orders/$orderId/accept';
  static String markDeliveredUrl(String orderId) => '$baseUrl/orders/$orderId/mark-delivered';
  static String deliveryStatusUrl(String orderId) => '$baseUrl/orders/$orderId/delivery-status';

  /// Converts a relative path e.g. /storage/avatars/x.jpg → full URL
  static String resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path; // already full URL
    return '$storageUrl$path';
  }
}