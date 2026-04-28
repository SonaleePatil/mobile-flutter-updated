import 'package:adcc/shared/widgets/community_update_card.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:flutter/material.dart';

class CommunityUpdatesSection extends StatelessWidget {
  final List<HomeFeedPostModel> updates;
  final bool showFallback;

  const CommunityUpdatesSection({
    super.key,
    this.updates = const [],
    this.showFallback = true,
  });

  @override
  Widget build(BuildContext context) {
    const fallback = [
      HomeFeedPostModel(
        id: '',
        profileImage: 'assets/images/profile_sara.png',
        name: 'Sara Al Ketbi',
        locationTime: 'Dubai • 2h ago',
        postImage: 'assets/images/ride.png',
        likes: 24,
        caption: 'Amazing ride today!...',
      ),
    ];
    final data = updates.isEmpty
        ? (showFallback ? fallback : const <HomeFeedPostModel>[])
        : updates;
    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          SectionHeader(
            title: "Community updates",
          ),
          const SizedBox(height: 21),

          // Feed
          SizedBox(
            height: 430,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: data
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: CommunityUpdateCard(
                        profileImage: item.profileImage,
                        name: item.name,
                        locationTime: item.locationTime,
                        postImage: item.postImage,
                        likes: item.likes,
                        caption: item.caption,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
