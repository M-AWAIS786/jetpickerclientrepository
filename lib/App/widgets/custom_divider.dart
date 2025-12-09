import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final Color? dividerColor;
  final double? dividerThickness;
  final double? height;
  final double? indent;
  final double? endIndent;
  const CustomDivider({
    super.key,
    this.dividerColor,
    this.dividerThickness,
    this.height,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: dividerColor ?? AppColors.labelGray,
      height: height ?? 0,
      thickness: dividerThickness ?? 0.5,
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
    );
  }
}
