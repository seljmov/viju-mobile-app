import 'package:flutter/material.dart';

import '../../../../../theme/theme_colors.dart';
import '../../../../../theme/theme_extention.dart';
import '../thesis_progress_bar.dart';
import 'thesis_button_options.dart';

/// Компонент базовой кнопки
class ThesisButton extends StatelessWidget {
  ThesisButton({
    super.key,
    required this.child,
    this.text,
    this.options = const ThesisButtonOptions(),
    required this.onPressed,
    this.isDisabled = false,
  });

  /// Кнопка из текста
  factory ThesisButton.fromText({
    Key? key,
    required String text,
    required void Function() onPressed,
    ThesisButtonOptions options = const ThesisButtonOptions(),
    bool isDisabled = false,
    bool isLoading = false,
  }) {
    return ThesisButton(
      key: key,
      child: null,
      text: text,
      options: options,
      onPressed: onPressed,
      isDisabled: isDisabled,
    );
  }

  final Widget? child;
  final String? text;
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
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isDisabled || isLoading ? kGray2Color : kPrimaryColor,
            ),
            fixedSize: MaterialStateProperty.all<Size>(
              Size(options.width ?? buttonWidth, options.height),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(options.borderRadius),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          onPressed: isDisabled
              ? null
              : () async {
                  isLoadingNotifier.value = true;
                  onPressed();
                  await Future.delayed(const Duration(seconds: 2)).whenComplete(
                    () => isLoadingNotifier.value = false,
                  );
                },
          child: _ThesisButtonContent(
            child: child,
            text: text,
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        );
      },
    );
  }
}

class _ThesisButtonContent extends StatelessWidget {
  const _ThesisButtonContent({
    this.child,
    this.text,
    required this.isDisabled,
    required this.isLoading,
  });

  final Widget? child;
  final String? text;

  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = context.textTheme.titleLarge!.copyWith(
      color: Colors.white,
    );
    return Container(
      child: isLoading
          ? const ThesisProgressBar(color: kDarkTextPrimaryColor)
          : text != null
              ? Text(
                  text!,
                  style: isDisabled
                      ? defaultTextStyle.copyWith(fontWeight: FontWeight.w600)
                      : defaultTextStyle,
                )
              : child,
    );
  }
}
