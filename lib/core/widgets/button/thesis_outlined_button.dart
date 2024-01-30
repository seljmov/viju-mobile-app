import 'package:flutter/material.dart';

import '../../../../theme/theme_extention.dart';
import '../thesis_progress_bar.dart';
import 'thesis_button_options.dart';

/// Компонент базовой кнопки с обводкой
class ThesisOutlinedButton extends StatelessWidget {
  ThesisOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.options = const ThesisButtonOptions(),
    this.isDisabled = false,
  });

  final String text;
  final ThesisButtonOptions options;
  final void Function() onPressed;
  final bool isDisabled;
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: isLoadingNotifier,
      builder: (context, isLoading, child) {
        return OutlinedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size(options.width ?? buttonWidth, options.height),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(
                color: Colors.black,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(options.borderRadius),
              ),
            ),
          ),
          onPressed: onPressed,
          child: _ThesisButtonContent(
            text: text,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
        );
      },
    );
  }
}

class _ThesisButtonContent extends StatelessWidget {
  const _ThesisButtonContent({
    required this.text,
    required this.isDisabled,
    required this.isLoading,
  });

  final String text;
  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = context.textTheme.titleLarge!;
    return Container(
      child: isLoading
          ? const ThesisProgressBar()
          : Text(
              text,
              style: isDisabled
                  ? defaultTextStyle
                  : defaultTextStyle.copyWith(color: Colors.black),
            ),
    );
  }
}
