import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class JoinEventEventCard extends StatelessWidget {
  const JoinEventEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 357,
        height: 226,
        decoration: BoxDecoration(
          color: const Color(0xFFEFCB95),
          borderRadius: BorderRadius.circular(20.6999),
          border: Border.all(
            color: const Color(0xFFFFDDA8),
            width: 1.5083,
          ),
        ),
        child: Stack(
          children: [

            /// MAIN IMAGE
            Positioned(
              left: 8,
              top: 22,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/cycling_1.png",
                  width: 100.905,
                  height: 87,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// TITLE + SUBTITLE
            const Positioned(
              left: 120,
              top: 28,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Abu Dhabi Night\nRace Series",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppColors.charcoal,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Yas Marina Circuit",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                       color: AppColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),

            /// WHEN CARD
            Positioned(
              left: 8,
              top: 138,
              child: _smallCard(
                 iconPath: "assets/icons/clock.png", // image icon
                title: "When",
                value: "18 July 2026",
              ),
            ),

            /// LOCATION CARD
            Positioned(
              left: 168,
              top: 138,
              child: _smallCard(
                iconPath: "assets/icons/distance.png", // image icon
                title: "Location",
                value: "Abu dhabi",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCard({
    required String iconPath,
    required String title,
    required String value,
  }) {
    return Container(
      width: 141,
      height: 61,
      padding: const EdgeInsets.only(
        top: 10.0234,
        right: 5,
        bottom: 6.4766,
        left: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(13.2955),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 16,
            height: 16,
            color: AppColors.deepRed,
          ),
          const SizedBox(width: 8.8637),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                   color: AppColors.charcoal,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}