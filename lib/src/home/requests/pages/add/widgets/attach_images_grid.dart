import 'package:flutter/material.dart';

import '../../../../../../core/models/multi_image.dart';
import '../../../../../../core/widgets/images/full_screen_images_carousel.dart';
import '../../../../../../core/widgets/images/thesis_image_view.dart';
import 'image_select_button.dart';

/// Компонент добавления изображений в сетке
class AttachImagesGrid extends StatelessWidget {
  const AttachImagesGrid({
    Key? key,
    required this.imagesNotifier,
  }) : super(key: key);

  final ValueNotifier<List<MultiImage>> imagesNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MultiImage>>(
      valueListenable: imagesNotifier,
      builder: (context, files, child) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: List.generate(
            files.length,
            (index) => ThesisImageView(
              image: files[index],
              size: const Size(100, 100),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return FullScreenImagesCarousel(
                    currentIndex: index,
                    images: files,
                    fromNetwork: false,
                  );
                }),
              ),
              onRemove: () {
                final newfiles = files;
                newfiles.removeAt(index);
                imagesNotifier.value = List.of(newfiles);
              },
            ),
          )..add(ImageSelectButton(imagesFiles: imagesNotifier)),
        );
      },
    );
  }
}
