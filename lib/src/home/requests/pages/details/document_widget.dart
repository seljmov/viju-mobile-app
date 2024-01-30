import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets_constants.dart';
import '../../../../../theme/theme_colors.dart';

final Map<String, Color> _docColors = {
  'pdf': kRedColor,
  'doc': kBlueColor,
  'docx': kBlueColor,
};

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 4,
            child: SvgPicture.asset(
              AppIcons.doc,
              height: 36,
            ),
          ),
          Positioned(
            bottom: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.docPanel,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _docColors[type] ?? kGray2Color,
                    BlendMode.srcATop,
                  ),
                ),
                Positioned(
                  bottom: 3,
                  child: Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 6,
                      fontWeight: FontWeight.w700,
                      color: kLightBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
