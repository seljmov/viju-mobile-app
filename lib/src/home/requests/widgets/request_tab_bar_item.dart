import 'package:flutter/material.dart';

import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';

/// Элемент таб-бара
class RequestTabBarItem extends StatelessWidget {
  const RequestTabBarItem({
    super.key,
    required this.title,
    required this.isPicked,
  });

  final String title;
  final bool isPicked;

  @override
  Widget build(BuildContext context) {
    final titlePickedStyle = context.textTheme.titleSmall!.copyWith(
      color: Colors.white,
    );
    final titleStyle = titlePickedStyle.copyWith(
      color: kGray3Color,
      fontWeight: FontWeight.w500,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isPicked ? kGray3Color : context.currentTheme.cardTheme.color,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          title,
          style: isPicked ? titlePickedStyle : titleStyle,
        ),
      ),
    );
  }
}
