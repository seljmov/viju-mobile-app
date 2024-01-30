import 'package:flutter/material.dart';

import '../../main.dart';
import '../../src/home/requests/pages/request_page.dart';
import '../../src/home/requests/contacts/contractor/contractor_dto/contractor_dto.dart';
import '../../src/home/requests/contacts/removal_dto/removal_dto.dart';
import '../../src/home/requests/contacts/request_detailed_dto/request_detailed_dto.dart';
import '../../src/home/requests/contacts/waste_dto/waste_dto.dart';
import '../../src/home/requests/pages/details/request_details_page.dart';
import '../../src/home/requests/pages/put/request_put_page.dart';
import '../../src/welcome/login/contracts/user_roles.dart';
import '../../src/welcome/login/login_page.dart';
import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';
import '../splash_screen.dart';

/// Коллекция роутов приложения
abstract class AppRoutes {
  static const String start = '/';
  static const String loading = '/loading';
  static const String login = '/login';
  static const String home = '/requests';
  static const String addRequest = '/requests/add';
  static const String editRequest = '/requests/edit';
  static const String detailsRequest = '/requests/details';

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
          // 4 - заказчик, 2 - сотрудник
          // заказчик не должен создавать заявки
          final role = settings.arguments == null || settings.arguments is! int
              ? UserRoles.employee
              : settings.arguments as int;
          return MaterialPageRoute(builder: (_) => RequestPage(role: role));
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
            builder: (_) => RequestPutPage(
              contractors: contractors,
              wastes: wastes,
              removals: removals,
            ),
          );
        case editRequest:
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
          final request = arguments['request'] as RequestDetailedDto?;
          return MaterialPageRoute(
            builder: (_) => RequestPutPage(
              contractors: contractors,
              wastes: wastes,
              removals: removals,
              request: request,
            ),
          );
        case detailsRequest:
          if (settings.arguments == null) {
            MessageHelper.showError(
              'Произошла ошибка при попытке открыть страницу добавления заявки',
            );
            return null;
          }
          final request = settings.arguments as RequestDetailedDto;
          return MaterialPageRoute(
            builder: (_) => RequestDetailsPage(request: request),
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
