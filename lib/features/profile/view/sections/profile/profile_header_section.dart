import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adcc/core/theme/app_colors.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String? profileImageUrl;
  final String name;
  final String location;
  final String skillLevel;
  final Map<String, String> stats;

  const ProfileHeaderSection({
    super.key,
    this.profileImageUrl,
    required this.name,
    required this.location,
    required this.skillLevel,
    required this.stats,
  });

  Widget _buildAvatar() {
    final hasNetworkImage =
        profileImageUrl != null && profileImageUrl!.startsWith('http');

    if (hasNetworkImage) {
      return Image.network(
        profileImageUrl!,
        width: 107,
        height: 107,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitialAvatar(),
      );
    }

    return _buildInitialAvatar();
  }

  Widget _buildInitialAvatar() {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      width: 107,
      height: 107,
      color: Colors.white24,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 44,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      height: 412,
      child: Container(
        color: AppColors.deepRed,
        child: Column(
          children: [
            const SizedBox(height: 16),

       
SizedBox(
  height: 60,
  child: Stack(
    alignment: Alignment.center,
    children: [
      /// ---- Center Title ----
      const Center(
        child: Text(
  'Profile',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Geist',
    fontSize: 25,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
)
      ),
    ],
  ),
),
            const SizedBox(height: 16),

     
            Container(
              width: 107,
              height: 107,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: _buildAvatar(),
              ),
            ),

            const SizedBox(height: 16),

           Text(
  name,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 21.6613,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0.22,
    color: Colors.white,
  ),
),

            const SizedBox(height: 8),

     
           Text(
  '$location - $skillLevel',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0.14,
    color: Colors.white,
  ),
),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    imagePath: 'assets/svg/meter_colored.svg',
                    value: stats['km'] ?? '0',
                    label: 'KM',
                  ),
                  _buildStatItem(
                    imagePath: 'assets/svg/colored_cycle.svg',
                    value: stats['rides'] ?? '0',
                    label: 'Rides',
                  ),
                  _buildStatItem(
                    imagePath: 'assets/svg/events_colored.svg',
                    value: stats['events'] ?? '0',
                    label: 'Events',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String imagePath,
    required String value,
    required String label,
  }) {
    return Column(
      children: [

        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
          ),
        ),

        const SizedBox(height: 8),


      Text(
  value,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0.17,
    color: Colors.white,
  ),
),

        const SizedBox(height: 4),

 
      Text(
  label,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0.11,
    color: Colors.white,
  ),
)
      ],
    );
  }
}