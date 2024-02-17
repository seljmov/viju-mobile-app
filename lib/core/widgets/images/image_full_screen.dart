import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/assets_constants.dart';
import '../../models/multi_image.dart';
import '../thesis_progress_bar.dart';

/// Просмотр изображения во весь экран
class ImageFullScreen extends StatelessWidget {
  const ImageFullScreen({
    super.key,
    required this.image,
  });

  final MultiImage image;

  @override
  Widget build(BuildContext context) {
    final fromNetwork = image.path != null;
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
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
        ),
        child: Center(
          child: InteractiveViewer(
            child: Visibility(
              visible: fromNetwork,
              child: Image.network(
                image.path ?? "",
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: ThesisProgressBar(color: Colors.white),
                  );
                },
              ),
              replacement: Image.file(image.file ?? File("")),
            ),
          ),
        ),
      ),
    );
  }
}
