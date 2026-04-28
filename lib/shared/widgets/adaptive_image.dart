import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

/// A widget that can display images from assets, network URLs, or base64 data URIs
class AdaptiveImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final Color? placeholderColor;

  const AdaptiveImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholderColor,
  });

  bool get _isNetworkImage {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  bool get _isFileImage {
    return imagePath.startsWith('/') || imagePath.startsWith('file://');
  }

  bool get _isBase64Image {
    return imagePath.startsWith('data:image/');
  }

  @override
  Widget build(BuildContext context) {
    if (_isBase64Image) {
      return _buildBase64Image();
    } else if (_isNetworkImage) {
      return _buildNetworkImage();
    } else if (_isFileImage) {
      return _buildFileImage();
    } else {
      return _buildAssetImage();
    }
  }

  Widget _buildFileImage() {
    try {
      final filePath = imagePath.startsWith('file://')
          ? Uri.parse(imagePath).toFilePath()
          : imagePath;
      final file = File(filePath);
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    } catch (e) {
      return errorWidget ?? _defaultErrorWidget();
    }
  }

  Widget _buildBase64Image() {
    try {
      // Remove data URI prefix (e.g., "data:image/png;base64,")
      final base64String = imagePath.contains(',') 
          ? imagePath.split(',')[1] 
          : imagePath;
      final bytes = base64Decode(base64String);
      
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    } catch (e) {
      return errorWidget ?? _defaultErrorWidget();
    }
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: placeholderColor ?? Colors.grey[200],
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
        return errorWidget ?? _defaultErrorWidget();
      },
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _defaultErrorWidget();
      },
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? Colors.grey[200],
      child: const Icon(
        Icons.error_outline,
        size: 48,
        color: Colors.grey,
      ),
    );
  }
}
