import 'package:adcc/shared/widgets/community_update_card.dart';
import 'package:flutter/material.dart';

class CommunityUpdatesTab extends StatelessWidget {
  const CommunityUpdatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: const [
          CommunityUpdateCard(
            profileImage: 'assets/images/profile_sara.png',
            name: 'Sara Al Ketbi',
            locationTime: 'Dubai • 2h ago',
            postImage: 'assets/images/ride.png',
            likes: 24,
            caption: '🚴‍♀️ Amazing ride today!...',
          ),

          SizedBox(width: 6),

          CommunityUpdateCard(
            profileImage: 'assets/images/profile_sara.png',
            name: 'Sara Al Ketbi',
            locationTime: 'Dubai • 2h ago',
            postImage: 'assets/images/ride.png',
            likes: 24,
            caption: '🚴‍♀️ Amazing ride today!...',
          ),

          SizedBox(width: 6),

          CommunityUpdateCard(
            profileImage: 'assets/images/profile_sara.png',
            name: 'Sara Al Ketbi',
            locationTime: 'Dubai • 2h ago',
            postImage: 'assets/images/ride.png',
            likes: 24,
            caption: '🚴‍♀️ Amazing ride today!...',
          ),
        ],
      ),
    );
  }
}