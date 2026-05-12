import 'dart:ui';

import 'package:flutter/material.dart';

class ChallengeAcceptedScreen extends StatefulWidget {
  const ChallengeAcceptedScreen({
    super.key,
    required this.challengeId,
    required this.challengeTitle,
  });

  final String challengeId;
  final String challengeTitle;

  @override
  State<ChallengeAcceptedScreen> createState() =>
      _ChallengeAcceptedScreenState();
}

class _ChallengeAcceptedScreenState extends State<ChallengeAcceptedScreen> {
  int _selectedRating = 4;
  String _selectedDifficulty = 'Too Easy';
  final Set<String> _selectedEnjoyments = {'Great Challenge'};
  final TextEditingController _thoughtsController = TextEditingController();

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 65, 16, 28),
          children: [
            _CompletionTopBar(
              onClose: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: 23),
            _CompletionFeedbackCard(
              title: widget.challengeTitle,
              selectedRating: _selectedRating,
              selectedDifficulty: _selectedDifficulty,
              onRatingChanged: (value) => setState(() {
                _selectedRating = value;
              }),
              onDifficultyChanged: (value) => setState(() {
                _selectedDifficulty = value;
              }),
            ),
            const SizedBox(height: 36),
            _EnjoymentSection(
              selected: _selectedEnjoyments,
              onToggle: (value) => setState(() {
                if (_selectedEnjoyments.contains(value)) {
                  _selectedEnjoyments.remove(value);
                } else {
                  _selectedEnjoyments.add(value);
                }
              }),
            ),
            const SizedBox(height: 34),
            _ThoughtsSection(controller: _thoughtsController),
            const SizedBox(height: 34),
            const _AchievementsUnlockedSection(),
            const SizedBox(height: 40),
            const _NewBadgeCard(),
            const SizedBox(height: 25),
            _ShareChallengeButton(
              onPressed: () => debugPrint('Share challenge tapped'),
            ),
            const SizedBox(height: 15),
            _ContinueButton(
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionTopBar extends StatelessWidget {
  const _CompletionTopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Challenge Complete!',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: onClose,
              style: IconButton.styleFrom(
                fixedSize: const Size(35, 35),
                backgroundColor: const Color(0x12D4D4D4),
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionFeedbackCard extends StatelessWidget {
  const _CompletionFeedbackCard({
    required this.title,
    required this.selectedRating,
    required this.selectedDifficulty,
    required this.onRatingChanged,
    required this.onDifficultyChanged,
  });

  final String title;
  final int selectedRating;
  final String selectedDifficulty;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 529,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Rectangle22.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/cycling_1.png',
              fit: BoxFit.cover,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xCC000000),
                  Colors.transparent,
                ],
                stops: [0.0003, 1],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 38,
            child: Column(
              children: [
                const _AchievementMark(),
                const SizedBox(height: 55),
                const Text(
                  'Challenge Complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 33,
            right: 34,
            top: 218,
            child: _RatingGlassPanel(
              selectedRating: selectedRating,
              onRatingChanged: onRatingChanged,
            ),
          ),
          Positioned(
            left: 17,
            right: 17,
            top: 344,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How was the difficulty?',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: [
                    _DifficultyButton(
                      label: 'Too Easy',
                      icon: Icons.sentiment_satisfied_alt_rounded,
                      isSelected: selectedDifficulty == 'Too Easy',
                      onTap: () => onDifficultyChanged('Too Easy'),
                    ),
                    _DifficultyButton(
                      label: 'Just Right',
                      icon: Icons.sentiment_neutral_rounded,
                      isSelected: selectedDifficulty == 'Just Right',
                      onTap: () => onDifficultyChanged('Just Right'),
                    ),
                    _DifficultyButton(
                      label: 'Too Hard',
                      icon: Icons.sentiment_dissatisfied_rounded,
                      isSelected: selectedDifficulty == 'Too Hard',
                      onTap: () => onDifficultyChanged('Too Hard'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementMark extends StatelessWidget {
  const _AchievementMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFCE6921).withValues(alpha: 0.25),
            const Color(0xFFEF7722).withValues(alpha: 0.25),
          ],
        ),
      ),
      child: const Icon(
        Icons.emoji_events_rounded,
        color: Color(0xFFFFB655),
        size: 42,
      ),
    );
  }
}

class _RatingGlassPanel extends StatelessWidget {
  const _RatingGlassPanel({
    required this.selectedRating,
    required this.onRatingChanged,
  });

  final int selectedRating;
  final ValueChanged<int> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9.95),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 97,
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(9.95),
          ),
          child: Column(
            children: [
              const Text(
                'Rate Your Experience',
                style: TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 15.8,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 1; index <= 5; index++) ...[
                    GestureDetector(
                      onTap: () => onRatingChanged(index),
                      child: Icon(
                        index <= selectedRating
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: index.isEven ? 33 : 32,
                      ),
                    ),
                    if (index != 5) const SizedBox(width: 8),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 42,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF06A16F)
                  : Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EnjoymentSection extends StatelessWidget {
  const _EnjoymentSection({
    required this.selected,
    required this.onToggle,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What did you enjoy?',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.25,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in _enjoymentItems)
              _EnjoymentTile(
                data: item,
                isSelected: selected.contains(item.label),
                onTap: () => onToggle(item.label),
              ),
          ],
        ),
      ],
    );
  }
}

class _EnjoymentTile extends StatelessWidget {
  const _EnjoymentTile({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _EnjoymentItem data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        height: 96,
        padding: const EdgeInsets.fromLTRB(20, 17, 16, 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF06A16F) : const Color(0xFFCAECE1),
          borderRadius: BorderRadius.circular(9.95),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              data.icon,
              size: 30,
              color: isSelected ? Colors.white : const Color(0xFF06A16F),
            ),
            const Spacer(),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                height: 1.23,
                color: isSelected ? Colors.white : const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThoughtsSection extends StatelessWidget {
  const _ThoughtsSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Thoughts',
          style: TextStyle(
            fontFamily: 'Geist',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: Color(0xFF1A1C20),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          minLines: 6,
          maxLines: 6,
          cursorColor: const Color(0xFF06A16F),
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            color: Color(0xFF333333),
          ),
          decoration: InputDecoration(
            hintText: 'Share details about your experience.',
            hintStyle: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF333333).withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: const Color(0xFFEBF7F3),
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.4),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E5E5), width: 1.16),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.4),
              borderSide:
                  const BorderSide(color: Color(0xFF06A16F), width: 1.16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AchievementsUnlockedSection extends StatelessWidget {
  const _AchievementsUnlockedSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements Unlocked',
          style: TextStyle(
            fontFamily: 'Geist',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: Color(0xFF1A1C20),
          ),
        ),
        SizedBox(height: 20),
        _AchievementTile(
          icon: Icons.emoji_events_outlined,
          title: 'Distance Champion Badge',
          subtitle: 'Earned today',
        ),
        SizedBox(height: 12),
        _AchievementTile(
          icon: Icons.add_card_rounded,
          title: '+100 Reward Points',
          subtitle: 'Added to your account',
        ),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

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
              color: const Color(0xFFEBF7F3),
              borderRadius: BorderRadius.circular(18.55),
            ),
            child: Icon(icon, color: const Color(0xFF06A16F), size: 32),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  subtitle,
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

class _NewBadgeCard extends StatelessWidget {
  const _NewBadgeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9.2),
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/cycling_1.png',
                width: 149,
                height: 162,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCAECE1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.military_tech_rounded,
                    size: 31,
                    color: Color(0xFF06A16F),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'New Badge Earned!',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.75,
                    color: Color(0xFF333333),
                  ),
                ),
                const Text(
                  'Corniche Explorer',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.28,
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                    color: Color(0xFF333333),
                  ),
                ),
                const Text(
                  'Complete 5 rides on the Corniche',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.28,
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                    color: Color(0xFF333333),
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

class _ShareChallengeButton extends StatelessWidget {
  const _ShareChallengeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.share_outlined, size: 20),
        label: const Text('Share Your Challenge'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF06A16F),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF333333),
          side: const BorderSide(color: Color(0xFF333333)),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Continue'),
      ),
    );
  }
}

class _EnjoymentItem {
  const _EnjoymentItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

const List<_EnjoymentItem> _enjoymentItems = [
  _EnjoymentItem(
    label: 'Great Challenge',
    icon: Icons.emoji_events_rounded,
  ),
  _EnjoymentItem(
    label: 'Perfect Difficulty',
    icon: Icons.speed_rounded,
  ),
  _EnjoymentItem(
    label: 'Motivating',
    icon: Icons.local_fire_department_rounded,
  ),
  _EnjoymentItem(
    label: 'Achievable Goals',
    icon: Icons.track_changes_rounded,
  ),
];
