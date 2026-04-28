import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'sections/accepted_header_section.dart';
import 'sections/accepted_rating_section.dart';
import 'sections/accepted_difficulty_section.dart';
import 'sections/accepted_enjoyment_section.dart';
import 'sections/accepted_thoughts_section.dart';
import 'sections/accepted_achievements_section.dart';
import 'sections/accepted_new_badge_section.dart';
import 'sections/accepted_actions_section.dart';

class ChallengeAcceptedScreen extends StatefulWidget {
  final String challengeId;
  final String challengeTitle;

  const ChallengeAcceptedScreen({
    super.key,
    required this.challengeId,
    required this.challengeTitle,
  });

  @override
  State<ChallengeAcceptedScreen> createState() =>
      _ChallengeAcceptedScreenState();
}

class _ChallengeAcceptedScreenState extends State<ChallengeAcceptedScreen> {
  int? _selectedRating;
  String? _selectedDifficulty;
  List<String> _selectedEnjoyments = [];
  final TextEditingController _thoughtsController = TextEditingController();

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer for centering
                  Text(
  'Challenge Complete!',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                  GestureDetector(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.charcoal,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Header section with trophy in white container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        AcceptedHeaderSection(
                          challengeTitle: widget.challengeTitle,
                        ),
                        const SizedBox(height: 22),
                        AcceptedRatingSection(
                          selectedRating: _selectedRating,
                          onRatingChanged: (rating) {
                            setState(() {
                              _selectedRating = rating;
                            });
                          },
                        ),

                        const SizedBox(height: 38),

                        // Difficulty Feedback
                        AcceptedDifficultySection(
                          selectedDifficulty: _selectedDifficulty,
                          onDifficultySelected: (difficulty) {
                            setState(() {
                              _selectedDifficulty = difficulty;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

   
                  AcceptedEnjoymentSection(
                    selectedEnjoyments: _selectedEnjoyments,
                    onEnjoymentToggled: (enjoyment) {
                      setState(() {
                        if (_selectedEnjoyments.contains(enjoyment)) {
                          _selectedEnjoyments.remove(enjoyment);
                        } else {
                          _selectedEnjoyments.add(enjoyment);
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  // Additional Thoughts
                  AcceptedThoughtsSection(
                    controller: _thoughtsController,
                  ),

                  const SizedBox(height: 40),

                  // Achievements Unlocked
                  AcceptedAchievementsSection(
                    challengeTitle: widget.challengeTitle,
                  ),

                  const SizedBox(height: 40),

                  // New Badge Earned
                  AcceptedNewBadgeSection(
                    badgeName: 'Corniche Explorer',
                    badgeDescription: 'Complete 5 rides on the Corniche',
                    imagePath: 'assets/images/cycling_1.png',
                  ),

                  const SizedBox(height: 25),

                  // Action Buttons
                  AcceptedActionsSection(
                    onShare: () {
                      // Handle share
                      debugPrint('Share challenge tapped');
                    },
                    onContinue: () {
                      // Handle continue
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
