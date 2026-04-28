import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PurposeBasedEventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String groupName;
  final VoidCallback? onTap;
  final double width;

  const PurposeBasedEventCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.groupName,
    this.onTap,
    this.width = 320,
  });

  bool get _isNetworkImage {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  bool get _isBase64Image {
    return imagePath.startsWith('data:image/');
  }

  Widget _buildImage() {
    if (_isBase64Image) {
      try {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.memory(
            _base64Decode(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.grey,
                ),
              );
            },
          ),
        );
      } catch (e) {
        return Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey,
          ),
        );
      }
    } else if (_isNetworkImage) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey,
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey,
              ),
            );
          },
        ),
      );
    }
  }

  /// Decode base64 image data URI
  Uint8List _base64Decode(String dataUri) {
    final base64String =
        dataUri.contains(',') ? dataUri.split(',')[1] : dataUri;
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 320, // Fixed card height
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
          
              _buildImage(),

             
             Positioned(
  top: 13,
left: 12,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        width: 150,
        height: 24,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(6, 4, 4, 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C20).withOpacity(0.33),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            groupName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFFFEFD7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    ),
  ),
),

              Positioned(
                left: 0,
                right: 0,
                bottom: 15,
                // padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.softCream,
                    borderRadius: BorderRadius.all( 
                      Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Event Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      /// Date with Calendar Icon
                      Row(
                        children: [
                          Image.asset(
      'assets/icons/calender.png',
      height: 16,
      width: 16,
    ),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
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
    );
  }
}
