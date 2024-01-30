import 'package:flutter/material.dart';

/// Статусы заявок
abstract class RequestStatuses {
  static const int New = 1;
  static const int Agreed = 2;
  static const int InProgress = 3;
  static const int Executed = 4;
  static const int Completed = 5;
  static const int Canceled = 6;

  static const int count = 6;

  static Map<int, List<int>> get relatedStatuses => {
        New: [New],
        InProgress: [Agreed, InProgress],
        Completed: [Executed, Completed, Canceled],
      };

  static Map<int, String> get statuses => {
        New: 'Новые',
        InProgress: statusName(InProgress),
        Completed: 'Завершены',
      };

  /// Возвращает название статуса по его коду
  static String statusName(int status) => switch (status) {
        New => 'Новая',
        Agreed => 'Согласована',
        InProgress => 'В работе',
        Executed => 'Выполнена',
        Completed => 'Завершена',
        Canceled => 'Отменена',
        _ => throw const FormatException('Неизвестный статус заявки!'),
      };

  static Map<String, Color> get getStatusColor => {
        statusName(New): const Color(0xFFCDCFD9),
        statusName(Agreed): const Color(0xFFE88F10),
        statusName(InProgress): const Color(0xFF10C6F0),
        statusName(Executed): const Color(0xFF3C85B7),
        statusName(Completed): const Color(0xFF10B050),
        statusName(Canceled): const Color(0xFFCC3330),
      };
}
