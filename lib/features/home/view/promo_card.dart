import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

class PromoData {
  final String image;
  final String title;
  final String subtitle;
  final String highlight;
  final String buttonText;

  PromoData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.buttonText,
  });
}

class PromoCard extends StatelessWidget {
  static const Color _primaryBlue = Color(0xFF0359E8);
  static const Color _deepBlue = Color(0xFF023282);
  static const Color _actionGreen = Color(0xFF06B486);

  final PromoData data;

  const PromoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _primaryBlue,
                    _deepBlue,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 19,
            right: 13,
            child: Container(
              width: 147,
              height: 147,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 18,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
            ),
          ),
          Positioned(
            top: -18,
            right: -30,
            bottom: -42,
            width: 205,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.92,
                child: AdaptiveImage(
                  imagePath: data.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0, 0.58, 1],
                  colors: [
                    _primaryBlue,
                    _primaryBlue,
                    Color(0x000359E8),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 158,
                  child: Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.subtitle.isNotEmpty ? data.subtitle : data.highlight,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 115,
                  height: 29,
                  decoration: BoxDecoration(
                    color: _actionGreen,
                    borderRadius: BorderRadius.circular(17.2674),
                  ),
                  child: Center(
                    child: Text(
                      data.buttonText,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
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
