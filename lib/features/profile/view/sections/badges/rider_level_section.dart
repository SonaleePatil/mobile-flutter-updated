import 'package:flutter/material.dart';
import 'package:adcc/core/theme/app_colors.dart';

class RiderStatsSection extends StatelessWidget {
  final String riderLevel;

  final String badgesTitle;
  final String badgesValue;

  final String pointsTitle;
  final String pointsValue;

  final String progressTitle;
  final String progressValue;

  const RiderStatsSection({
    super.key,
    required this.riderLevel,
    required this.badgesTitle,
    required this.badgesValue,
    required this.pointsTitle,
    required this.pointsValue,
    required this.progressTitle,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            width: 359,
            height: 40,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 11,
              left: 13,
              right: 13,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(12),
             
            ),
            alignment: Alignment.centerLeft,
            child: Text(
  riderLevel,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.7012,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.charcoal
  ),
)
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 75,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                _StatCard(
                  title: badgesTitle,
                  value: badgesValue,
                ),
                const SizedBox(width: 13),
                _StatCard(
                  title: pointsTitle,
                  value: pointsValue,
                ),
                const SizedBox(width: 13),
                _StatCard(
                  title: progressTitle,
                  value: progressValue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 111,
      height: 75,
      padding: const EdgeInsets.only(
        top: 10,
        right: 19,
        bottom: 10,
        left: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0XFF3333333B),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 1,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 8.8383),
          Text(
            value,
            style:  TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              height: 1,
              color: AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}