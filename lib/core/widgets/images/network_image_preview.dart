import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../repositories/tokens/tokens_repository_impl.dart';
import '../thesis_progress_bar.dart';

/// Кеш-менеджер для изображений
class NetworkImagePreviewCacheManager {
  static const key = 'networkImagePPreviewCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );
}

/// Опции для компонент вывода изображения из интернета
class NetworkImagePreviewOptions {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final CacheManager? cacheManager;

  const NetworkImagePreviewOptions({
    this.cacheManager,
    this.borderRadius,
    this.width,
    this.height,
    this.fit,
  });
}

/// Компонент вывода изображения из интернета
class NetworkImagePreview extends StatelessWidget {
  const NetworkImagePreview({
    Key? key,
    required this.imageUrl,
    this.options,
  }) : super(key: key);

  final String imageUrl;
  final NetworkImagePreviewOptions? options;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: imageUrl.isNotEmpty,
      child: FutureBuilder<String?>(
        future: TokensRepositoryImpl().getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: ThesisProgressBar(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }

          final token = snapshot.data!;
          final headers = {
            "Accept": "*/*",
            "Authorization": "Bearer $token",
          };

          return CachedNetworkImage(
            cacheManager: options?.cacheManager ??
                NetworkImagePreviewCacheManager.instance,
            width: options?.width,
            height: options?.height,
            fit: options?.fit,
            httpHeaders: headers,
            imageUrl: imageUrl,
            placeholder: (_, __) => const Center(
              child: ThesisProgressBar(),
            ),
            errorWidget: (context, url, error) {
              final size = MediaQuery.of(context).size;
              return Container(
                height: size.height,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "lib/assets/icons/large_error.svg",
                    width: 48,
                    colorFilter: const ColorFilter.mode(
                      Colors.redAccent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: options?.borderRadius ??
                      const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: options?.fit ?? BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
