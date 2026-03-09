import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/bottom_bar_data.dart';
import 'package:jet_picks_app/App/utils/orderer_bottom_bar.dart';
import 'package:jet_picks_app/App/view_model/notification/global_notification_view_model.dart';
import 'package:jet_picks_app/App/widgets/notification_overlay.dart';

class OrdererBottomBarScreen extends ConsumerStatefulWidget {
  const OrdererBottomBarScreen({super.key});

  @override
  ConsumerState<OrdererBottomBarScreen> createState() =>
      _OrdererBottomBarScreenState();
}

class _OrdererBottomBarScreenState
    extends ConsumerState<OrdererBottomBarScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the global notification polling
    ref.read(globalNotificationProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationOverlay(
        child: ordererscreens[currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: OrdererBottomBar(
          currentIndex: currentIndex,
          onTabSelected: (index) {
            setState(() => currentIndex = index);
          },
        ),
      ),
    );
  }
}