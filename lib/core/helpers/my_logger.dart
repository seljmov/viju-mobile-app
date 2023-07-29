import 'package:logger/logger.dart';

/// Класс кастомного логгера
class MyLogger {
  /// Логгер
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  /// Вывести в консоль debug-сообщение
  static void d(String message) {
    _logger.d(message);
  }

  /// Вывести в консоль error-сообщение
  static void e(String message) {
    _logger.e(message);
  }

  /// Вывести в консоль info-сообщение
  static void i(String message) {
    _logger.i(message);
  }

  /// Вывести в консоль warning-сообщение
  static void w(String message) {
    _logger.w(message);
  }
}
