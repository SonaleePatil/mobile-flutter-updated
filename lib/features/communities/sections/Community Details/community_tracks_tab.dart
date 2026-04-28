import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:flutter/material.dart';
class CommunityTracksTab extends StatelessWidget {
  const CommunityTracksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return CommunityHighlightTrackCard(
  imagePath: "assets/images/track.png",
  title: "Al Hudayriyat Island Track",
  subtitle: "Beginner / Intermediate",
  iconPath: "assets/icons/event_track.png",
  onTap: () {},
);
        },
      ),
    );
  }
}