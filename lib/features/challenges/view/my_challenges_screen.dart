import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/challenges/view/widgets/my_challenge_card.dart';
import 'package:flutter/material.dart';

class MyChallengesScreen extends StatefulWidget {
  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> {
  int _selectedTab = 0;

  static const List<String> _tabs = ['Completed', 'Upcoming', 'Cancelled'];

  static const List<MyChallengeCardData> _completedChallenges = [
    MyChallengeCardData(
      status: 'Completed',
      title: 'December Distance Champion',
      description: 'Ride 500km this month to earn the champion badge',
      progressLabel: '324 / 500 km',
      progress: 324 / 500,
      rewardPoints: 250,
      daysLeft: 12,
      participants: 234,
      imagePath: 'assets/images/mychallenges1.png',
    ),
    MyChallengeCardData(
      status: 'Completed',
      title: 'Climbing Warrior',
      description: 'Gain 2,000m elevation this week',
      progressLabel: '1245 / 2000 m',
      progress: 1245 / 2000,
      rewardPoints: 350,
      daysLeft: 12,
      participants: 234,
      imagePath: 'assets/images/mychallenges2.png',
    ),
    MyChallengeCardData(
      status: 'Completed',
      title: 'Early Bird Rider',
      description: 'Complete 5 rides before 7 AM this week',
      progressLabel: '3 / 5 rides',
      progress: 3 / 5,
      rewardPoints: 550,
      daysLeft: 12,
      participants: 234,
      imagePath: 'assets/images/mychallenges3.png',
    ),
  ];

  static const List<MyChallengeCardData> _upcomingChallenges = [
    MyChallengeCardData(
      status: 'Upcoming',
      title: 'Climbing Warrior',
      description: 'Gain 2,000m elevation this week',
      progressLabel: '1245 / 2000 m',
      progress: 1245 / 2000,
      daysLeft: 3,
      participants: 156,
      imagePath: 'assets/images/mychallenges2.png',
    ),
    MyChallengeCardData(
      status: 'Upcoming',
      title: 'Early Bird Rider',
      description: 'Complete 5 rides before 7 AM this week',
      progressLabel: '3 / 5 rides',
      progress: 3 / 5,
      daysLeft: 4,
      participants: 89,
      imagePath: 'assets/images/mychallenges3.png',
    ),
  ];

  static const List<MyChallengeCardData> _cancelledChallenges = [
    MyChallengeCardData(
      status: 'Cancelled',
      title: 'Climbing Warrior',
      description: 'Gain 2,000m elevation this week',
      progressLabel: '1245 / 2000 m',
      progress: 1245 / 2000,
      daysLeft: 3,
      participants: 156,
      imagePath: 'assets/images/mychallenges2.png',
    ),
    MyChallengeCardData(
      status: 'Cancelled',
      title: 'Early Bird Rider',
      description: 'Complete 5 rides before 7 AM this week',
      progressLabel: '3 / 5 rides',
      progress: 3 / 5,
      daysLeft: 4,
      participants: 89,
      imagePath: 'assets/images/mychallenges3.png',
    ),
  ];

  List<MyChallengeCardData> get _visibleCards {
    if (_selectedTab == 0) return _completedChallenges;
    if (_selectedTab == 1) return _upcomingChallenges;
    if (_selectedTab == 2) return _cancelledChallenges;
    return _completedChallenges;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Color(0x59C12D32),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.deepRed,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'My challenges',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 28 / 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _TopTabs(
              tabs: _tabs,
              selectedTab: _selectedTab,
              onTabTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _visibleCards.isEmpty
                  ? const Center(
                      child: Text(
                        'No challenges yet',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0x80000000),
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemBuilder: (_, index) {
                        return MyChallengeCard(data: _visibleCards[index]);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemCount: _visibleCards.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTabTap,
  });

  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            tabs.length,
            (index) => Expanded(
              child: InkWell(
                onTap: () => onTabTap(index),
                child: SizedBox(
                  height: 28,
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedTab == index
                            ? AppColors.deepRed
                            : Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 3,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: selectedTab == 0
                  ? Alignment.centerLeft
                  : selectedTab == 1
                      ? Alignment.center
                      : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: (MediaQuery.sizeOf(context).width - 32) / 3,
                height: 3,
                color: AppColors.deepRed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
