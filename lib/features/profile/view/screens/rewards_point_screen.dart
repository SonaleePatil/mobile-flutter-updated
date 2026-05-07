import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/features/profile/view/sections/reward_point/available_points_section.dart';
import 'package:adcc/features/profile/view/sections/reward_point/available_rewards_section.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';

class RewardsPointsScreen extends StatelessWidget {
  const RewardsPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.05).clamp(12.0, 24.0);

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
         BannerHeadder(
                      imagePath:
                          'assets/images/cycling_1.png',
                      title: 'Rewards & Points',
                      subtitle:
                          ' Earn points by completing challenges',
                          centerTitle: true,
                      onBackTap: () =>
                          Navigator.pop(context),
                    ),
          
              const SizedBox(height: 28),
        
             const RiderStatsSection(
  riderLevel: "Rider Level: Intermediate",

  badgesTitle: "Earned This Month",
  badgesValue: "475",

  pointsTitle: "Reward Clamied",
  pointsValue: "08",

  progressTitle: "Current Tier",
  progressValue: "Silver",
),
        const SizedBox(height: 30),
        
              
        const AvailablePointsSection(),
        
              
        
                const SizedBox(height: 40),
        
              const AvailableRewardsSection(),
              ]
            ))
        
       )
      )
        );
  }
}
