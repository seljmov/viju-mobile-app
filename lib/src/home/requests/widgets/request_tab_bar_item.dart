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
    final titlePickedStyle = context.textTheme.titleMedium!.copyWith(
      color: kDarkTextPrimaryColor,
    );
    final titleStyle = titlePickedStyle.copyWith(
      color: context.isDarkMode
          ? kDarkTextSecondaryColor
          : kLightTextSecondaryColor,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isPicked
            ? kPrimaryLighterColor
            : context.currentTheme.cardTheme.color,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        child: Text(
          title,
          style: isPicked ? titlePickedStyle : titleStyle,
        ),
      ),
    );
  }
}
