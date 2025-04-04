import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  const CustomImage({
    Key? key,
    this.imageUrl,
    this.height = 100.0,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  bool _isLocalAsset(String? path) {
    return path != null &&
        (path.startsWith('assets/') || path.startsWith('images/'));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocalAsset(imageUrl)) {
      // 🔹 If local image
      return Image.asset(
        imageUrl!,
        height: height,
        width: width,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => const Icon(Icons.broken_image),
      );
    } else {
      // 🔹 If network image
      return CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        height: height,
        width: width,
        fit: fit,
        placeholder:
            (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
  }
}
