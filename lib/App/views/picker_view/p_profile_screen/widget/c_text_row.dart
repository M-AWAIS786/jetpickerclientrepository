
  import 'package:flutter/material.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';

Widget textRow(BuildContext context, String title, String trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.red1),
        ),
        Text(
          trailing,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.red1),
        ),
      ],
    );
  }
