import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:flutter/material.dart';

class CommunityEventsTab extends StatelessWidget {
  final Color cardColor;

  const CommunityEventsTab({
    super.key,
    this.cardColor = const Color(0xFFC9EFEA),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 253,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return CommunityHighlightTrackCard(
            imagePath: "assets/images/cycling_1.png",
            title: "Hudayriyat Island Track",
            subtitle: "19 Jan 2026",
            iconPath: "assets/icons/calender.png",
            backgroundColor: cardColor,
            onTap: () {},
          );
        },
      ),
    );
  }
}
