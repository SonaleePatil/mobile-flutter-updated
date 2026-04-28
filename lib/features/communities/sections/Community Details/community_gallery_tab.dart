import 'package:flutter/material.dart';

class CommunityGalleryTab extends StatelessWidget {
  const CommunityGalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Row(
        children: [

          /// LEFT BIG IMAGE
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/cycling_1.png",
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// RIGHT COLUMN (3 IMAGES)
          Expanded(
            child: Column(
              children: [

                /// TOP IMAGE
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/cycling_1.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// MIDDLE IMAGE
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/cycling_1.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// BOTTOM IMAGE
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/cycling_1.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
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