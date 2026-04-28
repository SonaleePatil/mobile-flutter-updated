import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_details_header.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_events_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_gallery_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_tracks_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_updates_tab.dart';
import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:adcc/features/communities/sections/join_community_screen.dart';
import 'package:adcc/features/communities/sections/leavecommunity.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';

class CommunityCityDetails extends StatefulWidget {
  final CommunityModel community;

  const CommunityCityDetails({
    super.key,
    required this.community,
  });

  @override
  State<CommunityCityDetails> createState() => _CommunityCityDetailsState();
}

class _CommunityCityDetailsState extends State<CommunityCityDetails> {
  int selectedTabIndex = 0;
  bool isLoading = false;
  CommunityModel? _apiCommunity;
  //  Local variable to track join status
  late bool _isJoined;

  final CommunitiesService _communitiesService = CommunitiesService();

  final List<String> tabs = const [
    "Events",
    "Tracks",
    "Gallery",
    "Updates",
  ];
@override
void initState() {
  super.initState();
 _isJoined = false;



  _fetchCommunityById(); 
  _checkMemberStatus();
}
Future<void> _fetchCommunityById() async {
  setState(() => isLoading = true);

  final communityId = widget.community.id;



  final result = await _communitiesService.getCommunityById(
    communityId: communityId,
  );

  if (!mounted) return;

  setState(() => isLoading = false);
 


  if (result.data != null) {
    setState(() {
      _apiCommunity = result.data!;
    });

    final c = _apiCommunity!;

   
  }
}
Future<void> _checkMemberStatus() async {
  setState(() => isLoading = true);

  final result =
      await _communitiesService.getCommunityMemberStatus(
    communityId: widget.community.id,
  );

  if (!mounted) return;

  setState(() => isLoading = false);

  if (result.success) {
    setState(() {
      _isJoined = result.data ?? false;
      widget.community.isJoined = _isJoined;
    });
  }
}
  //  Method to refresh community data
  Future<void> _refreshCommunityData() async {
   
    setState(() {
      _isJoined = widget.community.isJoined;
    });
  }

  @override
  Widget build(BuildContext context) {
  if (_apiCommunity == null) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

final c = _apiCommunity!;
final title = c.title;
final description = c.description;

final city = c.city?.isNotEmpty == true
    ? c.city!
    : (c.location ?? "N/A");

final category = c.type.isNotEmpty ? c.type : "N/A";

final track = c.trackName?.isNotEmpty == true
    ? c.trackName!
    : "N/A";

final founded = (c.foundedYear ?? 0) > 0
    ? c.foundedYear.toString()
    : "N/A";

final members = c.membersCount != null
    ? c.membersCount.toString()
    : "0";

final events = c.eventsCount != null
    ? c.eventsCount.toString()
    : "0";

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          children: [
            // TOP BANNER IMAGE
       CommunityDetailsHeader(
  base64Image: c.imageUrl,
  title: "",
  onBackTap: () => Navigator.pop(context),
),

            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
  title,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFFC12D32),
  ),
),
                ),
                const SizedBox(width: 12),
                _ShareBadge(onTap: () {}),
              ],
            ),

            const SizedBox(height: 12),

           // Description
Text(
  description,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),

            const SizedBox(height: 25),

         _InfoGrid(
  city: city,
  category: category,
  primaryTrack: track,
  founded: founded,
  upcomingEvents: events,
  members: members,
),

            const SizedBox(height: 31),

       Text(
  "Community Highlights",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color:AppColors.charcoal,
  ),
),

            const SizedBox(height: 14),

         
            const _HighlightsCard(),

            const SizedBox(height: 49),

       
            _TabsRow(
              tabs: tabs,
              selectedIndex: selectedTabIndex,
              onTap: (i) => setState(() => selectedTabIndex = i),
            ),

            const SizedBox(height: 28),

         
            _TabContent(selectedTabIndex: selectedTabIndex),

            const SizedBox(height: 51),

         
         AppButton(
  label: isLoading
      ? "Checking..."
      : (_isJoined
          ? "Leave Community"
          : "Join Community"),
  onPressed: isLoading ? null : _handleJoinLeave,
  type: _isJoined
      ? AppButtonType.danger
      : AppButtonType.primary,
  backgroundColor: const Color(0xFFB11212),
  textColor: Colors.white,
  borderRadius: 16,
  height: 52,
  textStyle: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 17.46, // 17.4634 ≈ 17.46
    fontWeight: FontWeight.w400,
    height: 1.50, // 26.1369 / 17.4634
    letterSpacing: 0,
  ),
 
         ),
          ],
        ),
      ),
    );
  }

  //  Separate method to handle join/leave logic
  Future<void> _handleJoinLeave() async {
    if (!_isJoined) {
      // JOIN COMMUNITY
      setState(() => isLoading = true);

      final result = await _communitiesService.joinCommunity(
        communityId: widget.community.id,
      );

      setState(() => isLoading = false);

      if (!mounted) return;

      if (result.success) {
        // Update local state
        setState(() {
          _isJoined = true;
          widget.community.isJoined = true;
        });

        // Show success message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Community joined successfully! 🎉"),
            backgroundColor: Colors.green,
          ),
        );

      
        final shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JoinCommunity(
              community: widget.community,
            ),
          ),
        );

        // If JoinCommunity returns true, refresh data
        if (shouldRefresh == true && mounted) {
          _refreshCommunityData();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? "Join failed "),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // LEAVE COMMUNITY
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => LeaveCommunity(
            community: widget.community,
          ),
        ),
      );

      if (result == true && mounted) {
        // Update local state
        setState(() {
          _isJoined = false;
          widget.community.isJoined = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Community left successfully "),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}

class _ShareBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _ShareBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
         color: const Color(0x5C99D3B5),// #99D3B55C
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/icons/share_2.png",
          height: 17.5,
          width: 17.5,
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final String city;
  final String category;
  final String primaryTrack;
  final String founded;
  final String upcomingEvents;
  final String members;

  const _InfoGrid({
    required this.city,
    required this.category,
    required this.primaryTrack,
    required this.founded,
    required this.upcomingEvents,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile({
      required String iconPath,
      required String label,
      required String value,
    }) {
      return Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFD7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              iconPath,
              height: 15,
              width: 15,
              color: AppColors.deepRed,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
  label,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12.44, // 12.437 ≈ 12.44
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                  const SizedBox(height: 4),
                 Text(
  value,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.55,
      children: [
        tile(
          iconPath: "assets/icons/city.png",
          label: "City",
          value: city,
        ),
        tile(
          iconPath: "assets/icons/category.png",
          label: "Category",
          value: category,
        ),
        tile(
          iconPath: "assets/icons/primary_tracks.png",
          label: "Primary Track",
          value: primaryTrack,
        ),
        tile(
          iconPath: "assets/icons/founded.png",
          label: "Founded",
          value: founded,
        ),
        tile(
          iconPath: "assets/icons/upcoming_events.png",
          label: "Upcoming Events",
          value: upcomingEvents,
        ),
        tile(
          iconPath: "assets/icons/members.png",
          label: "Members",
          value: members,
        ),
      ],
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  const _HighlightsCard();

  @override
  Widget build(BuildContext context) {

    Widget row({
      required String iconPath,
      required String label,
      required String value,
    }) {
      return Container(
        width: 358,
        height: 49,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E2),
          borderRadius: BorderRadius.circular(9.95),
        ),
        child: Row(
          children: [

            /// ICON CONTAINER
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFF0DDAF),
                borderRadius: BorderRadius.circular(54),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconPath,
                height: 16,
                width: 16,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 9),

            /// LABEL
            SizedBox(
              width: 150,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
            ),

            const Spacer(),

            /// VALUE
            Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0,
                color: AppColors.charcoal,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        row(
          iconPath: "assets/images/active_member.png",
          label: "Active Members",
          value: "740+",
        ),
        const SizedBox(height: 10),
        row(
          iconPath: "assets/images/total_distance.png",
          label: "Total Distance This Month",
          value: "6,300 Km",
        ),
        const SizedBox(height: 10),
        row(
          iconPath: "assets/images/avg_ride.png",
          label: "Average Ride Rating",
          value: "4.5",
        ),
      ],
    );
  }
}
class _TabsRow extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _TabsRow({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 82,
              height: 38,
              padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.goldenOchre
                    : const Color(0xFF1A1C201A),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child:Text(
  tabs[index],
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43, // 20 / 14 ≈ 1.43
    letterSpacing: 0,
    color: isSelected ? Colors.white : AppColors.textDark,
  ),
),
            ),
          );
        },
      ),
    );
  }
}


class _TabContent extends StatelessWidget {
  final int selectedTabIndex;

  const _TabContent({required this.selectedTabIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        return const CommunityEventsTab();

      case 1:
        return const CommunityTracksTab();

      case 2:
        return const CommunityGalleryTab();

      case 3:
        return const CommunityUpdatesTab();

      default:
        return const SizedBox();
    }
  }
}
