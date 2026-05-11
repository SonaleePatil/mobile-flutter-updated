import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_details_header.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_events_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_gallery_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_tracks_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_updates_tab.dart';
import 'package:adcc/features/communities/sections/join_community_screen.dart';
import 'package:adcc/features/communities/sections/leavecommunity.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/app_button.dart';
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
  static const Color _primaryBlue = Color(0xFF02A1CE);
  static const Color _redAccent = Color(0xFFC12D32);
  static const Color _goldAccent = Color(0xFFCF9F0C);

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
    }
  }

  Future<void> _checkMemberStatus() async {
    setState(() => isLoading = true);

    final result = await _communitiesService.getCommunityMemberStatus(
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

    final city = c.city?.isNotEmpty == true ? c.city! : (c.location ?? "N/A");

    final category = c.type.isNotEmpty ? c.type : "N/A";

    final track = c.trackName?.isNotEmpty == true ? c.trackName! : "N/A";

    final founded = (c.foundedYear ?? 0) > 0 ? c.foundedYear.toString() : "N/A";

    final members = c.membersCount != null ? c.membersCount.toString() : "0";

    final events = c.eventsCount != null ? c.eventsCount.toString() : "0";
    final isAwareness = _isAwarenessCommunity(c);
    final theme = _CommunityDetailTheme.fromCommunity(isAwareness);

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 34),
          children: [
            // TOP BANNER IMAGE
            CommunityDetailsHeader(
              base64Image: c.imageUrl,
              title: "",
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

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
                      color: _redAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _ShareBadge(onTap: () {}),
              ],
            ),

            const SizedBox(height: 9),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 32),

            _InfoGrid(
              city: city,
              category: category,
              primaryTrack: track,
              founded: founded,
              upcomingEvents: events,
              members: members,
              theme: theme,
            ),

            const SizedBox(height: 33),

            const Text(
              "Community Highlights",
              style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1, // 100% line height
                letterSpacing: 0,
                color: AppColors.charcoal,
              ),
            ),

            const SizedBox(height: 16),

            _HighlightsCard(
              activeMembers: isAwareness
                  ? '${_formatCount(c.membersCount ?? 3456)}+'
                  : '${_formatCount(c.membersCount ?? 745)}+',
              totalDistance: isAwareness ? '4,900 Km' : '6,300 Km',
              rating: isAwareness ? '4.9' : '4.5',
              theme: theme,
            ),

            const SizedBox(height: 28),

            _TabsRow(
              tabs: tabs,
              selectedIndex: selectedTabIndex,
              theme: theme,
              onTap: (i) => setState(() => selectedTabIndex = i),
            ),

            const SizedBox(height: 12),

            _TabContent(
              selectedTabIndex: selectedTabIndex,
              highlightCardColor: theme.highlightCardBackground,
            ),

            const SizedBox(height: 31),

            AppButton(
              label: isLoading
                  ? "Checking..."
                  : (_isJoined ? "Leave Community" : "Join Community"),
              onPressed: isLoading ? null : _handleJoinLeave,
              type: _isJoined ? AppButtonType.danger : AppButtonType.primary,
              backgroundColor: theme.actionColor,
              textColor: Colors.white,
              borderRadius: 7.48,
              height: 51,
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

  bool _isAwarenessCommunity(CommunityModel community) {
    final values = [
      community.title,
      community.description,
      community.type,
      ...community.category,
    ].join(' ').toLowerCase();

    return values.contains('awareness') ||
        values.contains('charity') ||
        values.contains('health') ||
        values.contains('education') ||
        values.contains('social cause');
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
        decoration: const BoxDecoration(
          color: Color(0x5C99D3B5), // #99D3B55C
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

class _CommunityDetailTheme {
  final Color pageBackground;
  final Color infoShellStart;
  final Color infoShellEnd;
  final Color infoTileBackground;
  final Color statIconBackground;
  final Color statIconColor;
  final Color selectedTabColor;
  final Color inactiveTabColor;
  final Color actionColor;
  final Color highlightCardBackground;

  const _CommunityDetailTheme({
    required this.pageBackground,
    required this.infoShellStart,
    required this.infoShellEnd,
    required this.infoTileBackground,
    required this.statIconBackground,
    required this.statIconColor,
    required this.selectedTabColor,
    required this.inactiveTabColor,
    required this.actionColor,
    required this.highlightCardBackground,
  });

  factory _CommunityDetailTheme.fromCommunity(bool isAwareness) {
    if (isAwareness) {
      return const _CommunityDetailTheme(
        pageBackground: Color(0xFFEAF6FB),
        infoShellStart: Color(0xFF0359E8),
        infoShellEnd: Color(0xFFFFF9EF),
        infoTileBackground: Color(0xFFF6E7D1),
        statIconBackground: Color(0xFFF0DDAF),
        statIconColor: Color(0xFF484A4D),
        selectedTabColor: _CommunityCityDetailsState._goldAccent,
        inactiveTabColor: Color(0x1A1A1C20),
        actionColor: _CommunityCityDetailsState._redAccent,
        highlightCardBackground: Color(0xFFFFEFD7),
      );
    }

    return const _CommunityDetailTheme(
      pageBackground: Color(0xFFEAF6FB),
      infoShellStart: Color(0x00000000),
      infoShellEnd: Color(0x00000000),
      infoTileBackground: Color(0xFFFFEFD7),
      statIconBackground: Color(0xFF06B486),
      statIconColor: Colors.white,
      selectedTabColor: _CommunityCityDetailsState._primaryBlue,
      inactiveTabColor: Color(0x1A02A1CE),
      actionColor: _CommunityCityDetailsState._primaryBlue,
      highlightCardBackground: Color(0xFFC9EFEA),
    );
  }
}

String _formatCount(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

class _InfoGrid extends StatelessWidget {
  final String city;
  final String category;
  final String primaryTrack;
  final String founded;
  final String upcomingEvents;
  final String members;
  final _CommunityDetailTheme theme;

  const _InfoGrid({
    required this.city,
    required this.category,
    required this.primaryTrack,
    required this.founded,
    required this.upcomingEvents,
    required this.members,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile({
      required String iconPath,
      required String label,
      required String value,
      required bool tall,
    }) {
      return Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: theme.infoTileBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              iconPath,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            SizedBox(height: tall ? 14 : 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 12.44,
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: tall ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.25,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    final items = [
      (icon: "assets/icons/city.png", label: "City", value: city, tall: true),
      (
        icon: "assets/icons/category.png",
        label: "Category",
        value: category,
        tall: true
      ),
      (
        icon: "assets/icons/primary_tracks.png",
        label: "Primary Tracks",
        value: primaryTrack,
        tall: true
      ),
      (
        icon: "assets/icons/founded.png",
        label: "Founded",
        value: founded,
        tall: false
      ),
      (
        icon: "assets/icons/upcoming_events.png",
        label: "Upcoming Events",
        value: upcomingEvents.padLeft(2, '0'),
        tall: false
      ),
      (
        icon: "assets/icons/members.png",
        label: "Members",
        value: _formatCount(int.tryParse(members) ?? 0),
        tall: false
      ),
    ];

    return Container(
      padding: theme.infoShellStart == Colors.transparent
          ? EdgeInsets.zero
          : const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: theme.infoShellStart == Colors.transparent
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.infoShellStart,
                  theme.infoShellEnd,
                ],
              ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 8,
          mainAxisExtent: 108,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return tile(
            iconPath: item.icon,
            label: item.label,
            value: item.value,
            tall: item.tall,
          );
        },
      ),
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  final String activeMembers;
  final String totalDistance;
  final String rating;
  final _CommunityDetailTheme theme;

  const _HighlightsCard({
    required this.activeMembers,
    required this.totalDistance,
    required this.rating,
    required this.theme,
  });

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
          color: theme.highlightCardBackground,
          borderRadius: BorderRadius.circular(9.95),
        ),
        child: Row(
          children: [
            /// ICON CONTAINER
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: theme.statIconBackground,
                borderRadius: BorderRadius.circular(54),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconPath,
                height: 16,
                width: 16,
                fit: BoxFit.contain,
                color: theme.statIconColor,
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
          value: activeMembers,
        ),
        const SizedBox(height: 8),
        row(
          iconPath: "assets/images/total_distance.png",
          label: "Total Distance This Month",
          value: totalDistance,
        ),
        const SizedBox(height: 8),
        row(
          iconPath: "assets/images/avg_ride.png",
          label: "Average Ride Rating",
          value: rating,
        ),
      ],
    );
  }
}

class _TabsRow extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final _CommunityDetailTheme theme;
  final ValueChanged<int> onTap;

  const _TabsRow({
    required this.tabs,
    required this.selectedIndex,
    required this.theme,
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
              width: index == 0 ? 72 : (tabs[index].length > 6 ? 87 : 80),
              height: 38,
              padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.selectedTabColor
                    : theme.inactiveTabColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
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
  final Color highlightCardColor;

  const _TabContent({
    required this.selectedTabIndex,
    required this.highlightCardColor,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        return CommunityEventsTab(cardColor: highlightCardColor);

      case 1:
        return CommunityTracksTab(cardColor: highlightCardColor);

      case 2:
        return const CommunityGalleryTab();

      case 3:
        return const CommunityUpdatesTab();

      default:
        return const SizedBox();
    }
  }
}
