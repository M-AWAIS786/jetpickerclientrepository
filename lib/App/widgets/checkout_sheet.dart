import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/models/stripe/stripe_models.dart';
import 'package:jet_picks_app/App/view_model/payment/payment_view_model.dart';

/// Checkout Bottom Sheet matching web's CheckoutModal.tsx
/// 
/// Usage:
/// ```dart
/// CheckoutSheet.show(
///   context: context,
///   ref: ref,
///   amount: 5000, // in cents
///   currency: 'usd',
///   description: 'Order #123',
///   orderId: '123',
///   onSuccess: () => print('Payment successful!'),
/// );
/// ```
class CheckoutSheet extends ConsumerStatefulWidget {
  final int amount; // Amount in cents
  final String currency;
  final String? description;
  final String? customerEmail;
  final Map<String, dynamic>? metadata;
  final String? orderId;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const CheckoutSheet({
    super.key,
    required this.amount,
    required this.currency,
    this.description,
    this.customerEmail,
    this.metadata,
    this.orderId,
    this.onSuccess,
    this.onCancel,
  });

  /// Show the checkout sheet as a modal bottom sheet
  static Future<bool?> show({
    required BuildContext context,
    required WidgetRef ref,
    required int amount,
    required String currency,
    String? description,
    String? customerEmail,
    Map<String, dynamic>? metadata,
    String? orderId,
    VoidCallback? onSuccess,
    VoidCallback? onCancel,
  }) {
    // Reset the provider before showing a new checkout sheet
    ref.read(paymentProvider.notifier).reset();
    
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutSheet(
        amount: amount,
        currency: currency,
        description: description,
        customerEmail: customerEmail,
        metadata: metadata,
        orderId: orderId,
        onSuccess: onSuccess,
        onCancel: onCancel,
      ),
    );
  }

  @override
  ConsumerState<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<CheckoutSheet> {
  bool _isInitialized = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    // Defer initialization to after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePayment();
    });
  }

  Future<void> _initializePayment() async {
    if (_isInitializing) return; // Prevent duplicate calls
    _isInitializing = true;
    
    final success = await ref.read(paymentProvider.notifier).createPaymentIntent(
      amount: widget.amount,
      currency: widget.currency,
      description: widget.description,
      customerEmail: widget.customerEmail,
      metadata: widget.metadata,
      orderId: widget.orderId,
    );

    if (mounted) {
      setState(() {
        _isInitialized = success;
        _isInitializing = false;
      });
    }
  }

  Future<void> _handlePayNow() async {
    final success = await ref.read(paymentProvider.notifier).presentPaymentSheet();
    
    if (success && mounted) {
      widget.onSuccess?.call();
      Navigator.of(context).pop(true);
    }
  }

  void _handleRetry() {
    setState(() {
      _isInitialized = false;
      _isInitializing = false;
    });
    ref.read(paymentProvider.notifier).reset();
    _initializePayment();
  }

  @override
  void dispose() {
    // Don't reset provider in dispose to avoid issues
    // The provider will be reset when showing a new checkout sheet
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Checkout',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onCancel?.call();
                      Navigator.of(context).pop(false);
                    },
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Payment Summary
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.yellow3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$${formatAmountFromCents(widget.amount)}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          widget.currency.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (widget.description != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        widget.description!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Error State
              if (state.status == PaymentStatus.error && state.errorMessage != null)
                Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600], size: 20.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.errorMessage!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: _handleRetry,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Loading State
              if (state.status == PaymentStatus.loading && !_isInitialized)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.yellow3,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Initializing payment...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

              // Pay Now Button
              if (_isInitialized && state.status != PaymentStatus.error)
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: state.status == PaymentStatus.loading ? null : _handlePayNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow3,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: state.status == PaymentStatus.loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  color: Colors.grey[900],
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Pay Now',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                  ),
                ),

              SizedBox(height: 16.h),

              // Security note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 14.sp, color: Colors.grey[500]),
                  SizedBox(width: 6.w),
                  Text(
                    'Secure payment powered by Stripe',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
