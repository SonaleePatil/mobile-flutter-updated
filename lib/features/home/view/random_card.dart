import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:flutter/material.dart';

class FeaturedEventsList extends StatelessWidget {
  final List<HomeEventModel> events;
  final ValueChanged<String>? onEventTap;
  final bool showFallback;

  const FeaturedEventsList({
    super.key,
    this.events = const [],
    this.onEventTap,
    this.showFallback = true,
  });

  static const List<HomeEventModel> _fallbackEvents = [
    HomeEventModel(
      id: '',
      image: 'assets/images/night-ride.png',
      title: 'Abu Dhabi Night Race Series',
      date: '18 July 2026',
      distance: '42 km',
      type: 'Featured',
    ),
    HomeEventModel(
      id: '',
      image: 'assets/images/family_ride.png',
      title: 'Corniche Family Fun Ride',
      date: '21 July 2026',
      distance: '12 km',
      type: 'Featured',
    ),
    HomeEventModel(
      id: '',
      image: 'assets/images/community_ride.png',
      title: 'Hudayriyat Weekend Endurance Ride',
      date: '23 July 2026',
      distance: '60 km',
      type: 'Featured',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final data = <HomeEventModel>[
      ...events,
      if (showFallback && events.length < 3)
        ..._fallbackEvents.skip(events.length),
    ].take(3).toList();

    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Events',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 0,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 309,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final event = data[index];
              return FeaturedEventCard(
                image: event.image,
                title: event.title,
                date: event.date,
                distance: event.distance,
                width: 358,
                height: 309,
                panelTop: 198,
                onTap: () => onEventTap?.call(event.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FeaturedEventCard extends StatelessWidget {
  static const Color _shareBlue = Color(0xFF02A1CE);
  static const Color _chipBlue = Color(0xFF435974);
  static const Color _panelBlueTint = Color(0xFFF1F1FB);

  final String image;
  final String title;
  final String date;
  final String distance;
  final VoidCallback? onTap;
  final double? width;
  final double height;
  final double panelTop;

  const FeaturedEventCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.distance,
    this.onTap,
    this.width,
    this.height = 275,
    this.panelTop = 160,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/cycling_1.png',
                        height: height,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      image,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: _shareBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              top: panelTop,
              child: Container(
                width: 328,
                height: 100,
                padding: const EdgeInsets.fromLTRB(15, 9, 15, 12),
                decoration: BoxDecoration(
                  color: _panelBlueTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Featured Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _chipBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Featured",
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Title
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                        letterSpacing: 0,
                        color: AppColors.charcoal,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Date + Distance Row
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/calender.png",
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12.8226,
                            fontWeight: FontWeight.w400,
                            height: 17.0968 / 12.8226,
                            letterSpacing: 0,
                            color: Color(0xFF484A4D),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          "assets/icons/km_empty.png",
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12.8226,
                            fontWeight: FontWeight.w400,
                            height: 17.0968 / 12.8226,
                            letterSpacing: 0,
                            color: Color(0xFF484A4D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
