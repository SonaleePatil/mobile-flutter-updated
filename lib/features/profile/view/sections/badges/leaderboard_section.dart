import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child:Text(
  "Leaderboard",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
)
        ),
        SizedBox(height: 31),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              _LeaderboardCard(
                title: "Double Century",
                subtitle: "Complete 200 km in a single ride",
                progressText: "45/200 km",
                progressValue: 0.225,
              ),
              SizedBox(height: 16),
              _LeaderboardCard(
                title: "Social Butterfly",
                subtitle: "Join 20 community group rides",
                progressText: "8/20 rides",
                progressValue: 0.4,
              ),
              SizedBox(height: 16),
              _LeaderboardCard(
                title: "Marathon Master",
                subtitle: "Ride 500 km in one month",
                progressText: "285/500 km",
                progressValue: 0.57,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String progressText;
  final double progressValue;

  const _LeaderboardCard({
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      height: 133,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 63.5945,
                height: 63.5945,
                decoration: BoxDecoration(
                  color: const Color(0xFFCF9F0C),
                  borderRadius: BorderRadius.circular(18.5508),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/trophy.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0XFF101828)
  ),
),
                    const SizedBox(height: 4),
                   Text(
  subtitle,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF4A5565),
  ),
)
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      "Progress",
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 18.7066 / 13.0946, // ≈1.43
        letterSpacing: 0,
        color: AppColors.charcoal,
      ),
    ),
    Text(
      progressText,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 18.7066 / 13.0946,
        letterSpacing: 0,
        color: AppColors.charcoal,
      ),
    ),
  ],
),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: const Color(0xFFFFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFCF9F0C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}