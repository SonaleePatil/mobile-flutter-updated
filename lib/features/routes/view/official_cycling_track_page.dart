import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:adcc/shared/widgets/track_card.dart';

class OfficialCyclingTracksPage extends StatefulWidget {
  const OfficialCyclingTracksPage({super.key});

  @override
  State<OfficialCyclingTracksPage> createState() =>
      _OfficialCyclingTracksPageState();
}

class _OfficialCyclingTracksPageState
    extends State<OfficialCyclingTracksPage> {
  int selectedFilterIndex = 0;

  final List<String> filters = const [
    'All',
    'Open',
    'Limited',
    'Closed'
  ];

  final List<_OfficialTrackItem> tracks = const [
    _OfficialTrackItem(
      title: 'Al Hudayriyat Island Cycle Track',
      city: 'Abu Dhabi',
      distanceKm: 35,
      difficulty: 'Beginner–Intermediate',
      status: 'Open',
      subtitle: 'Lighting • Water stations • Restrooms',
      imagePath: 'assets/images/track_1.png',
    ),
    _OfficialTrackItem(
      title: 'Yas Marina Circuit Track',
      city: 'Abu Dhabi',
      distanceKm: 32,
      difficulty: 'Beginner Friendly',
      status: 'Limited',
      subtitle: 'Smooth road • Night riding • Facilities',
      imagePath: 'assets/images/track_1.png',
    ),
    _OfficialTrackItem(
      title: 'Corniche Beach Cycling Track',
      city: 'Abu Dhabi',
      distanceKm: 15,
      difficulty: 'Beginner Friendly',
      status: 'Closed',
      subtitle: 'Seafront route • Smooth surface • Restrooms',
      imagePath: 'assets/images/track_1.png',
    ),
    _OfficialTrackItem(
      title: 'Al Wathba Cycle Track',
      city: 'Abu Dhabi',
      distanceKm: 30,
      difficulty: 'Beginner–Intermediate',
      status: 'Open',
      subtitle: 'Lighting • Water stations • Restrooms',
      imagePath: 'assets/images/track_1.png',
    ),
    _OfficialTrackItem(
      title: 'Reem Island Waterfront Track',
      city: 'Abu Dhabi',
      distanceKm: 18,
      difficulty: 'Beginner Friendly',
      status: 'Limited',
      subtitle: 'City views • Smooth route • Facilities',
      imagePath: 'assets/images/track_1.png',
    ),
    _OfficialTrackItem(
      title: 'Mubadala Cycling Loop',
      city: 'Abu Dhabi',
      distanceKm: 20,
      difficulty: 'Beginner–Intermediate',
      status: 'Open',
      subtitle: 'Training loop • Wide lanes • Lighting',
      imagePath: 'assets/images/track_1.png',
    ),
  ];


  List<_OfficialTrackItem> _applyFilter() {
    if (selectedFilterIndex == 0) {
      return tracks; // All
    }

    final selectedStatus = filters[selectedFilterIndex];

    return tracks
        .where((t) =>
            t.status.toLowerCase() ==
            selectedStatus.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTracks = _applyFilter();

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(16, 24, 16, 20),
          children: [
            const SizedBox(height: 6),

    
            BannerHeadder(
              imagePath:
                  'assets/images/cycling_1.png',
              title:
                  'Official Cycling Tracks',
              subtitle: '',
              onBackTap: () =>
                  Navigator.pop(context),
            ),

            const SizedBox(height: 21),

            CategorySelector(
              categories: filters,
              selectedIndex:
                  selectedFilterIndex,
              onSelected: (index) {
                setState(() {
                  selectedFilterIndex =
                      index;
                });
              },
            ),

            const SizedBox(height: 35),

         
            Text(
  '${filteredTracks.length} communities found',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

            const SizedBox(height: 24),

           
            if (filteredTracks.isEmpty)
              const Padding(
                padding:
                    EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    "No tracks found",
                    style:
                        TextStyle(fontSize: 14),
                  ),
                ),
              ),

            ...filteredTracks.map(
              (t) => Padding(
                padding:
                    const EdgeInsets.only(
                        bottom: 14),
                child: TrackCard(
                  width: double.infinity,
                  height: 281,
                  imagePath: t.imagePath,
                  title: t.title,
                  city: t.city,
                  distance:
                      "${t.distanceKm} km",
                  subtitle: t.subtitle,
                  difficulty:
                      t.difficulty,
                  status: t.status,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RouteDetailsScreen(
                          routeData: {
                            "image":
                                t.imagePath,
                            "title":
                                t.title,
                            "city":
                                t.city,
                            "distance":
                                "${t.distanceKm} km",
                            "subtitle":
                                t.subtitle,
                            "tag":
                                t.difficulty,
                            "status":
                                t.status,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OfficialTrackItem {
  final String title;
  final String city;
  final int distanceKm;
  final String difficulty;
  final String status;
  final String subtitle;
  final String imagePath;

  const _OfficialTrackItem({
    required this.title,
    required this.city,
    required this.distanceKm,
    required this.difficulty,
    required this.status,
    required this.subtitle,
    required this.imagePath,
  });
}