import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'dart:ui';
class TrackCard extends StatelessWidget {
  final String imagePath; 
  final String title;
  final String city;
  final String distance;
  final String subtitle;
  final String difficulty;
  final String status;

  final VoidCallback? onTap;

  // sizing
  final double width;
  final double height;

  const TrackCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.city,
    required this.distance,
    required this.subtitle,
    required this.difficulty,
    required this.status,
    this.onTap,
    this.width = double.infinity,
    this.height = 281,
  });

 
  Widget _buildTrackImage() {
  
    if (imagePath.startsWith("data:image")) {
      try {
        final base64Str = imagePath.split(",").last;
        final bytes = base64Decode(base64Str);

        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _errorImage(),
        );
      } catch (_) {
        return _errorImage();
      }
    }

 
    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _errorImage(),
      );
    }


    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _errorImage(),
    );
  }

  Widget _errorImage() {
    return Container(
      color: const Color(0xFFD94A4A),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.buttonGuest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                ClipRRect(
              borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _buildTrackImage(),
                        ),

                        // overlay
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ),

                      // Left chip
Positioned(
  left: 12,
  top: 12,
  child: _SmallChip(
    text: difficulty,
  ),
),

// Right chip
Positioned(
  right: 12,
  top: 12,
  child: _SmallChip(
    text: status,
  ),
),
                      ],
                    ),
                  ),
                ),

                //  CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    
                        Row(
                          children: [
                            const _AssetIcon(
                              assetPath: "assets/icons/location.png",
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child:Text(
  city,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.8),
  ),
),
                            ),
                            const SizedBox(width: 10),
                            const _AssetIcon(
                              assetPath: "assets/icons/km.png",
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                           Text(
  distance,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4, // 19.6 / 14
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                          ],
                        ),

                        const SizedBox(height:7 ),

                    
                    Text(
  title,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),

                        const SizedBox(height: 14),

                 
                        Text(
  subtitle,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.16, // 13.9441 / 12 ≈ 1.16
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.7),
  ),
),
                        const Spacer(),

                      
                        const Row(
                          children: [
                            _AmenityItem(
                              iconPath: "assets/icons/lighting.png",
                              label: 'Lighting',
                            ),
                            SizedBox(width: 14),
                            _AmenityItem(
                              iconPath: "assets/icons/water_statoins.png",
                              label: 'Water stataion',
                            ),
                            SizedBox(width: 14),
                            _AmenityItem(
                              iconPath: "assets/icons/restrooms.png",
                              label: 'Restroom',
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _SmallChip extends StatelessWidget {
  final String text;

  const _SmallChip({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0x26000000), // #000000 15%
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child:Text(
  text,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
),
        ),
      ),
    );
  }
}

class _AssetIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const _AssetIcon({
    required this.assetPath,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return Icon(Icons.image, size: size, color: Colors.black54);
      },
    );
  }
}


class _AmenityItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const _AmenityItem({
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AssetIcon(assetPath: iconPath, size: 16),
        const SizedBox(width: 6),
      Text(
  label,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12.82, // 12.8226 ≈ 12.82
    fontWeight: FontWeight.w400,
    height: 1.33, // 17.0968 / 12.8226 ≈ 1.33
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),
      ],
    );
  }
}
