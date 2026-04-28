import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RouteFacilitiesSection extends StatelessWidget {
  final List<Map<String, dynamic>> facilities;

  const RouteFacilitiesSection({
    super.key,
    required this.facilities,
  });

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Facilities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              final facility = facilities[index];

              return _FacilityCard(
                iconPath: facility['icon'] as String? ?? 'assets/icons/default.png',
                label: facility['label'] as String? ?? '',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final String iconPath;
  final String label;

  const _FacilityCard({
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            iconPath,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Icon(
                Icons.image,
                size: 22,
                color: AppColors.charcoal,
              );
            },
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.charcoal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}