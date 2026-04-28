import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/view/community_screen.dart';
import 'package:adcc/features/home/view/quick_action_item.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/features/challenges/view/challenges_screen.dart';
import 'package:adcc/features/routes/view/routes_screen_wrapper.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final ValueChanged<int>? onTabChange;

  const QuickActionsSection({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            height: 1, // 100% line height
            letterSpacing: 0,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 21),

        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 88.04 / 80.49,
          mainAxisSpacing: 14.51,
          crossAxisSpacing: 2.04,
          children: [
            QuickActionItem(
              title: 'Store',
              imagePath: 'assets/images/store.png',
              iconSize: 29.35,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoreScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: 'Tracks',
              imagePath: 'assets/icons/tracks.gif',
              iconSize: 38.57,
              onTap: () {
                // Switch to Routes tab (index 2) instead of pushing new screen
                if (onTabChange != null) {
                  onTabChange!(2);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoutesScreenWrapper(),
                    ),
                  );
                }
              },
            ),
            QuickActionItem(
              title: 'Challenges',
              imagePath: 'assets/icons/challenges.gif',
              iconSize: 37.73,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChallengesScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: 'Events',
              imagePath: 'assets/icons/events_calender.gif',
              iconSize: 31.86,
              onTap: () {
                // Switch to Events tab (index 1) instead of pushing new screen
                if (onTabChange != null) {
                  onTabChange!(1);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EventsScreen(),
                    ),
                  );
                }
              },
            ),
            QuickActionItem(
              title: 'Community',
              imagePath: 'assets/images/community.png',
              iconSize: 31.86,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommunitiesScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: 'Bike Experience',
              imagePath: 'assets/icons/bike_experience.gif',
              iconSize: 32.87,
            ),
            QuickActionItem(
              title: 'Ride Feed',
              imagePath: 'assets/images/quick_action_ride_feed.png',
              iconSize: 42,
            ),
            QuickActionItem(
              title: 'Merchandise',
              imagePath: 'assets/images/quick_action_merchandise.png',
              iconSize: 38,
              iconOffsetY: -3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoreScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
