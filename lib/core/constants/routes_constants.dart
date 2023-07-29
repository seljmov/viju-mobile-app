import 'package:flutter/material.dart';

import '../../main.dart';
import '../../src/home/home_page.dart';
import '../../src/welcome/login/login_page.dart';
import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';

/// Коллекция роутов приложения
abstract class AppRoutes {
  static const String start = '/';
  static const String login = '/login';
  static const String home = '/home';

  /// Сгенерировать роут
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case start:
          return MaterialPageRoute(builder: (_) => const AppRunner());
        case login:
          return MaterialPageRoute(builder: (_) => const LoginPage());
        case home:
          return MaterialPageRoute(builder: (_) => const HomePage());
        default:
          return null;
      }
    } on Exception catch (e) {
      MessageHelper.showError(e.getMessage);
      return null;
    }
  }
}
