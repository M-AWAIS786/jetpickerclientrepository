import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class CounterOfferScreen extends ConsumerStatefulWidget {
  final String orderId;
  const CounterOfferScreen({super.key, required this.orderId});

  @override
  ConsumerState<CounterOfferScreen> createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends ConsumerState<CounterOfferScreen> {
  final _counterOfferController = TextEditingController();
  final _orderRepository = OrderRepository();

  bool _isLoading = true;
  bool _isSubmitting = false;
  OrderDetailModel? _order;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  @override
  void dispose() {
    _counterOfferController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final order = await _orderRepository.getOrderDetail(
        token: token,
        orderId: widget.orderId,
      );

      if (mounted) {
        setState(() {
          _order = order;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendCounterOffer() async {
    final amountText = _counterOfferController.text.trim();
    if (amountText.isEmpty) {
      _showSnackBar('Please enter a valid counter offer amount', isError: true);
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showSnackBar('Please enter a valid counter offer amount', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      // Get the latest offer for this order to use as parent_offer_id
      String? parentOfferId;
      try {
        final offersRes = await _orderRepository.getOfferHistory(
          token: token,
          orderId: widget.orderId,
          page: 1,
          limit: 1,
        );
        final offersList = offersRes['data'] ?? offersRes;
        if (offersList is List && offersList.isNotEmpty) {
          parentOfferId = offersList[0]['id']?.toString();
        }
      } catch (_) {
        // Proceed without parent_offer_id
      }

      await _orderRepository.sendCounterOffer(
        token: token,
        orderId: widget.orderId,
        offerAmount: amount,
        parentOfferId: parentOfferId,
      );

      if (mounted) {
        _showSnackBar('Counter offer sent successfully!', isError: false);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to send counter offer', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.red57 : AppColors.green1E,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: ProfileAppBar(
        leadingIcon: true,
        title: AppStrings.counterOffer,
        appBarColor: AppColors.white,
        titleColor: AppColors.red3,
        backBtnColor: AppColors.white,
        backIconColor: AppColors.red3,
        fontSize: 20.sp,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.red3),
      );
    }

    if (_errorMessage != null && _order == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: AppColors.red57),
              16.h.ph,
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.labelGray),
              ),
              24.h.ph,
              SizedBox(
                width: 160.w,
                child: CustomButton(
                  text: 'Retry',
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    _fetchOrderDetails();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_order == null) return const SizedBox.shrink();

    final rewardAmount = _order!.rewardAmount;
    final cs = _order!.currencySymbol;
    final ordererName = _order!.orderer?.fullName ?? 'JetOrderer';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            24.h.ph,

            // ── Route Header ──
            Text(
              'From ${_order!.originCity ?? '?'} – ${_order!.destinationCity ?? '?'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: TextWeight.semiBold,
                  ),
              textAlign: TextAlign.center,
            ),
            8.h.ph,
            if (_order!.createdAt != null)
              Text(
                _formatDate(_order!.createdAt!),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.labelGray),
              ),

            32.h.ph,

            // ── Counter Offer Card ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Info Text ──
                  Text(
                    '$ordererName is offering $cs${rewardAmount.toStringAsFixed(2)} as reward',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.red3,
                          fontWeight: TextWeight.semiBold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  8.h.ph,
                  Text(
                    'set your own counter offer',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.red3,
                          fontWeight: TextWeight.semiBold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  40.h.ph,

                  // ── Counter Offer Input ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.myCounterOffer,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                            fontWeight: TextWeight.semiBold,
                          ),
                    ),
                  ),
                  12.h.ph,
                  TextFormField(
                    controller: _counterOfferController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    cursorColor: AppColors.red3,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                          fontWeight: TextWeight.semiBold,
                        ),
                    decoration: InputDecoration(
                      prefixText: '$cs ',
                      prefixStyle:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.labelGray,
                                fontWeight: TextWeight.semiBold,
                              ),
                      hintText: '0.00',
                      hintStyle:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.lightGray,
                              ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greyDD,
                          width: 2,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.red3,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  24.h.ph,

                  // ── Info hint ──
                  Text(
                    'Enter an amount you\'d like to negotiate for this delivery',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.labelGray,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            40.h.ph,

            // ── Send Button ──
            SizedBox(
              width: 200.w,
              child: CustomButton(
                text: _isSubmitting ? 'Sending...' : AppStrings.send,
                onPressed: _isSubmitting ? null : _sendCounterOffer,
                isLoading: _isSubmitting,
                btnHeight: 50.h,
                radius: 12.r,
              ),
            ),

            32.h.ph,
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
