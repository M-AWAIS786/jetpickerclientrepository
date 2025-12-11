import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import '../../../widgets/custom_searchbar.dart';
import '../../../widgets/jetorders_history_card.dart';

class OrdererOrderScreen extends StatefulWidget {
  const OrdererOrderScreen({super.key});

  @override
  State<OrdererOrderScreen> createState() => _OrdererOrderScreenState();
}

class _OrdererOrderScreenState extends State<OrdererOrderScreen> {
  String selectedTab = "All";
  final tabs = ["All", "Pending", "Delivered", "Cancelled"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProfileAppBar(
            statusBarIconBrightness: Brightness.dark,
            title: AppStrings.jetOrdererHistory,
            titleColor: AppColors.black,
            appBarColor: AppColors.yellow3,
            bellColor: AppColors.black,
            bottomHeight: 30.h,
          ),
          Transform.translate(
            offset: Offset(0.0, -20.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomSearchBar(
                prefixColor: AppColors.labelGray,
                sufixColor: AppColors.labelGray,
              ),
            ),
          ),
          10.h.ph,
          _buildTabs(),

          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: JetOrdersHistoryCard(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final bool isSelected = selectedTab == tab;

          return GestureDetector(
            onTap: () => setState(() => selectedTab = tab),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.yellow3 : AppColors.white,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Text(
                  tab,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected ? AppColors.black : AppColors.labelGray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
