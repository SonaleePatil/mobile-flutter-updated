import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/shared/widgets/ride_info_card.dart';
import 'package:flutter/material.dart';

class RideInfoSection extends StatelessWidget {
  const RideInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
Text(
  'Ride in Abu Dhabi',
  style: theme.textTheme.titleLarge?.copyWith(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),

          const SizedBox(height: 12),

          // Cards
          const RideInfoCard(
            title: 'Official Cycling Routes',
            subtitle: 'Explore safe routes across Abu Dhabi',
          ),
          SizedBox(height: 12),
          RideInfoCard(
            title: 'Track Safety & Guidelines',
            subtitle: 'Stay safe on every ride',
          ),
        ],
      ),
    );
  }
}
