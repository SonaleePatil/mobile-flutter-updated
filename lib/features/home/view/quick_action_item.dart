import 'package:flutter/material.dart';
import 'package:adcc/core/theme/app_colors.dart';

class QuickActionItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final double iconSize;
  final double iconOffsetY;
  final VoidCallback? onTap;

  const QuickActionItem({
    super.key,
    required this.title,
    required this.imagePath,
    this.iconSize = 32,
    this.iconOffsetY = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.31,
            height: 50.31,
            decoration: BoxDecoration(
              color: AppColors.warmSand.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Transform.translate(
                offset: Offset(0, iconOffsetY),
                child: Image.asset(
                  imagePath,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10.8997,
              fontWeight: FontWeight.w400,
              height: 1.15, // 115%
              letterSpacing: 0.2746,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
