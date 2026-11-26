import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';

/// Network image with a grey placeholder. Uses an <img> fallback on web
/// because the poster host sends no CORS headers.
class NetworkPoster extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const NetworkPoster(this.url, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _Placeholder();
    return Image.network(
      url,
      fit: fit,
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (_, _, _) => const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.darkGrey,
      child: Center(child: Icon(Icons.broken_image, color: Colors.white38)),
    );
  }
}
