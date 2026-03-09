import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/utils/picker_bottom_bar.dart';
import 'package:jet_picks_app/App/view_model/notification/global_notification_view_model.dart';
import 'package:jet_picks_app/App/widgets/notification_overlay.dart';

import '../../data/bottom_bar_data.dart';

class PickerBottomBarScreen extends ConsumerStatefulWidget {
  const PickerBottomBarScreen({super.key});

  @override
  ConsumerState<PickerBottomBarScreen> createState() =>
      _PickerBottomBarScreenState();
}

class _PickerBottomBarScreenState
    extends ConsumerState<PickerBottomBarScreen> {
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
        child: screens[currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: PickerBottomBar(
          currentIndex: currentIndex,
          onTabSelected: (index) {
            setState(() => currentIndex = index);
          },
        ),
      ),
    );
  }
}