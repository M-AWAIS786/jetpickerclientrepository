import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/notification/notification_model.dart';
import 'package:jet_picks_app/App/repo/notification_repository.dart';

// ─────────────────────────────────────────────────────────────
// State — mirrors the web GlobalNotificationContext
// ─────────────────────────────────────────────────────────────
class GlobalNotificationState {
  // Picker: NEW_ORDER_AVAILABLE
  final NewOrderNotification? newOrderNotification;
  final List<NewOrderNotification> newOrdersHistory;
  final bool showNewOrderModal;

  // Orderer: ORDER_ACCEPTED
  final AcceptedOrderNotification? acceptedOrderNotification;
  final List<AcceptedOrderNotification> acceptedOrdersHistory;
  final bool showAcceptedOrderModal;

  // Orderer: COUNTER_OFFER_RECEIVED
  final CounterOfferNotification? counterOfferNotification;
  final List<CounterOfferNotification> counterOffersHistory;
  final bool showCounterOfferModal;

  // Badge count
  final int unreadCount;

  const GlobalNotificationState({
    this.newOrderNotification,
    this.newOrdersHistory = const [],
    this.showNewOrderModal = false,
    this.acceptedOrderNotification,
    this.acceptedOrdersHistory = const [],
    this.showAcceptedOrderModal = false,
    this.counterOfferNotification,
    this.counterOffersHistory = const [],
    this.showCounterOfferModal = false,
    this.unreadCount = 0,
  });

  GlobalNotificationState copyWith({
    NewOrderNotification? newOrderNotification,
    List<NewOrderNotification>? newOrdersHistory,
    bool? showNewOrderModal,
    AcceptedOrderNotification? acceptedOrderNotification,
    List<AcceptedOrderNotification>? acceptedOrdersHistory,
    bool? showAcceptedOrderModal,
    CounterOfferNotification? counterOfferNotification,
    List<CounterOfferNotification>? counterOffersHistory,
    bool? showCounterOfferModal,
    int? unreadCount,
    bool clearNewOrder = false,
    bool clearAccepted = false,
    bool clearCounter = false,
  }) {
    return GlobalNotificationState(
      newOrderNotification: clearNewOrder
          ? null
          : newOrderNotification ?? this.newOrderNotification,
      newOrdersHistory: newOrdersHistory ?? this.newOrdersHistory,
      showNewOrderModal: showNewOrderModal ?? this.showNewOrderModal,
      acceptedOrderNotification: clearAccepted
          ? null
          : acceptedOrderNotification ?? this.acceptedOrderNotification,
      acceptedOrdersHistory:
          acceptedOrdersHistory ?? this.acceptedOrdersHistory,
      showAcceptedOrderModal:
          showAcceptedOrderModal ?? this.showAcceptedOrderModal,
      counterOfferNotification: clearCounter
          ? null
          : counterOfferNotification ?? this.counterOfferNotification,
      counterOffersHistory:
          counterOffersHistory ?? this.counterOffersHistory,
      showCounterOfferModal:
          showCounterOfferModal ?? this.showCounterOfferModal,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ViewModel — polling every 3 seconds like the web frontend
// ─────────────────────────────────────────────────────────────
class GlobalNotificationViewModel extends Notifier<GlobalNotificationState> {
  late final NotificationRepository _repo;
  Timer? _pollTimer;
  Timer? _autoCloseTimer;

  // Track already-shown notification IDs (matching web's shownXxxRef)
  final Set<String> _shownNewOrders = {};
  final Set<String> _shownAcceptedOrders = {};
  final Set<String> _shownCounterOffers = {};

  @override
  GlobalNotificationState build() {
    _repo = NotificationRepository();
    _startPolling();
    ref.onDispose(_stopPolling);
    return const GlobalNotificationState();
  }

  void _startPolling() {
    // Initial fetch
    _poll();
    // Poll every 3 seconds (matching web frontend)
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _poll(),
    );
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _autoCloseTimer?.cancel();
  }

  Future<void> _poll() async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) return;

      final activeRole = await UserPreferences.getActiveRole() ?? 'PICKER';
      final response = await _repo.getNotifications(token: token);
      final notifications = response.data;

      // Count unread
      final unread = notifications.where((n) => !n.isRead).length;

      if (activeRole == 'PICKER') {
        _processPicker(notifications, unread);
      } else {
        _processOrderer(notifications, unread);
      }
    } catch (_) {
      // Silently fail during polling — matches web behavior
    }
  }

  void _processPicker(List<AppNotification> notifications, int unread) {
    final newOrderNotifs = notifications
        .where((n) => n.type == 'NEW_ORDER_AVAILABLE')
        .map((n) => NewOrderNotification.fromNotification(n))
        .toList();

    // Check for cancelled — remove from shown set
    final currentIds = newOrderNotifs.map((n) => n.id).toSet();
    _shownNewOrders.removeWhere((id) => !currentIds.contains(id));

    // If the currently displayed notification was removed, close modal
    if (state.newOrderNotification != null &&
        !currentIds.contains(state.newOrderNotification!.id)) {
      state = state.copyWith(
        showNewOrderModal: false,
        clearNewOrder: true,
        newOrdersHistory: newOrderNotifs,
        unreadCount: unread,
      );
      return;
    }

    // Show newest unshown notification
    NewOrderNotification? toShow;
    if (newOrderNotifs.isNotEmpty) {
      final newest = newOrderNotifs.first;
      if (!_shownNewOrders.contains(newest.id)) {
        _shownNewOrders.add(newest.id);
        toShow = newest;
      }
    }

    state = state.copyWith(
      newOrdersHistory: newOrderNotifs,
      unreadCount: unread,
      newOrderNotification: toShow,
      showNewOrderModal: toShow != null ? true : null,
    );

    if (toShow != null) {
      _scheduleAutoClose();
    }
  }

  void _processOrderer(List<AppNotification> notifications, int unread) {
    final acceptedList = <AcceptedOrderNotification>[];
    final counterList = <CounterOfferNotification>[];

    AcceptedOrderNotification? newAccepted;
    CounterOfferNotification? newCounter;

    for (final n in notifications) {
      if (n.type == 'ORDER_ACCEPTED') {
        final typed = AcceptedOrderNotification.fromNotification(n);
        acceptedList.add(typed);

        if (!_shownAcceptedOrders.contains(n.entityId)) {
          _shownAcceptedOrders.add(n.entityId);
          newAccepted = typed;
        }
      } else if (n.type == 'COUNTER_OFFER_RECEIVED') {
        final typed = CounterOfferNotification.fromNotification(n);
        counterList.add(typed);

        if (!_shownCounterOffers.contains(n.entityId)) {
          _shownCounterOffers.add(n.entityId);
          newCounter = typed;
        }
      }
    }

    state = state.copyWith(
      acceptedOrdersHistory: acceptedList,
      counterOffersHistory: counterList,
      unreadCount: unread,
      acceptedOrderNotification: newAccepted,
      showAcceptedOrderModal: newAccepted != null ? true : null,
      counterOfferNotification: newCounter,
      showCounterOfferModal: newCounter != null ? true : null,
    );

    if (newAccepted != null || newCounter != null) {
      _scheduleAutoClose();
    }
  }

  void _scheduleAutoClose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      state = state.copyWith(
        showNewOrderModal: false,
        showAcceptedOrderModal: false,
        showCounterOfferModal: false,
      );
    });
  }

  // ── Actions (matching web's handleXxxClick) ──

  void dismissNewOrderModal() {
    state = state.copyWith(showNewOrderModal: false);
  }

  void dismissAcceptedOrderModal() {
    state = state.copyWith(showAcceptedOrderModal: false);
  }

  void dismissCounterOfferModal() {
    state = state.copyWith(showCounterOfferModal: false);
  }

  Future<void> markNewOrderRead(String notificationId) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) return;
      await _repo.markAsRead(token: token, notificationId: notificationId);
      state = state.copyWith(
        showNewOrderModal: false,
        newOrdersHistory: state.newOrdersHistory
            .map((n) => n.id == notificationId
                ? NewOrderNotification(
                    id: n.id,
                    orderId: n.orderId,
                    ordererName: n.ordererName,
                    originCity: n.originCity,
                    originCountry: n.originCountry,
                    destinationCity: n.destinationCity,
                    destinationCountry: n.destinationCountry,
                    rewardAmount: n.rewardAmount,
                    isRead: true,
                    timestamp: n.timestamp,
                  )
                : n)
            .toList(),
      );
    } catch (_) {}
  }

  Future<void> markAcceptedOrderRead(String notificationId) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) return;
      await _repo.markAsRead(token: token, notificationId: notificationId);
      state = state.copyWith(showAcceptedOrderModal: false);
    } catch (_) {}
  }

  Future<void> markCounterOfferRead(String notificationId) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) return;
      await _repo.markAsRead(token: token, notificationId: notificationId);
      state = state.copyWith(showCounterOfferModal: false);
    } catch (_) {}
  }
}

// ─────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────
final globalNotificationProvider =
    NotifierProvider<GlobalNotificationViewModel, GlobalNotificationState>(
  GlobalNotificationViewModel.new,
);
