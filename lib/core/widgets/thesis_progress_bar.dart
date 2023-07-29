import 'package:flutter/material.dart';

import '../../../theme/theme_extention.dart';

/// Компонент прогресс-бара
class ThesisProgressBar extends StatelessWidget {
  const ThesisProgressBar({
    Key? key,
    this.color,
    this.size = const Size(24.0, 24.0),
    this.strokeWidth = 2.5,
  }) : super(key: key);

  final Color? color;
  final Size size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CircularProgressIndicator(
        color: color ?? context.textSecondaryColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
