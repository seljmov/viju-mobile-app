import 'package:flutter/material.dart';

import '../../../theme/theme_extention.dart';

/// Шапка для BottomSheep
class ThesisBottomSheepHeader extends StatelessWidget {
  const ThesisBottomSheepHeader({
    super.key,
    this.title,
    this.titleFontSize,
    this.onPop,
  });

  final String? title;
  final double? titleFontSize;
  final void Function()? onPop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 22,
        ).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Visibility(
              visible: (title ?? '').isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  title ?? '',
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
