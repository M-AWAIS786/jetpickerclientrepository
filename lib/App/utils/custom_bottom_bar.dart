import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.shopping_bag_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  final List<String> labels = ["Home", "Orders", "Chat", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(color: AppColors.redLight),
      child: Row(
        children: List.generate(icons.length, (index) {
          final bool isSelected = widget.currentIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                widget.onTabSelected(index);
              },
              child: Container(
                color: isSelected
                    ? const Color(0xff4C0014) // dark selected background
                    : Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff4C0014),
                      size: 28,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xff4C0014),
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
