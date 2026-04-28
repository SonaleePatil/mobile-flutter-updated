import 'dart:ui';

import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const riders = <_RiderRowData>[
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
        // badge: 'S',
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

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LeaderboardHeroCard(),
              const SizedBox(height: 18),
              const _TopTabs(),
              const SizedBox(height: 18),
              const Text(
                'Top riders this month',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 14),
              ...riders.map(
                (rider) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _RiderRow(data: rider),
                ),
              ),
              const SizedBox(height: 12),
              const _DecemberStatsCard(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardHeroCard extends StatelessWidget {
  const _LeaderboardHeroCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 242,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/Rectangle22.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xE6000000),
                    ],
                    stops: [0.25, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
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
                    color: AppColors.deepRed,
                    size: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                children: [
                  const Text(
                    'December Distance Challenge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0x36FFFFFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 23.5,
                                height: 23.5,
                                decoration: BoxDecoration(
                                  color: const Color(0x408C8C8C),
                                  borderRadius: BorderRadius.circular(36.15),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.search,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  hintText: 'Search events...',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Outfit',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    height: 1.0,
                                    letterSpacing: -0.1,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ),
                          ],
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
    );
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Active Challenges',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0x80000000),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepRed,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 2,
              color: const Color(0x80000000),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.43,
                height: 2,
                color: AppColors.deepRed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RiderRowData {
  final String name;
  final String team;
  final String time;
  final bool highlightName;
  final String? badge;

  const _RiderRowData({
    required this.name,
    required this.team,
    required this.time,
    this.highlightName = false,
    this.badge,
  });
}

class _RiderRow extends StatelessWidget {
  final _RiderRowData data;

  const _RiderRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: const Color(0xFFF0DDAF),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              size: 16,
              color: AppColors.charcoal,
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
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight:
                        data.highlightName ? FontWeight.w700 : FontWeight.w400,
                    color: data.highlightName
                        ? AppColors.deepRed
                        : AppColors.charcoal,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.team,
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
          if (data.badge != null)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1691F7),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  data.badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
          Text(
            data.time,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.charcoal,
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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AA27),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.track_changes,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Your December Stats',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.55,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatBox(label: 'Total KM', value: '324'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatBox(label: 'Rides', value: '18'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatBox(label: 'Rank Change', value: '12'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E2),
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
              color: Color(0xFF525252),
              height: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
