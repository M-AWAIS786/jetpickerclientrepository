import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/utils/picker_bottom_bar.dart';

import '../../data/bottom_bar_data.dart';

class PickerBottomBarScreen extends StatefulWidget {
  const PickerBottomBarScreen({super.key});

  @override
  State<PickerBottomBarScreen> createState() => _PickerBottomBarScreenState();
}

class _PickerBottomBarScreenState extends State<PickerBottomBarScreen> {
 int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: screens[currentIndex],
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