import 'package:flutter/material.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD4AA27),
          borderRadius: BorderRadius.circular(16),
          
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildAchievementsGrid(),
          ],
        ),
      ),
    );
  }

 Widget _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
         Image.asset(
  "assets/icons/achive.png",   
  height: 22,
  width: 22,
  fit: BoxFit.contain,
),
          SizedBox(width: 8),
          Text(
  "Achievements",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 28 / 18, // ≈1.56
    letterSpacing: 0,
    color: Colors.white,
  ),
)
        ],
      ),
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: const [
               Text(
  "View All",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14, // ≈1.43
    letterSpacing: 0,
    color: Colors.white,
  ),
),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildAchievementsGrid() {
    const double spacing = 12;
    const double rowSpacing = 16;

    return Column(
      children: [
      
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _AchievementItem(
                imagePath: 'assets/icons/beginner.png',
                label: "Beginner Loop\nBadge",
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: _AchievementItem(
                imagePath: 'assets/icons/night_rider.jpg',
                label: "Night Rider",
              ),
            ),
            const SizedBox(width: spacing),
           Expanded(
  child: _AchievementItem(
    imagePath: 'assets/icons/awareness.png',
    label: "Awareness\nCampaign Rider",
    useIconContainer: true,
  ),
),
            const SizedBox(width: spacing),
            Expanded(
              child: _AchievementItem(
                imagePath: 'assets/icons/desert.jpg',
                label: "Desert\nEndurance Finisher",
              ),
            ),
          ],
        ),
        const SizedBox(height: rowSpacing),

       
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _AchievementItem(
                imagePath: 'assets/icons/century_club.jpg',
                label: "Century Club",
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: _AchievementItem(
                imagePath: 'assets/icons/streak_master.jpg',
                label: "Streak Master",
              ),
            ),
         
            const SizedBox(width: spacing),
            const Expanded(child: SizedBox.shrink()),
            const SizedBox(width: spacing),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }
}
class _AchievementItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool useIconContainer;

  const _AchievementItem({
    required this.imagePath,
    required this.label,
    this.useIconContainer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        /// Special container for 3rd item
        if (useIconContainer)
          Container(
            width: 67,
            height: 65,
            padding: const EdgeInsets.fromLTRB(15, 14, 16, 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEFD7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 36,
                height: 36,
               
                fit: BoxFit.contain,
              ),
            ),
          )

        /// Normal image badges
        else
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

        const SizedBox(height: 8),

        Text(
  label,
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0,
    color: Colors.white,
  ),
)
      ],
    );
  }
}