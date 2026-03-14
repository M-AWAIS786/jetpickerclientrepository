/// Stripe configuration constants
class StripeConfig {
  /// Your Stripe publishable key from the Stripe Dashboard
  /// Replace with your actual publishable key
  static const String publishableKey = 'pk_test_51T8zAw64GEMFPJS7SnlZBR4brI5BEE5uboBA72kOLXA18s1fdS7qvJ3uegU2TN2NUN5CQAsEuuwbNXLo8E2tXJwL005JuR49ih';
  
  /// Merchant identifier for Apple Pay (iOS)
  static const String merchantIdentifier = 'merchant.com.jetpicks.app';
  
  /// Enable Apple Pay
  static const bool enableApplePay = true;
  
  /// Enable Google Pay
  static const bool enableGooglePay = true;
}
