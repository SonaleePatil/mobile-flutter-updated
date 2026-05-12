import 'dart:ui';

import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            _ChallengesTopBlock(
              selectedTab: _selectedTab,
              searchValue: _searchQuery,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onTabChanged: (index) => setState(() => _selectedTab = index),
            ),
            if (_selectedTab == 0) ...[
              const SizedBox(height: 27),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Active Challenges',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: Color(0xFF1A1C20),
                  ),
                ),
              ),
              const SizedBox(height: 19),
              _ActiveChallengesCarousel(
                challenges: _activeChallenges.where((challenge) {
                  if (_searchQuery.trim().isEmpty) return true;
                  final query = _searchQuery.trim().toLowerCase();
                  return challenge.title.toLowerCase().contains(query) ||
                      challenge.description.toLowerCase().contains(query);
                }).toList(),
              ),
              const SizedBox(height: 50),
              const _RecentChallengesList(),
              const SizedBox(height: 50),
              const _ProgressConnectCard(),
              const SizedBox(height: 34),
            ] else ...[
              const SizedBox(height: 18),
              _LeaderboardContent(searchQuery: _searchQuery),
              const SizedBox(height: 34),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChallengesTopBlock extends StatelessWidget {
  const _ChallengesTopBlock({
    required this.selectedTab,
    required this.searchValue,
    required this.onSearchChanged,
    required this.onTabChanged,
  });

  final int selectedTab;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    if (selectedTab == 1) {
      return _LeaderboardTopBlock(
        selectedTab: selectedTab,
        searchValue: searchValue,
        onSearchChanged: onSearchChanged,
        onTabChanged: onTabChanged,
      );
    }

    return SizedBox(
      height: 305,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 261,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF06A16F),
                  Color(0xFF06A16F),
                  Colors.white,
                ],
                stops: [0, 0.8362, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 67,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
          ),
          const Positioned(
            top: 106,
            left: 0,
            right: 0,
            child: Text(
              'Challenges',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 163,
            child: _ChallengeSearchField(
              value: searchValue,
              onChanged: onSearchChanged,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 221,
            child: _ChallengeTabsCard(
              selectedTab: selectedTab,
              onTabChanged: onTabChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTopBlock extends StatelessWidget {
  const _LeaderboardTopBlock({
    required this.selectedTab,
    required this.searchValue,
    required this.onSearchChanged,
    required this.onTabChanged,
  });

  final int selectedTab;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 397,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 16,
            right: 16,
            top: 65,
            child: _LeaderboardHeroCard(),
          ),
          Positioned(
            left: 31,
            top: 83,
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFC12D32),
                  size: 18,
                ),
              ),
            ),
          ),
          Positioned(
            left: 39.5,
            right: 39.5,
            top: 252,
            child: _ChallengeSearchField(
              value: searchValue,
              onChanged: onSearchChanged,
              hintText: 'Search...',
              sigma: 2,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 338,
            child: _InlineChallengeTabs(
              selectedTab: selectedTab,
              onTabChanged: onTabChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardHeroCard extends StatelessWidget {
  const _LeaderboardHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 242,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Rectangle22.png',
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xE6000000),
                ],
                stops: [0.2725, 1],
              ),
            ),
          ),
          const Positioned(
            left: 18,
            right: 18,
            bottom: 74,
            child: Text(
              'December Distance Challenge',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.27,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeSearchField extends StatefulWidget {
  const _ChallengeSearchField({
    required this.value,
    required this.onChanged,
    this.hintText = 'Search events...',
    this.sigma = 5,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;
  final double sigma;

  @override
  State<_ChallengeSearchField> createState() => _ChallengeSearchFieldState();
}

class _ChallengeSearchFieldState extends State<_ChallengeSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _ChallengeSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.sigma, sigmaY: widget.sigma),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.21),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 23.5,
                height: 23.5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(Icons.search, size: 13, color: Colors.white),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: -0.1,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeTabsCard extends StatelessWidget {
  const _ChallengeTabsCard({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF06A16F);

    return Container(
      height: 84,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TabLabel(
                  title: 'Active Challenges',
                  isSelected: selectedTab == 0,
                  onTap: () => onTabChanged(0),
                ),
              ),
              Expanded(
                child: _TabLabel(
                  title: 'Leaderboard',
                  isSelected: selectedTab == 1,
                  onTap: () => onTabChanged(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Align(
                alignment: selectedTab == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineChallengeTabs extends StatelessWidget {
  const _InlineChallengeTabs({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TabLabel(
                  title: 'Active Challenges',
                  isSelected: selectedTab == 0,
                  onTap: () => onTabChanged(0),
                ),
              ),
              Expanded(
                child: _TabLabel(
                  title: 'Leaderboard',
                  isSelected: selectedTab == 1,
                  onTap: () => onTabChanged(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFCAECE1),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Align(
                alignment: selectedTab == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06A16F),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.25,
          color: isSelected
              ? const Color(0xFF06A16F)
              : Colors.black.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _ActiveChallengesCarousel extends StatelessWidget {
  const _ActiveChallengesCarousel({required this.challenges});

  final List<_ChallengeCardData> challenges;

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'No active challenges found',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5565),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 428,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        physics: const BouncingScrollPhysics(),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _ActiveChallengeCard(data: challenges[index]),
          );
        },
      ),
    );
  }
}

class _ActiveChallengeCard extends StatelessWidget {
  const _ActiveChallengeCard({required this.data});

  final _ChallengeCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 428,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              data.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/cycling_1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 16,
            bottom: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 116,
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.55,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _ChallengeMeta(
                            icon: Icons.schedule_rounded,
                            text: data.daysLeft,
                          ),
                          const SizedBox(width: 13),
                          _ChallengeMeta(
                            icon: Icons.groups_rounded,
                            text: data.participants,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeMeta extends StatelessWidget {
  const _ChallengeMeta({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 15.5),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14.1,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _RecentChallengesList extends StatelessWidget {
  const _RecentChallengesList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Challenges',
            style: TextStyle(
              fontFamily: 'Geist',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFF1A1C20),
            ),
          ),
          const SizedBox(height: 20),
          for (final recent in _recentChallenges) ...[
            _RecentChallengeTile(data: recent),
            if (recent != _recentChallenges.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RecentChallengeTile extends StatelessWidget {
  const _RecentChallengeTile({required this.data});

  final _RecentChallengeData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFCAECE1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 63.6,
            height: 63.6,
            decoration: BoxDecoration(
              color: const Color(0xFF94DAC1),
              borderRadius: BorderRadius.circular(18.55),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/ride.png',
                width: 38,
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.directions_bike_rounded,
                  color: Color(0xFF1A1C20),
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${data.distance} · ${data.duration} · ${data.timeAgo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.28,
                    color: Color(0xFF4A5565),
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

class _ProgressConnectCard extends StatelessWidget {
  const _ProgressConnectCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 135,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF06A16F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -8,
              bottom: -6,
              child: Transform.flip(
                flipX: true,
                child: Image.asset(
                  'assets/images/mtb-ride.png',
                  width: 210,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 17,
              top: 14,
              width: 232,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track Your Progress',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Connect Strava or Garmin to automatically track your challenge progress',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 17,
              bottom: 14,
              child: SizedBox(
                width: 147,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color(0xFFCAECE1),
                    foregroundColor: const Color(0xFF06A16F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.27),
                    ),
                  ),
                  child: const Text(
                    'Connect Devices',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardContent extends StatelessWidget {
  const _LeaderboardContent({required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final riders = query.isEmpty
        ? _riders
        : _riders.where((rider) {
            return rider.name.toLowerCase().contains(query) ||
                rider.team.toLowerCase().contains(query);
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top riders this month',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1C20),
            ),
          ),
          const SizedBox(height: 14),
          if (riders.isEmpty)
            const SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  'No riders found',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5565),
                  ),
                ),
              ),
            )
          else
            for (final rider in riders) ...[
              _RiderRow(data: rider),
              if (rider != riders.last) const SizedBox(height: 12),
            ],
          const SizedBox(height: 16),
          const _DecemberStatsCard(),
        ],
      ),
    );
  }
}

class _RiderRow extends StatelessWidget {
  const _RiderRow({required this.data});

  final _RiderRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFCAECE1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: const Color(0xFF94DAC1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              size: 16,
              color: Color(0xFF1A1C20),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight:
                        data.highlightName ? FontWeight.w700 : FontWeight.w400,
                    color: data.highlightName
                        ? Colors.black
                        : const Color(0xFF333333),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.team,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xCC333333),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            data.time,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1C20),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecemberStatsCard extends StatelessWidget {
  const _DecemberStatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.fromLTRB(19, 17, 19, 17),
      decoration: BoxDecoration(
        color: const Color(0xFF94DAC1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, size: 20, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Your December Stats',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.55,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _StatBox(label: 'Total KM', value: '324')),
              SizedBox(width: 10),
              Expanded(child: _StatBox(label: 'Rides', value: '18')),
              SizedBox(width: 10),
              Expanded(child: _StatBox(label: 'Rank Change', value: '12')),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF06A16F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCardData {
  const _ChallengeCardData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.daysLeft,
    required this.participants,
  });

  final String title;
  final String description;
  final String imagePath;
  final String daysLeft;
  final String participants;
}

class _RecentChallengeData {
  const _RecentChallengeData({
    required this.title,
    required this.distance,
    required this.duration,
    required this.timeAgo,
  });

  final String title;
  final String distance;
  final String duration;
  final String timeAgo;
}

class _RiderRowData {
  const _RiderRowData({
    required this.name,
    required this.team,
    required this.time,
    this.highlightName = false,
  });

  final String name;
  final String team;
  final String time;
  final bool highlightName;
}

const List<_ChallengeCardData> _activeChallenges = [
  _ChallengeCardData(
    title: 'December Distance Champion',
    description: 'Ride 250km this month for the champion badge',
    imagePath: 'assets/images/Rectangle22.png',
    daysLeft: '12 days left',
    participants: '234',
  ),
  _ChallengeCardData(
    title: 'Climbing Warrior',
    description: 'Gain 2,000m elevation this week',
    imagePath: 'assets/images/mychallenges2.png',
    daysLeft: '3 days left',
    participants: '156',
  ),
  _ChallengeCardData(
    title: 'Early Bird Rider',
    description: 'Complete 5 rides before 7 AM this week',
    imagePath: 'assets/images/mychallenges3.png',
    daysLeft: '4 days left',
    participants: '89',
  ),
];

const List<_RecentChallengeData> _recentChallenges = [
  _RecentChallengeData(
    title: 'Evening Ride at Corniche',
    distance: '15.2 km',
    duration: '52 min',
    timeAgo: 'Yesterday',
  ),
  _RecentChallengeData(
    title: 'SheRides Community Event',
    distance: '22.8 km',
    duration: '1h 15min',
    timeAgo: '2 days ago',
  ),
];

const List<_RiderRowData> _riders = [
  _RiderRowData(
    name: 'Ahmed Al Mansoori',
    team: 'Abu Dhabi Road Racers',
    time: '1:10:22',
  ),
  _RiderRowData(
    name: 'Khalid Saeed',
    team: 'Hudayriyat Weekend Riders',
    time: '1:11:05',
    highlightName: true,
  ),
  _RiderRowData(
    name: 'Omar Hassan',
    team: 'Dubai Road Riders',
    time: '1:10:22',
  ),
  _RiderRowData(
    name: 'Yusuf Ali',
    team: 'Abu Dhabi Road Racers',
    time: '1:12:30',
  ),
  _RiderRowData(
    name: 'Tariq Noor',
    team: 'Cycle Zone Community',
    time: '1:13:12',
  ),
  _RiderRowData(
    name: 'Saeed Al Qubaisi',
    team: 'Abu Dhabi Road Racers',
    time: '1:14:01',
  ),
  _RiderRowData(
    name: 'You',
    team: 'Abu Dhabi Road Racers',
    time: '1:15:26',
  ),
  _RiderRowData(
    name: 'Faisal Rahman',
    team: 'Abu Dhabi Road Racers',
    time: '1:15:26',
  ),
  _RiderRowData(
    name: 'Zaid Khan',
    team: 'Abu Dhabi Road Racers',
    time: '1:15:26',
  ),
  _RiderRowData(
    name: 'Abdullah Karim',
    team: 'Abu Dhabi Road Racers',
    time: '1:15:26',
  ),
];
