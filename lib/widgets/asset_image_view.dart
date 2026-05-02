// lib/widgets/asset_image_view.dart
import 'package:flutter/material.dart';
import '../theme.dart';

/// Displays a local asset image with a loading placeholder and error fallback.
/// [path] must be a Flutter asset path, e.g. "assets/img/foo.jpg".
class AssetImageView extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const AssetImageView({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget img = Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _placeholder(),
    );

    if (borderRadius != null) {
      img = ClipRRect(borderRadius: borderRadius!, child: img);
    }

    return img;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: kCard,
      child: const Center(
        child: Icon(Icons.image_not_supported_rounded,
            color: kTextMuted, size: 40),
      ),
    );
  }
}
