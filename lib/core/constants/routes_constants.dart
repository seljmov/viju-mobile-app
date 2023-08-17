import 'package:flutter/material.dart';

import '../../main.dart';
import '../../src/home/home_page.dart';
import '../../src/home/requests/contacts/contractor/contractor_dto/contractor_dto.dart';
import '../../src/home/requests/contacts/removal_dto/removal_dto.dart';
import '../../src/home/requests/contacts/waste_dto/waste_dto.dart';
import '../../src/home/requests/pages/add/request_add_page.dart';
import '../../src/welcome/login/login_page.dart';
import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';
import '../splash_screen.dart';

/// Коллекция роутов приложения
abstract class AppRoutes {
  static const String start = '/';
  static const String loading = '/loading';
  static const String login = '/login';
  static const String home = '/home';
  static const String addRequest = '/addRequest';

  /// Сгенерировать роут
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case start:
          return MaterialPageRoute(builder: (_) => const AppRunner());
        case loading:
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        case login:
          return MaterialPageRoute(builder: (_) => const LoginPage());
        case home:
          return MaterialPageRoute(builder: (_) => const HomePage());
        case addRequest:
          if (settings.arguments == null) {
            MessageHelper.showError(
              'Произошла ошибка при попытке открыть страницу добавления заявки',
            );
            return null;
          }
          final arguments = settings.arguments as Map<String, dynamic>;
          final contractors = arguments['contractors'] as List<ContractorDto>;
          final wastes = arguments['wastes'] as List<WasteDto>;
          final removals = arguments['removals'] as List<RemovalDto>;
          return MaterialPageRoute(
            builder: (_) => RequestAddPage(
              contractors: contractors,
              wastes: wastes,
              removals: removals,
            ),
          );
        default:
          return null;
      }
    } on Exception catch (e) {
      MessageHelper.showError(e.getMessage);
      return null;
    }
  }
}
