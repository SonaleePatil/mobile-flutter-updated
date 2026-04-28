import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/my_cycling_details/view/my_cycling_details_screen.dart';
import 'package:adcc/features/profile/view/screens/badges_achievement.screen.dart';
import 'package:adcc/features/profile/view/screens/cycling_details_screen.dart';
import 'package:adcc/features/profile/view/screens/event_history_screen.dart';
import 'package:adcc/features/profile/view/screens/my_challenges_screen.dart';
import 'package:adcc/features/profile/view/screens/rewards_point_screen.dart';
import 'package:adcc/features/profile/view/screens/settings_screen.dart';
import 'package:flutter/material.dart';


class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Container(
        width: 358,
    
      decoration: BoxDecoration(
  color: const Color(0xFFFFF9EF),
  borderRadius: BorderRadius.circular(17.5168),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF2E3176).withOpacity(0.10),
      offset: const Offset(0, 4.38),
      blurRadius: 30.65,
      spreadRadius: 0,
    ),
  ],
),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.8945),
          child: Column(
  children:  [
    SizedBox(height: 21.8965),

    _MenuItem(
      imagePath: "assets/icons/events_calender.gif",
      title: "My Events & Calendar",
       onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const EventHistoryScreen(),
    ),
  );
},
    ),
    _Divider(),

  _MenuItem(
  imagePath: "assets/icons/point.gif",
  title: "Badges & achievements",
 onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const BadgesAchievementsScreen(),
    ),
  );
},
),
    _Divider(),

    _MenuItem(
      imagePath: "assets/icons/my_challenges.gif",
      title: "My Challenges",
         onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const MyChallengesScreen(),
    ),
  );
},
    ),
      _Divider(),

    _MenuItem(
      imagePath: "assets/icons/my_challenges.gif",
      title: "My Cycling Details",
         onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const CyclingDetailsScreen(),
    ),
  );
},
    ),
    _Divider(),

    _MenuItem(
      imagePath: "assets/icons/point.gif",
      title: "Rewards and points",
      onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const RewardsPointsScreen(),
    ),
  );
},
    ),
    _Divider(),

    _MenuItem(
      imagePath: "assets/icons/settings.gif",
      title: "Settings & preferences",
      onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ),
  );
},
    ),
  ],
),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;  

  const _MenuItem({
    required this.imagePath,
    required this.title,
    this.onTap,
  });

 @override
Widget build(BuildContext context) {
  return Material(
    color: Colors.transparent,   
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 314.2079,
        height: 52.5505,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13.1376,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0.13,
    color: AppColors.charcoal,
  ),
)
              ],
            ),
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.charcoal,
            ),
          ],
        ),
      ),
    ),
  );
}
}
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Divider(
        thickness: 1,
        color: Colors.black.withOpacity(0.06),
      ),
    );
  }
}