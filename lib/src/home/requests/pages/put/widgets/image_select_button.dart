import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/assets_constants.dart';
import '../../../../../../core/models/multi_image.dart';
import '../../../../../../core/widgets/images/image_selector.dart';
import '../../../../../../theme/theme_colors.dart';

/// Кнопка выбора изображения
class ImageSelectButton extends StatelessWidget {
  const ImageSelectButton({
    Key? key,
    required this.imagesFiles,
    this.size = const Size(100, 100),
  }) : super(key: key);

  final ValueNotifier<List<MultiImage>> imagesFiles;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickFiles = await ImageSeletorHelper.select(context);
        imagesFiles.value += List.from(pickFiles);
      },
      child: ImageSelectWidget(size: size),
    );
  }
}

class ImageSelectWidget extends StatelessWidget {
  const ImageSelectWidget({
    super.key,
    this.size = const Size(100, 100),
    this.isDisabled = false,
  });

  final Size size;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: isDisabled ? kGray2Color : const Color(0xFFF2F4FD),
        child: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppIcons.add,
            fit: BoxFit.scaleDown,
            colorFilter: ColorFilter.mode(
              isDisabled ? kGray3Color : const Color(0xFF1E1E1E),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
