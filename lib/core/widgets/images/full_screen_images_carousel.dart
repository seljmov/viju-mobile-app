import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../theme/theme_colors.dart';
import '../../constants/assets_constants.dart';
import '../../models/multi_image.dart';
import 'network_image_preview.dart';

/// Просмотр изображений каруселью
class FullScreenImagesCarousel extends StatelessWidget {
  const FullScreenImagesCarousel({
    Key? key,
    required this.images,
    this.currentIndex,
    this.fromNetwork = true,
  }) : super(key: key);

  final List<MultiImage> images;
  final bool fromNetwork;
  final int? currentIndex;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.8;
    final imageActiveNotifier = ValueNotifier<int>(currentIndex ?? 0);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.close,
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Visibility(
        visible: images.isEmpty,
        child: const Center(
          child: Text(
            "Список изображений пуст...",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        replacement: ValueListenableBuilder<int>(
          valueListenable: imageActiveNotifier,
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index, realIndex) {
                    return InteractiveViewer(
                      child: Visibility(
                        visible: fromNetwork,
                        child: NetworkImagePreview(
                          imageUrl: images[index].path ?? "",
                          options: const NetworkImagePreviewOptions(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                        replacement: images[index].path == null
                            ? Image.file(images[index].file!)
                            : Image.asset(images[index].path!),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    enableInfiniteScroll: images.length > 1,
                    autoPlay: false,
                    disableCenter: true,
                    viewportFraction: 1,
                    height: height,
                    initialPage: value,
                    onPageChanged: (index, _) {
                      imageActiveNotifier.value = index;
                    },
                  ),
                ),
                Visibility(
                  visible: images.length > 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                    ),
                    child: AnimatedSmoothIndicator(
                      activeIndex: value,
                      count: images.length,
                      effect: const WormEffect(
                        dotWidth: 8,
                        dotHeight: 8,
                        activeDotColor: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
