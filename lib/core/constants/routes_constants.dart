import 'package:flutter/material.dart';

import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';

/// Коллекция роутов приложения
abstract class ThesisRoutes {
  static const String start = '/';
  static const String welcome = '/welcome';
  static const String navbar = '/navbar';

  /// Сгенерировать роут
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        default:
          return null;
      }
    } on Exception catch (e) {
      MessageHelper.showError(e.getMessage);
      return null;
    }
  }
}
