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
              fontFamily: "Outfit",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 75,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: facilities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                return _FacilityCard(
                  iconPath:
                      facility['icon'] as String? ?? 'assets/icons/default.png',
                  label: facility['label'] as String? ?? '',
                );
              },
            ),
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
      width: 79.56,
      height: 74.67,
      padding: const EdgeInsets.fromLTRB(8, 11, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E5CD),
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
                Icons.circle,
                size: 22,
                color: Color(0xFFF09902),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 15.4727,
              color: Colors.black,
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
