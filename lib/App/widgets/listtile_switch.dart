import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

class ListTileSwitch extends StatelessWidget {
  final String text;
  final Color? textColor;
  final bool isSwitch;
  final Function(bool)? onChange;
  final Color? activeTrackColor;
  final Color? inActiveTrackColor;

  const ListTileSwitch({
    super.key,
    required this.text,
    this.textColor,
    this.onChange,
    this.isSwitch = false,
    this.activeTrackColor,
    this.inActiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: textColor ?? AppColors.labelGray,
          ),
        ),
        Transform.scale(
          scale: 0.77,
          child: CupertinoSwitch(
            value: isSwitch,
            activeTrackColor: activeTrackColor ?? AppColors.red3,
            inactiveTrackColor: inActiveTrackColor ?? AppColors.redLight,
            inactiveThumbColor: Colors.white,
            onChanged: onChange,
          ),
        ),
      ],
    );
  }
}
