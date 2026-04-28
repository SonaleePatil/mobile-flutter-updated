import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:flutter/material.dart';

class UpcomingTracksList extends StatelessWidget {
  final List<HomeEventModel> events;
  final void Function(String eventId)? onEventTap;

  const UpcomingTracksList({
    super.key,
    this.events = const [],
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackEvents = [
      EventModel(
        image: "assets/images/cycling_1.png",
        title: "Corniche Sunrise Social",
        day: "Every Sunday",
        type: "Social",
      ),
      EventModel(
        image: "assets/images/cycling_1.png",
        title: "Abu Dhabi Night Ride",
        day: "Every Friday",
        type: "Social",
      ),
      EventModel(
        image: "assets/images/cycling_1.png",
        title: "Yas Island Weekend Ride",
        day: "Every Saturday",
        type: "Social",
      ),
    ];

    final uiEvents = events.isEmpty
        ? fallbackEvents
        : events
            .map(
              (e) => EventModel(
                id: e.id,
                image: e.image,
                title: e.title,
                day: e.date,
                type: e.type,
              ),
            )
            .toList();

    return SizedBox(
      height: 275,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: uiEvents.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final ev = uiEvents[index];
          return GestureDetector(
            onTap: ev.id.isNotEmpty ? () => onEventTap?.call(ev.id) : null,
            child: UpcomingEventCard(event: ev),
          );
        },
      ),
    );
  }
}

class UpcomingEventCard extends StatelessWidget {
  final EventModel event;

  const UpcomingEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 308,
      child: Stack(
        children: [

          /// BACKGROUND IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: event.image.startsWith('http')
                ? Image.network(
                    event.image,
                    height: 275,
                    width: 358,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/cycling_1.png',
                      height: 275,
                      width: 358,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    event.image,
                    height: 275,
                    width: 358,
                    fit: BoxFit.cover,
                  ),
          ),

          /// SHARE BUTTON
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: Color(0xffC12D32),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.share,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),

         Positioned(
  left: 15,
  right: 15,
  top: 160,
  child: Container(
    width: 328,
    height: 100,
    padding: const EdgeInsets.fromLTRB(
      15, 
      9, 
      15, 
      12, 
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9EF), // #FFF9EF
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// SOCIAL BADGE
        Container(
          width: 62,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffC12D32),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
  event.type,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Geist',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12, // ≈1.33
    letterSpacing: 0,
    color: Color(0xFFFFF4E3),
  ),
)
        ),

        const SizedBox(height: 8),

      /// TITLE
Text(
  event.title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.15,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

        const SizedBox(height: 2),

        /// DAY ROW
        Row(
          children: [
            Image.asset(
              "assets/icons/calender.png",
              height: 16,
              width: 16,
            ),
            const SizedBox(width: 4),
            Text(
  event.day,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.8226,
    fontWeight: FontWeight.w400,
    height: 17.0968 / 12.8226, 
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
)
          ],
        ),
      ],
    ),
  ),
)
        ],
      ),
    );
  }
}

class EventModel {
  final String id;
  final String image;
  final String title;
  final String day;
  final String type;

  EventModel({
    this.id = '',
    required this.image,
    required this.title,
    required this.day,
    required this.type,
  });
}