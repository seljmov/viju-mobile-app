/// Статусы заявок
abstract class RequestStatuses {
  static const int New = 1;
  static const int Agreed = 2;
  static const int InProgress = 3;
  static const int Executed = 4;
  static const int Completed = 5;
  static const int Canceled = 6;

  static const int count = 6;

  static Map<int, String> get toDictionary => {
        New: statusName(New),
        Agreed: statusName(Agreed),
        InProgress: statusName(InProgress),
        Executed: statusName(Executed),
        Completed: statusName(Completed),
        Canceled: statusName(Canceled),
      };

  static List<String> get names => [
        statusName(New),
        statusName(Agreed),
        statusName(InProgress),
        statusName(Executed),
        statusName(Completed),
        statusName(Canceled),
      ];

  /// Возвращает название статуса по его коду
  static String statusName(int status) => switch (status) {
        New => 'Новая',
        Agreed => 'Согласована',
        InProgress => 'В работе',
        Executed => 'Выполнена',
        Completed => 'Завершена',
        Canceled => 'Отменена',
        _ => throw const FormatException('Неизвестный статус заявки!')
      };
}
