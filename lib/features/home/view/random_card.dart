import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FeaturedEventCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String distance;
  final VoidCallback? onTap;

  const FeaturedEventCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.distance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 275,
        width: double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      height: 275,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/cycling_1.png',
                        height: 275,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      image,
                      height: 275,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: Color(0xffC12D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),

          Positioned(
  left: 15,
  right: 15,
  top: 160,
  child: Container(
    width: 328,
    height: 100,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9EF), // #FFF9EF
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        /// Featured Tag
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffC12D32),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
  "Featured",
  style: const TextStyle(
    fontFamily: 'Geist',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12, // ≈1.33
    letterSpacing: 0,
    color: Color(0xFFFFF4E3),
  ),
)
        ),

        const SizedBox(height: 6),

       /// Title
Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.15,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

        const SizedBox(height: 6),

        /// Date + Distance Row
        Row(
          children: [
            Image.asset(
              "assets/icons/calender.png",
              width: 14,
              height: 14,
            ),
            const SizedBox(width: 4),

           Text(
  date,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.8226,
    fontWeight: FontWeight.w400,
    height: 17.0968 / 12.8226, // ≈1.33
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),

            const SizedBox(width: 12),

            Image.asset(
              "assets/icons/km_empty.png",
              width: 14,
              height: 14,
            ),

            const SizedBox(width: 4),

          Text(
  distance,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.8226,
    fontWeight: FontWeight.w400,
    height: 17.0968 / 12.8226,
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),
          ],
        ),
      ],
    ),
  ),
)
          ],
        ),
      ),
    ),
    );
  }
}