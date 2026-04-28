import 'package:adcc/features/routes/view/sections/track_category_sections.dart';
import 'package:adcc/shared/widgets/track_header.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/warning_message.dart';
import 'sections/official_cycling_tracks_section.dart';
import 'sections/tracks_near_you_section.dart';
import 'sections/explore_by_city_section.dart';

class RoutesTab extends StatefulWidget {
  const RoutesTab({super.key});

  @override
  State<RoutesTab> createState() => _RoutesTabState();
}

class _RoutesTabState extends State<RoutesTab> {
  int selectedFilterIndex = 0;
  String searchQuery = '';

  final List<String> filterPills = [
    'All',
    'Al Dhafra',
    'Al Ain',
    'Rabdan',
    'AL Raha',
    'Abu Dhabi',
    'Sharjah',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        // padding: const EdgeInsets.symmetric(vertical: 16),
        children: [

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TrackHeader(
              imagePath: 'assets/images/cycling_1.png',
              title: 'Find a Track',
              wantSearchBar: true,
              searchValue: searchQuery,
              onChangeHandler: (value) {
                setState(() => searchQuery = value);
              },
              placeholder:
                  'Search tracks, city, distance or terrain...',
            ),
          ),

          const SizedBox(height: 30),

          /// TRACK CATEGORY (only left padding)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TrackCategory(
              categories: filterPills,
              selectedIndex: selectedFilterIndex,
              onSelected: (index) {
                setState(() {
                  selectedFilterIndex = index;
                });
              },
            ),
          ),

          const SizedBox(height: 30),

          /// WARNING MESSAGE (left + right padding)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WarningMessage(
              message:
                  'Strong winds expected of Al Dhafra today choose sheltered tracks',
              type: MessageType.warning,
            ),
          ),

          const SizedBox(height: 30),

          /// TRACKS NEAR YOU
          Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TracksNearYouSection(
              selectedStatus: filterPills[selectedFilterIndex],
              searchQuery: searchQuery,
            ),
          ),

          const SizedBox(height: 30),

          /// OFFICIAL TRACKS
          Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const OfficialCyclingTracksSection(),
          ),

          const SizedBox(height: 30),

          /// EXPLORE BY CITY
          Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const ExploreByCitySection(),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}