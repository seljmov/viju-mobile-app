import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Компонент нижнего модального окна
class ThesisBottomSheep {
  static Future<void> showBarModalAsync(
    BuildContext context, {
    required Widget Function(BuildContext context) builder,
    bool expand = false,
    Color backgroundColor = Colors.white,
  }) async {
    await showBarModalBottomSheet(
      context: context,
      expand: expand,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }

  static void showBarModal(
    BuildContext context, {
    required Widget Function(BuildContext context) builder,
    bool expand = false,
    Color backgroundColor = Colors.white,
  }) {
    showBarModalBottomSheet(
      context: context,
      expand: expand,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }
}
