import 'package:flutter/material.dart';

/// A reusable cake image widget used across the list and detail screens.
/// Displays a fallback icon if the URL is empty or fails to load.
class CakeImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const CakeImage({required this.imageUrl, this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _ImageFallBack(),
            )
          : const _ImageFallBack(),
    );
  }
}

class _ImageFallBack extends StatelessWidget {
  const _ImageFallBack();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.cake, size: 32.0)),
    );
  }
}
