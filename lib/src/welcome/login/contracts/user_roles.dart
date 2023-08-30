/// Роли пользователей
abstract class UserRoles {
  /// Сотрудник (2)
  static const int employee = 2;

  /// Заказчик (4)
  static const int customer = 4;

  static List<int> get allowed => [employee, customer];
}
