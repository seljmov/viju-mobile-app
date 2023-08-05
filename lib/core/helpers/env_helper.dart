import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Помощник для работы с переменными окружения
class EnvHelper {
  /// Главный API
  static String? get mainApiUrl => dotenv.env['main_api'];

  /// Установка главного API
  static set mainApiUrl(String? value) => dotenv.env['main_api'] = value ?? '';

  /// API для разработки
  static String? get devApiUrl => dotenv.env['dev_api'];

  /// API для публикации
  static String? get productApiUrl => dotenv.env['product_api'];
}
