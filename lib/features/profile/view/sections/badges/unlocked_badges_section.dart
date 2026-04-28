import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UnlockedBadgesSection extends StatelessWidget {
  const UnlockedBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
  "Unlocked Badges",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal, // charcoal
  ),
)
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
  "6 earned",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.7,
    fontWeight: FontWeight.w500,
    height: 18.1446 / 12.7012, // ≈ 1.43
    letterSpacing: 0,
    color: Colors.black54,
  ),
)
        ),
        SizedBox(height: 16),
        _BadgesGrid(),
      ],
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  const _BadgesGrid();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 16.0;
    const gap = 12.0;

    final cardWidth =
        (screenWidth - (horizontalPadding * 2) - gap) / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          _badgeRow(cardWidth,
              "Century Rider",
              "Complete 100 Km In A Single Ride",
              "100 Pts",
              "Early Bird",
              "Complete 10 Morning Rides",
              "50 Pts"),
          const SizedBox(height: 16),
          _badgeRow(cardWidth,
              "Champion",
              "Join 5 Community Group Rides",
              "75 Pts",
              "Speed Demon",
              "Reach 40 Km/H Average Speed",
              "80 Pts"),
          const SizedBox(height: 16),
          _badgeRow(cardWidth,
              "Consistency King",
              "Ride For 30 Consecutive Days",
              "120 Pts",
              "Hill Climber",
              "Climb 1000m Elevation In One Ride",
              "90 Pts"),
        ],
      ),
    );
  }

  Widget _badgeRow(
    double width,
    String title1,
    String subtitle1,
    String points1,
    String title2,
    String subtitle2,
    String points2,
  ) {
    return Row(
      children: [
        _BadgeCard(
          width: width,
          title: title1,
          subtitle: subtitle1,
          points: points1,
        ),
        const SizedBox(width: 12),
        _BadgeCard(
          width: width,
          title: title2,
          subtitle: subtitle2,
          points: points2,
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final double width;
  final String title;
  final String subtitle;
  final String points;

  const _BadgeCard({
    required this.width,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 96,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E2),
        borderRadius: BorderRadius.circular(9.9496),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             Container(
  width: 30,
  height: 30,
  decoration: const BoxDecoration(
    color: Color(0xFFF0DDAF),
    shape: BoxShape.circle,
  ),
  padding: const EdgeInsets.all(8),
  child: Center(
    child: Image.asset(
      "assets/icons/medal.png",
      width: 15,
      height: 15,
      fit: BoxFit.contain,
    ),
  ),
),
              const SizedBox(width: 8),
              Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
  overflow: TextOverflow.ellipsis,
)
            ],
          ),
       
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child:Text(
  subtitle,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
)
          ),
          const Spacer(),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
             vertical: 3
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(30),
              ),
              child:Text(
  points,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
)
            ),
          ),
        ],
      ),
    );
  }
}