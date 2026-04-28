import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/section_header.dart';
import 'dart:ui';
class NearbyTracksSection extends StatelessWidget {
  const NearbyTracksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = [
      TrackModel(
        title: "Al Hudayriyat Island Cycle Track",
        location: "Hudayriyat Island",
        distance: "35 km",
        image: 'assets/images/cycling_1.png',
        level: "Beginner-Intermediate",
        status: "Open",
      ),
      TrackModel(
        title: "Yas Marina Circuit Track",
        location: "Yas Island",
        distance: "25 km",
        image: 'assets/images/cycling_1.png',
        level: "Beginner",
        status: "Open",
      ),
      TrackModel(
        title: "Al Wathba Cycling Track",
        location: "Al Wathba",
        distance: "30 km",
        image: 'assets/images/cycling_1.png',
        level: "Intermediate",
        status: "Closed",
      ),
    ];

    return Column(
      children: [

        /// HEADER
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(title: "Nearby Tracks"),
        ),

        const SizedBox(height: 16),

        /// TRACK LIST
        SizedBox(
          height: 228,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tracks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return NearbyTrackCard(track: tracks[index]);
            },
          ),
        ),
      ],
    );
  }
}

class NearbyTrackCard extends StatelessWidget {
  final TrackModel track;

  const NearbyTrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 228,
      decoration: BoxDecoration(
        color: const Color(0xffE5D2A3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [

          /// IMAGE AREA
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.asset(
                  track.image,
                  width: 358,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

              /// LEVEL BADGE
              Positioned(
                left: 15,
                top: 14,
                child: _Badge(
                  text: track.level,
                  width: 143,
                ),
              ),

              /// STATUS BADGE
              Positioned(
                right: 15,
                top: 14,
                child: _Badge(
                  text: track.status,
                  width: 67,
                ),
              ),
            ],
          ),

          /// INFO SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    /// LOCATION ICON
                    Image.asset(
                      "assets/icons/location.png",
                      width: 16,
                      height: 16,
                    ),

                    const SizedBox(width: 6),

                   Text(
  track.location,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.8),
  ),
),

                    const Spacer(),

                    /// DISTANCE ICON
                    Image.asset(
                   "assets/icons/km.png",
                      width: 16,
                      height: 16,
                    ),

                    const SizedBox(width: 6),

                  Text(
  track.distance,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                  ],
                ),

                const SizedBox(height: 6),

              Text(
  track.title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _Badge extends StatelessWidget {
  final String text;
  final double width;

  const _Badge({
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          width: width,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0x26000000), // #000000 - 15%
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
class TrackModel {
  final String title;
  final String location;
  final String distance;
  final String image;
  final String level;
  final String status;

  TrackModel({
    required this.title,
    required this.location,
    required this.distance,
    required this.image,
    required this.level,
    required this.status,
  });
}