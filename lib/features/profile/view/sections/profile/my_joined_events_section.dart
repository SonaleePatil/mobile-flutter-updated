import 'package:flutter/material.dart';

class MyJoinedEventsSection extends StatelessWidget {
  final VoidCallback? onViewAll;

  const MyJoinedEventsSection({super.key, this.onViewAll});

  static const _events = [
    _EventData(
      title: 'Bike Abu Dhabi Gran Fondo 2025',
      date: '18 July 2026',
      distance: '42 km',
      imagePath: 'assets/images/cycling_1.png',
    ),
    _EventData(
      title: 'Corniche Sunrise Social',
      date: '21 July 2026',
      distance: '12 km',
      imagePath: 'assets/images/community_ride1.png',
    ),
    _EventData(
      title: 'Hudayriyat Trail X morning',
      date: '23 July 2026',
      distance: '60 km',
      imagePath: 'assets/images/route_preview.png',
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
            title: 'Joined Events',
            onViewAll: onViewAll,
          ),
          const SizedBox(height: 17),
          SizedBox(
            height: 309,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _events.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _EventCard(data: _events[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventData {
  final String title;
  final String date;
  final String distance;
  final String imagePath;

  const _EventData({
    required this.title,
    required this.date,
    required this.distance,
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

class _EventCard extends StatelessWidget {
  final _EventData data;

  const _EventCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 358,
        height: 309,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFFFC9C9),
                ),
              ),
            ),
            Positioned(
              top: 9,
              left: 16,
              child: Container(
                width: 77,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF435974),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Registered',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 17,
              right: 15,
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFF0359E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: 11,
              child: Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(15, 39, 15, 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E5FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 20 / 17,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _MetaItem(
                          icon: Icons.calendar_month_rounded,
                          text: data.date,
                        ),
                        const SizedBox(width: 10),
                        _MetaItem(
                          icon: Icons.speed_rounded,
                          text: data.distance,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12.8226,
            fontWeight: FontWeight.w400,
            height: 15 / 12.8226,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
