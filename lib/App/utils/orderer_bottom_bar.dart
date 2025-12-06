import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../data/bottom_bar_data.dart';

class OrdererBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  const OrdererBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(color: AppColors.yellow1),
      child: Row(
        children: List.generate(icons.length, (index) {
          final bool isSelected = currentIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                onTabSelected(index);
              },
              child: Container(
                color: isSelected ? AppColors.yellow3 : Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SharePictures(
                      imagePath: icons[index],
                      colorFilter: ColorFilter.mode(
                        isSelected ? AppColors.black : AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),

                    5.h.ph,
                    Text(
                      labels[index],
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected ? AppColors.black : AppColors.black,
                        fontWeight: TextWeight.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
