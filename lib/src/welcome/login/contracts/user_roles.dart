/// Роли пользователей
abstract class UserRoles {
  /// Сотрудник (2)
  static const int employee = 2;

  /// Заказчик (4)
  static const int customer = 4;

  /// Сотрудник (7)
  static const int driver = 7;

  /// Роли с доступом
  static List<int> get allowed => [employee, customer, driver];
}
