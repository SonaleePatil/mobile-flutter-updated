import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CompleteEvenetResult extends StatelessWidget {
  const CompleteEvenetResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          children: [
            /// Header
            Row(
              children: [
                _BackCircleButton(
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Completed Event Result",
                    style: TextStyle(
                      fontSize: 15.6,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            /// Your Result
            const Text(
              "Your Result",
              style: TextStyle(
                fontSize: 13.4,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            const Row(
              children: [
                Expanded(
                  child: _ResultCard(
                    title: "Distance",
                    value: "42 km",
                    icon: Icons.route_rounded,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ResultCard(
                    title: "Time",
                    value: "1h 18m",
                    icon: Icons.access_time_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              children: [
                Expanded(
                  child: _ResultCard(
                    title: "Rank",
                    value: "07",
                    icon: Icons.leaderboard_rounded,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ResultCard(
                    title: "Points Earned",
                    value: "120",
                    icon: Icons.stars_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const _ResultCard(
              title: "Badge",
              value: "Night Racer –\nSilver",
              icon: Icons.military_tech_rounded,
              fullWidth: true,
            ),

            const SizedBox(height: 22),

            /// Leaderboard
            const Text(
              "Leaderboard (Top 10)",
              style: TextStyle(
                fontSize: 13.4,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 14),

            const _LeaderboardRow(
              rank: 1,
              name: "Ahmed Al Mansoori",
              team: "Abu Dhabi Road Racers",
              time: "1:10:22",
            ),
            const SizedBox(height: 12),

            const _LeaderboardRow(
              rank: 2,
              name: "Khalid Saeed",
              team: "Hudayriyyah Weekend Riders",
              time: "1:11:05",
              highlight: true,
            ),
            const SizedBox(height: 12),

            const _LeaderboardRow(
              rank: 3,
              name: "Omar Hassan",
              team: "Dubai Road Riders",
              time: "1:10:22",
            ),

            const SizedBox(height: 14),

            ...List.generate(7, (i) {
              final data = [
                ("Yusuf Ali", "Abu Dhabi Road Racers", "1:12:30"),
                ("Tariq Noor", "Cyclo Zain Community", "1:13:12"),
                ("Saeed Al Qubaisi", "Abu Dhabi Road Racers", "1:14:01"),
                ("You", "Abu Dhabi Road Racers", "1:15:26"),
                ("Faisal Rahman", "Abu Dhabi Road Racers", "1:15:26"),
                ("Zaid Khan", "Abu Dhabi Road Racers", "1:15:26"),
                ("Abdullah Karim", "Abu Dhabi Road Racers", "1:15:26"),
              ];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _LeaderboardRow(
                  rank: i + 4,
                  name: data[i].$1,
                  team: data[i].$2,
                  time: data[i].$3,
                  faded: true,
                ),
              );
            }),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}


class _BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightDeepRed.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          height: 38,
          width: 38,
          child: Icon(
            Icons.arrow_back,
            size: 20,
            color: AppColors.deepRed,
          ),
        ),
      ),
    );
  }
}


class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final bool fullWidth;
  final IconData icon;

  const _ResultCard({
    required this.title,
    required this.value,
    required this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullWidth ? 72 : 66,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// red filled icon circle
          Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
              color: AppColors.deepRed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.charcoal.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.9,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
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


class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final String team;
  final String time;
  final bool highlight;
  final bool faded;

  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.team,
    required this.time,
    this.highlight = false,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = faded ? 0.35 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          /// Trophy in rounded box (like screenshot)
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2D9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.emoji_events_rounded,
                size: 18,
                color: _rankColor(rank),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Name + Team
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.3,
                    fontWeight: FontWeight.w900,
                    color: highlight ? AppColors.deepRed : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  team,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.7,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),

          /// Time
          Text(
            time,
            style: TextStyle(
              fontSize: 11.6,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int r) {
    if (r == 1) return AppColors.goldenOchre;
    if (r == 2) return AppColors.textDark.withValues(alpha: 0.55);
    if (r == 3) return AppColors.orange;
    return AppColors.textDark.withValues(alpha: 0.20);
  }
}
