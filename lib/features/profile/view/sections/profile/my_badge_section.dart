import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class MyBadgesSection extends StatelessWidget {
  const MyBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softCream,
      padding: const EdgeInsets.only(
        top: 41,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
              Text(
  "My Badges",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                Row(
                  children: [
                   Text(
  "View All",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14, // ≈1.43
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.charcoal,
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 25),

         
          SizedBox(
            height: 95, // circle + label space
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24),
              children: [
  const _BadgeItem(
    title: "500km club",
    imagePath: "assets/icons/trophy.png",
  ),
  const SizedBox(width: 20),
  const _BadgeItem(
    title: "Weekend ri...",
    imagePath: "assets/icons/trophy.png",
  ),
]
            ),
          )
        ],
      ),
    );
  }
}
class _BadgeItem extends StatelessWidget {
  final String title;
  final String imagePath;

  const _BadgeItem({
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
  
        Container(
          width: 59.31,
          height: 59.31,
          decoration: const BoxDecoration(
            color: Color(0xFFE6B566),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 29.6483,
              height: 29.6483,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 80,
          child:Text(
  title,
  overflow: TextOverflow.ellipsis,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0.14,
    color: AppColors.charcoal,
  ),
)
        )
      ],
    );
  }
}