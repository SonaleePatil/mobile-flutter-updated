import 'package:adcc/shared/widgets/community_update_card.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class CommunityUpdatesSection extends StatelessWidget {
  const CommunityUpdatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
       SectionHeader(
  title: "Community updates",
)
,
          const SizedBox(height: 21),

          // Feed
          SizedBox(
            height: 430,
            child: ListView(
              scrollDirection: Axis.horizontal,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
