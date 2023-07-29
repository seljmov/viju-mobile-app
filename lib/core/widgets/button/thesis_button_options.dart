import 'package:flutter/material.dart';

/// Опции кнопки
class ThesisButtonOptions {
  final bool isOutline;
  final double borderRadius;
  final double? width;
  final double height;
  final TextStyle? titleStyle;
  final Color? backgroundColor;

  const ThesisButtonOptions({
    this.isOutline = false,
    this.borderRadius = 16,
    this.width,
    this.height = 56,
    this.titleStyle,
    this.backgroundColor,
  });
}
