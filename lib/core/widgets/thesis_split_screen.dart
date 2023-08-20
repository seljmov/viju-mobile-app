import 'package:flutter/material.dart';

import '../helpers/my_logger.dart';

/// Виджет разделения экрана на две части
class ThesisSplitScreen extends StatelessWidget {
  const ThesisSplitScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            MyLogger.d(
              'ThesisSplitScreen: ${constraints.maxWidth}x${constraints.maxHeight}',
            );
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
