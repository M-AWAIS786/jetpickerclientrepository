import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_chat/orderer_chat_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_home/orderer_home_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_order/orderer_order_screen.dart';
import 'package:jet_picks_app/App/views/orderer_side/orderer_profile/orderer_profile_screen.dart';

import '../views/chat_screen/chat_screen.dart';
import '../views/picker_view/p_home_screen/p_home_screen.dart';
import '../views/picker_view/p_order_screen/order_screen.dart';
import '../views/picker_view/p_profile_screen/profile_screen.dart';

final List<String> icons = [
  AppImages.homeIcon,
  AppImages.orderLagageIcon,
  AppImages.chatIcon,
  AppImages.userIcon,
];

final List<String> labels = [
  AppStrings.home,
  AppStrings.orders,
  AppStrings.chats,
  AppStrings.profile,
];


final List<Widget> screens = [
    HomeScreen(),
    OrderScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

final List<Widget> ordererscreens = [
    OrdererHomeScreen(),
    OrdererOrderScreen(),
    OrdererChatScreen(),
    OrdererProfileScreen(),
  ];