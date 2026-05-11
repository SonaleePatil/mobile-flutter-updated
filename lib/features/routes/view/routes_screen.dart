import 'package:flutter/material.dart';
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
    'Al Dhafra',
    'Al Ain',
    'Rabdan',
    'AL Raha',
    'Fullgas',
    'Yasi',
    'Saraab',
    'Abu Dhabi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _TrackHero(
            searchValue: searchQuery,
            onSearchChanged: (value) {
              setState(() => searchQuery = value);
            },
          ),
          Transform.translate(
            offset: const Offset(0, -68),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _TrackCategoryCard(
                categories: filterPills,
                selectedIndex: selectedFilterIndex,
                onSelected: (index) {
                  setState(() => selectedFilterIndex = index);
                },
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -38),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _UvWarning(),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TracksNearYouSection(
                selectedStatus: filterPills[selectedFilterIndex],
                searchQuery: searchQuery,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: OfficialCyclingTracksSection(),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ExploreByCitySection(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _TrackHero extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onSearchChanged;

  const _TrackHero({
    required this.searchValue,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 289,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .84, 1],
          colors: [
            Color(0xFFF09902),
            Color(0xFFF09902),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Find a Tracks",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 54),
              Container(
                height: 38,
                padding: const EdgeInsets.fromLTRB(11, 7, 14, 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .21),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 23.5,
                      height: 23.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C8C8C).withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        controller: TextEditingController(text: searchValue)
                          ..selection = TextSelection.collapsed(
                            offset: searchValue.length,
                          ),
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText:
                              "Search events, communities, cities, or tracks...",
                          hintStyle: TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackCategoryCard extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TrackCategoryCard({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.fromLTRB(13, 17, 0, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.36),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0359E8)
                      : const Color(0x800359E8),
                  width: .61,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.36),
                      child: Image.asset(
                        index.isEven
                            ? "assets/images/track.png"
                            : "assets/images/cycling_1.png",
                        width: 80,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: selected
                          ? const Color(0xFF0359E8)
                          : const Color(0x800359E8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UvWarning extends StatelessWidget {
  const _UvWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF09902),
        border: Border.all(color: Colors.white.withValues(alpha: .13)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 19),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "Strong winds expected of Al Dhafra today\nchoose sheltered tracks.",
              style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.31,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
