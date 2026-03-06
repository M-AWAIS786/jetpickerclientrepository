import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';

class OrderDetailState {
  final bool isLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final String? successMessage;
  final OrderDetailModel? order;
  final bool showUploadSection;
  final File? uploadedProofFile;
  final String? uploadedFileName;
  final double? uploadedFileSizeMB;
  final bool agreedToTerms;
  final bool agreedToCustomLaws;
  final bool hasCounterOffer;

  const OrderDetailState({
    this.isLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.successMessage,
    this.order,
    this.showUploadSection = false,
    this.uploadedProofFile,
    this.uploadedFileName,
    this.uploadedFileSizeMB,
    this.agreedToTerms = false,
    this.agreedToCustomLaws = false,
    this.hasCounterOffer = false,
  });

  bool get canProceed => agreedToTerms && agreedToCustomLaws;

  OrderDetailState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    String? errorMessage,
    String? successMessage,
    OrderDetailModel? order,
    bool clearError = false,
    bool clearSuccess = false,
    bool? showUploadSection,
    File? uploadedProofFile,
    String? uploadedFileName,
    double? uploadedFileSizeMB,
    bool clearProofFile = false,
    bool? agreedToTerms,
    bool? agreedToCustomLaws,
    bool? hasCounterOffer,
  }) {
    return OrderDetailState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      order: order ?? this.order,
      showUploadSection: showUploadSection ?? this.showUploadSection,
      uploadedProofFile: clearProofFile ? null : uploadedProofFile ?? this.uploadedProofFile,
      uploadedFileName: clearProofFile ? null : uploadedFileName ?? this.uploadedFileName,
      uploadedFileSizeMB: clearProofFile ? null : uploadedFileSizeMB ?? this.uploadedFileSizeMB,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      agreedToCustomLaws: agreedToCustomLaws ?? this.agreedToCustomLaws,
      hasCounterOffer: hasCounterOffer ?? this.hasCounterOffer,
    );
  }
}

class OrderDetailViewModel extends Notifier<OrderDetailState> {
  late final OrderRepository _orderRepository;

  @override
  OrderDetailState build() {
    _orderRepository = OrderRepository();
    return const OrderDetailState();
  }

  Future<void> fetchOrderDetail(String orderId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final order = await _orderRepository.getOrderDetail(
        token: token,
        orderId: orderId,
      );

      // Check if a counter offer already exists for this order
      bool counterOfferExists = false;
      try {
        final offersRes = await _orderRepository.getOfferHistory(
          token: token,
          orderId: orderId,
        );
        final offersList = offersRes['data'] ?? offersRes;
        if (offersList is List) {
          counterOfferExists = offersList.any((offer) =>
              offer['offer_type'] == 'COUNTER' &&
              (offer['status'] == 'PENDING' || offer['status'] == 'ACCEPTED'));
        }
      } catch (_) {
        // Silently fail – don't block the order detail from loading
      }

      state = state.copyWith(
        isLoading: false,
        order: order,
        hasCounterOffer: counterOfferExists,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void toggleAgreedToTerms(bool value) {
    state = state.copyWith(agreedToTerms: value);
  }

  void toggleAgreedToCustomLaws(bool value) {
    state = state.copyWith(agreedToCustomLaws: value);
  }

  Future<void> acceptOrder() async {
    if (state.order == null) return;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.acceptOrder(
        token: token,
        orderId: state.order!.id,
      );

      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Order accepted successfully!',
      );

      // Refresh order details
      await fetchOrderDetail(state.order!.id);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, errorMessage: e.toString());
    }
  }

  void toggleUploadSection() {
    state = state.copyWith(
      showUploadSection: !state.showUploadSection,
      clearError: true,
    );
  }

  void setProofFile(File file, String fileName, double fileSizeMB) {
    state = state.copyWith(
      uploadedProofFile: file,
      uploadedFileName: fileName,
      uploadedFileSizeMB: fileSizeMB,
      clearError: true,
    );
  }

  void clearProofFile() {
    state = state.copyWith(clearProofFile: true);
  }

  Future<void> markDelivered() async {
    if (state.order == null || state.uploadedProofFile == null) return;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.markDelivered(
        token: token,
        orderId: state.order!.id,
        proofFile: state.uploadedProofFile!,
      );

      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Order marked as delivered!',
        showUploadSection: false,
        clearProofFile: true,
      );

      // Refresh order details
      await fetchOrderDetail(state.order!.id);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> confirmDeliveryOrderer() async {
    if (state.order == null) return;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.confirmDeliveryOrderer(
        token: token,
        orderId: state.order!.id,
      );

      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Delivery confirmed successfully!',
      );

      await fetchOrderDetail(state.order!.id);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> reportIssueOrderer(String reason) async {
    if (state.order == null) return;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.reportIssue(
        token: token,
        orderId: state.order!.id,
        reason: reason,
      );

      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Issue reported successfully!',
      );

      await fetchOrderDetail(state.order!.id);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> submitReviewOrderer({
    required int rating,
    required String comment,
    required String revieweeId,
  }) async {
    if (state.order == null) return;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.submitReview(
        token: token,
        orderId: state.order!.id,
        rating: rating,
        comment: comment,
        revieweeId: revieweeId,
      );

      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Review submitted successfully!',
      );

      await fetchOrderDetail(state.order!.id);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> submitTipOrderer(double amount) async {
    if (state.order == null) return;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.submitTip(
        token: token,
        orderId: state.order!.id,
        amount: amount,
      );

      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Tip submitted successfully!',
      );

      await fetchOrderDetail(state.order!.id);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, errorMessage: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final orderDetailProvider =
    NotifierProvider<OrderDetailViewModel, OrderDetailState>(
  OrderDetailViewModel.new,
);
