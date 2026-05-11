import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/community_list_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

enum CommunitySortType {
  mostActive,
  mostMembers,
  upcomingEvents,
  recentlyCreated,
}

class ViewAllCommunitiesScreen extends StatefulWidget {
  final String title;
  final List<CommunityModel> communities;

  const ViewAllCommunitiesScreen({
    super.key,
    required this.title,
    required this.communities,
  });

  @override
  State<ViewAllCommunitiesScreen> createState() =>
      _ViewAllCommunitiesScreenState();
}

class _ViewAllCommunitiesScreenState extends State<ViewAllCommunitiesScreen> {
  int selectedIndex = -1;
  String search = '';

  CommunitySortType selectedSort = CommunitySortType.mostActive;

  final List<_CommunityCategoryFilter> filterPills = const [
    _CommunityCategoryFilter(
      label: 'Family & Leisure',
      imagePath: 'assets/images/family-rides.png',
      keys: ['family', 'leisure', 'social'],
    ),
    _CommunityCategoryFilter(
      label: 'Racing & Performance',
      imagePath: 'assets/images/racing.png',
      keys: ['racing', 'performance', 'elite'],
    ),
    _CommunityCategoryFilter(
      label: 'Women (SheRides)',
      imagePath: 'assets/images/she-rides.png',
      keys: ['women', 'ladies', 'she'],
    ),
    _CommunityCategoryFilter(
      label: 'Youth Cycling',
      imagePath: 'assets/images/youth.png',
      keys: ['youth', 'kids'],
    ),
    _CommunityCategoryFilter(
      label: 'Social / Weekend',
      imagePath: 'assets/images/family_ride.png',
      keys: ['social', 'weekend'],
    ),
    _CommunityCategoryFilter(
      label: 'Night Riders',
      imagePath: 'assets/images/night-ride.png',
      keys: ['night'],
    ),
    _CommunityCategoryFilter(
      label: 'MTB / Trail',
      imagePath: 'assets/images/mtb-ride.png',
      keys: ['mtb', 'trail'],
    ),
    _CommunityCategoryFilter(
      label: 'Training & Clinics',
      imagePath: 'assets/images/bike_experience.png',
      keys: ['training', 'clinic'],
    ),
    _CommunityCategoryFilter(
      label: 'Awareness & Charity',
      imagePath: 'assets/images/ride_events.png',
      keys: ['awareness', 'charity'],
    ),
  ];

  String get sortTitle {
    switch (selectedSort) {
      case CommunitySortType.mostActive:
        return "Most Active";
      case CommunitySortType.mostMembers:
        return "Most Members";
      case CommunitySortType.upcomingEvents:
        return "Upcoming Events";
      case CommunitySortType.recentlyCreated:
        return "Recently Created";
    }
  }

  List<CommunityModel> get filteredList {
    List<CommunityModel> list = List.from(widget.communities);

    /// Search
    if (search.isNotEmpty) {
      list = list.where((c) {
        return c.title.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }

    /// Filter Pills
    if (selectedIndex >= 0) {
      final selected = filterPills[selectedIndex];
      list = list.where((c) {
        final text = [
          c.title,
          c.description,
          c.type,
          ...c.category,
        ].join(' ').toLowerCase();
        return selected.keys.any(text.contains);
      }).toList();
      if (list.isEmpty) list = List.from(widget.communities);
    }

    /// Sorting
    switch (selectedSort) {
      case CommunitySortType.mostActive:
        // Most active => max eventsCount
        list.sort((a, b) => (b.eventsCount ?? 0).compareTo(a.eventsCount ?? 0));
        break;

      case CommunitySortType.mostMembers:
        list.sort(
            (a, b) => (b.membersCount ?? 0).compareTo(a.membersCount ?? 0));
        break;

      case CommunitySortType.upcomingEvents:
        list.sort((a, b) => (b.eventsCount ?? 0).compareTo(a.eventsCount ?? 0));
        break;

      case CommunitySortType.recentlyCreated:
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _CommunitiesCityHero(
                  imagePath: 'assets/images/cycling_1.png',
                  title: 'Communities in Abu Dhabi',
                  subtitle: 'All cycling communities active near you',
                  onBackTap: () => Navigator.pop(context),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 30),
                  _CommunityCategoryStrip(
                    filters: filterPills,
                    selectedIndex: selectedIndex,
                    onSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 26),
                  _buildHeader(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),

            /// List
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${filteredList.length} communities found',
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.25,
              letterSpacing: 0,
              color: AppColors.charcoal,
            ),
          ),

          /// SORT DROPDOWN
          PopupMenuButton<CommunitySortType>(
            color: const Color(0xffD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (value) {
              setState(() {
                selectedSort = value;
              });
            },
            itemBuilder: (context) => [
              _buildSortItem(
                type: CommunitySortType.mostActive,
                title: "Most Active",
              ),
              _buildSortItem(
                type: CommunitySortType.mostMembers,
                title: "Most Members",
              ),
              _buildSortItem(
                type: CommunitySortType.upcomingEvents,
                title: "Upcoming Events",
              ),
              _buildSortItem(
                type: CommunitySortType.recentlyCreated,
                title: "Recently Created",
              ),
            ],
            child: Row(
              children: [
                const Icon(Icons.swap_vert, size: 15, color: Color(0XFFCF9F0C)),
                const SizedBox(width: 4),
                Text(
                  sortTitle,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    letterSpacing: 0,
                    color: Color(0XFFCF9F0C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<CommunitySortType> _buildSortItem({
    required CommunitySortType type,
    required String title,
  }) {
    final bool isSelected = selectedSort == type;

    return PopupMenuItem<CommunitySortType>(
      value: type,
      child: Row(
        children: [
          if (isSelected)
            const Icon(
              Icons.swap_vert,
              size: 18,
              color: Color(0XFFCF9F0C),
            )
          else
            const SizedBox(width: 18),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0XFFCF9F0C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (filteredList.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'No communities found',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final community = filteredList[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < filteredList.length - 1 ? 25 : 84,
              ),
              child: CommunityListCard(
                community: community,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CommunityCityDetails(community: community),
                    ),
                  );
                },
              ),
            );
          },
          childCount: filteredList.length,
        ),
      ),
    );
  }
}

class _CommunityCategoryFilter {
  final String label;
  final String imagePath;
  final List<String> keys;

  const _CommunityCategoryFilter({
    required this.label,
    required this.imagePath,
    required this.keys,
  });
}

class _CommunitiesCityHero extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onBackTap;

  const _CommunitiesCityHero({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 299,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AdaptiveImage(
              imagePath: imagePath,
              fit: BoxFit.cover,
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 96,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0xFF000000),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 18,
              child: GestureDetector(
                onTap: onBackTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Color(0xFFC12D32),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 43,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20.1,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 12,
                  height: 1.33,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityCategoryStrip extends StatelessWidget {
  final List<_CommunityCategoryFilter> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _CommunityCategoryStrip({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 119,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(selected ? -1 : index),
            child: Container(
              width: 92,
              height: 109.17,
              decoration: BoxDecoration(
                color: selected ? Colors.white : const Color(0x1202A1CE),
                borderRadius: BorderRadius.circular(10.36),
                border: Border.all(
                  color: selected ? Colors.black : const Color(0xFFD7D7D7),
                  width: 0.61,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7.36),
                    child: SizedBox(
                      width: 79.73,
                      height: 74.83,
                      child: AdaptiveImage(
                        imagePath: filter.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 18,
                    child: Center(
                      child: Text(
                        filter.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 9,
                          height: 1.003,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
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
