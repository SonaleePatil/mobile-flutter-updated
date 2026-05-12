import 'package:flutter/material.dart';

class MyCommunitiesSection extends StatelessWidget {
  final VoidCallback? onViewAll;

  const MyCommunitiesSection({super.key, this.onViewAll});

  static const _communities = [
    _CommunityData(
      title: 'Abu Dhabi Road Racers',
      members: '2800 Members',
      imagePath: 'assets/images/community_ride.png',
    ),
    _CommunityData(
      title: 'Yas Marina Circuit',
      members: '3800 Members',
      imagePath: 'assets/images/ride_events.png',
    ),
    _CommunityData(
      title: 'SheRides Abu Dhabi',
      members: '1700 Members',
      imagePath: 'assets/images/she-rides.png',
    ),
    _CommunityData(
      title: 'Youth Pedalers',
      members: '1200 Members',
      imagePath: 'assets/images/cycling_1.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileSectionHeader(
            title: 'My Communities',
            onViewAll: onViewAll,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 363,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _communities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _CommunityCard(data: _communities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityData {
  final String title;
  final String members;
  final String imagePath;

  const _CommunityData({
    required this.title,
    required this.members,
    required this.imagePath,
  });
}

class _ProfileSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _ProfileSectionHeader({
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 25 / 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF333333),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final _CommunityData data;

  const _CommunityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 248,
        height: 363,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFA9907E),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.80),
                    ],
                    stops: const [0.45, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 94,
              child: Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 23 / 18,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 72,
              child: Row(
                children: [
                  const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    data.members,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 16 / 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 22,
              child: Container(
                width: 143,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF0359E8),
                  borderRadius: BorderRadius.circular(9.12),
                ),
                child: const Text(
                  'Explore Community',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 18 / 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
