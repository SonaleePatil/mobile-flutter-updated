import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/community_list_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
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
  int selectedIndex = 0;
  String search = '';

  CommunitySortType selectedSort = CommunitySortType.mostActive;

  final List<String> filterPills = [
    'All',
    'Family & Leisure',
    'Racing & Performance',
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
    if (selectedIndex != 0) {
      list = list.where((c) {
        return c.category.any(
          (e) => e.toLowerCase().contains(
                filterPills[selectedIndex].toLowerCase(),
              ),
        );
      }).toList();
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
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        
        child: CustomScrollView(
          slivers: [
            /// Banner
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: BannerHeadder(
                  imagePath: 'assets/images/cycling_1.png',
                  title: 'Communities in Abu Dhabi',
                  subtitle: 'All Cycling communities active near you',
                  onBackTap: () => Navigator.pop(context),
                ),
              ),
            ),

     
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 21),

              
                  CategorySelector(
                    categories: filterPills,
                    selectedIndex: selectedIndex,
                    onSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),

                  const SizedBox(height: 36),


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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(
  '${filteredList.length} communities found',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1,
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
              const Icon(
                Icons.swap_vert,
                size: 15,
               color: Color(0XFFCF9F0C),
              ),
              const SizedBox(width: 4),
             Text(
  sortTitle,
  textAlign: TextAlign.right,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0XFFCF9F0C),
  ),
),
            ],
          ),
        ),
      ],
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
      return SliverFillRemaining(
        hasScrollBody: false,
        child: const Center(
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
  bottom: index < filteredList.length - 1 ? 20 : 172,
),
         child: CommunityListCard(
  community: community,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommunityCityDetails(community: community),
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
