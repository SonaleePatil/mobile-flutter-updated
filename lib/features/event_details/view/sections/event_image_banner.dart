import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class EventImageBanner extends StatelessWidget {
  final String? imagePath;
  final String? base64Image;
  final VoidCallback? onBackTap;

  const EventImageBanner({
    super.key,
    this.imagePath,
    this.base64Image,
    this.onBackTap,
  });

  ImageProvider _buildImage() {
  
    if (base64Image != null &&
        base64Image!.isNotEmpty &&
        base64Image!.contains(',')) {
      try {
        final base64String = base64Image!.split(',').last;
        Uint8List bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (_) {
        return const AssetImage('assets/images/cycling_1.png');
      }
    }

    // Asset Image
    if (imagePath != null && imagePath!.isNotEmpty) {
      return AssetImage(imagePath!);
    }

    return const AssetImage('assets/images/cycling_1.png');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 414,
        width: double.infinity,
        child: Stack(
          children: [

            Positioned.fill(
              child: Image(
                image: _buildImage(),
                fit: BoxFit.cover,
              ),
            ),

            /// Back Button
            Positioned(
              left: 16,
              top: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBackTap ?? () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFFB93A3A),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}