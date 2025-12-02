import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SharePictures extends StatelessWidget {
  const SharePictures({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.colorFilter,
  });
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  @override
  Widget build(BuildContext context) {
    final issSvg = imagePath.toLowerCase().endsWith('.svg');
    return issSvg
        ? SvgPicture.asset(
            imagePath,
            width: width,
            height: height,
            fit: fit,
            colorFilter: colorFilter,
          )
        : Image.asset(imagePath, width: width, height: height, fit: fit);
  }
}