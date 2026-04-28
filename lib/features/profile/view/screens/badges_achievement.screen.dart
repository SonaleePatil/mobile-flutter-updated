import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/profile/view/sections/badges/achievements_section.dart';
import 'package:adcc/features/profile/view/sections/badges/latest_achivement_card.dart';
import 'package:adcc/features/profile/view/sections/badges/leaderboard_section.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/features/profile/view/sections/badges/share_button.dart';
import 'package:adcc/features/profile/view/sections/badges/unlocked_badges_section.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';

class BadgesAchievementsScreen extends StatelessWidget {
  const BadgesAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: Padding(
        padding:
                  const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: SafeArea(
          
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                     BannerHeadder(
                    imagePath:
                        'assets/images/cycling_1.png',
                    title: 'Badges & Achivements',
                    subtitle:
                        '',
                        centerTitle: true,
                    onBackTap: () =>
                        Navigator.pop(context),
                  ),
        
                const SizedBox(height: 28),
        
               const RiderStatsSection(
  riderLevel: "Rider Level: Intermediate",

  badgesTitle: "Total Badges",
  badgesValue: "06",

  pointsTitle: "Total Points",
  pointsValue: "515",

  progressTitle: "In Progress",
  progressValue: "03",
),
        const SizedBox(height: 32),
            LatestAchievementCard(),
        
                const SizedBox(height:40),
        const AchievementsSection(),
        
                const SizedBox(height: 40),
        const UnlockedBadgesSection(),
                const SizedBox(height: 40),
        
              const LeaderboardSection(),
        
                const SizedBox(height: 40),
        
             const ShareAchievementsButton(),
                const SizedBox(height: 111),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

