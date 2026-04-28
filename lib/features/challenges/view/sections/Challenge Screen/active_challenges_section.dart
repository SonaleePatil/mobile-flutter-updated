import 'package:flutter/material.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';
import '../../widgets/challenge_card.dart';
import '../../challenge_details_screen.dart';

class ActiveChallengesSection extends StatelessWidget {
  final List<ChallengeModel> challenges;

  const ActiveChallengesSection({
    super.key,
    this.challenges = const [],
  });

  final List<Map<String, dynamic>> fallbackChallenges = const [
    {
      'id': 'challenge_1',
      'image': 'assets/images/cycling_1.png',
      'difficulty': 'Easy',
      'title': 'December Distance Champion',
      'description': 'Ride 500km this month to earn the champion badge',
      'progress': 324,
      'target': 500,
      'unit': 'km',
      'daysLeft': 12,
      'participants': 234,
    },
    {
      'id': 'challenge_2',
      'image': 'assets/images/bike.png',
      'difficulty': 'Hard',
      'title': 'Climbing Warrior',
      'description': 'Gain 2,000m elevation this week',
      'progress': 1245,
      'target': 2000,
      'unit': 'm',
      'daysLeft': 3,
      'participants': 156,
    },
    {
      'id': 'challenge_3',
      'image': 'assets/images/route_preview.png',
      'difficulty': 'Medium',
      'title': 'Early Bird Rider',
      'description': 'Complete 5 rides before 7 AM this week',
      'progress': 3,
      'target': 5,
      'unit': 'rides',
      'daysLeft': 4,
      'participants': 89,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final uiChallenges = challenges.isEmpty
        ? fallbackChallenges
        : challenges
            .map(
              (c) => {
                'id': c.id,
                'image': c.image,
                'difficulty': c.difficulty,
                'title': c.title,
                'description': c.description,
                'progress': c.progress,
                'target': c.target,
                'unit': c.unit,
                'daysLeft': c.daysLeft,
                'participants': c.participants,
              },
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: uiChallenges.length,
          separatorBuilder: (context, index) => const SizedBox(height: 22),
          itemBuilder: (context, index) {
            final challenge = uiChallenges[index];
            return ChallengeCard(
              imagePath: challenge['image'] as String,
              difficulty: challenge['difficulty'] as String,
              title: challenge['title'] as String,
              description: challenge['description'] as String,
              progress: challenge['progress'] as int,
              target: challenge['target'] as int,
              unit: challenge['unit'] as String,
              daysLeft: challenge['daysLeft'] as int,
              participants: challenge['participants'] as int,
              onTap: () {
                // Navigate to challenge details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChallengeDetailsScreen(
                      challengeId: challenge['id'] as String,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

