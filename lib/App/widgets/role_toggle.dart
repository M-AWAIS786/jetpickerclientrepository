import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';

/// A toggle button that lets users switch between PICKER and ORDERER roles.
/// Matches the web frontend's RoleToggle component behavior.
class RoleToggle extends StatefulWidget {
  final String currentRole; // 'PICKER' or 'ORDERER'

  const RoleToggle({super.key, required this.currentRole});

  @override
  State<RoleToggle> createState() => _RoleToggleState();
}

class _RoleToggleState extends State<RoleToggle> {
  bool _canSwitch = false;

  @override
  void initState() {
    super.initState();
    _checkCanSwitch();
  }

  Future<void> _checkCanSwitch() async {
    final canSwitch = await UserPreferences.canSwitchRole();
    if (mounted) {
      setState(() => _canSwitch = canSwitch);
    }
  }

  Future<void> _handleToggle() async {
    final otherRole =
        widget.currentRole == 'PICKER' ? 'ORDERER' : 'PICKER';

    await UserPreferences.saveActiveRole(otherRole);

    if (!mounted) return;

    if (otherRole == 'PICKER') {
      context.go(AppRoutes.pickerBottomBarScreen);
    } else {
      context.go(AppRoutes.ordererBottomBarScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_canSwitch) return const SizedBox.shrink();

    final isPickerMode = widget.currentRole == 'PICKER';
    final activeColor = isPickerMode ? AppColors.red3 : AppColors.yellow3;
    final labelColor = isPickerMode ? AppColors.yellow3 : AppColors.red3;
    final label = isPickerMode ? 'P' : 'O';

    return GestureDetector(
      onTap: _handleToggle,
      child: Container(
        width: 72.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: activeColor, width: 2),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  isPickerMode ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 32.w,
                height: 28.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: TextWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
