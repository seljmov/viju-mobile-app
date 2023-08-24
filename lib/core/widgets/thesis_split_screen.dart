import 'package:flutter/material.dart';

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
