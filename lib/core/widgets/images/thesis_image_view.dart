import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/assets_constants.dart';
import '../../models/multi_image.dart';
import 'network_image_preview.dart';

class ThesisImageView extends StatelessWidget {
  const ThesisImageView({
    super.key,
    required this.image,
    this.size = const Size(100, 100),
    this.onTap,
    this.onRemove,
  });

  final MultiImage image;
  final Size size;
  final void Function()? onTap;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    debugPrint('image: $image');
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: image.path != null
                ? NetworkImagePreview(imageUrl: image.path!)
                : Image.file(
                    image.file!,
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned.fill(
          child: Visibility(
            visible: onRemove != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF262626),
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.close,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
