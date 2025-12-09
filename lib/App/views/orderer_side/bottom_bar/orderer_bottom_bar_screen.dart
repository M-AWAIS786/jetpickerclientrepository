import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/data/bottom_bar_data.dart';
import 'package:jet_picks_app/App/utils/orderer_bottom_bar.dart';

class OrdererBottomBarScreen extends StatefulWidget {
  const OrdererBottomBarScreen({super.key});

  @override
  State<OrdererBottomBarScreen> createState() => _OrdererBottomBarScreenState();
}

class _OrdererBottomBarScreenState extends State<OrdererBottomBarScreen> {
 int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ordererscreens[currentIndex],
      bottomNavigationBar: OrdererBottomBar(
        currentIndex: currentIndex,
        onTabSelected: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}