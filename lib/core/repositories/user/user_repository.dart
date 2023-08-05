import 'package:shared_preferences/shared_preferences.dart';

/// Интерфейс репозиторий работы с пользователем
abstract class IUserRepository {
  /// Сохранить роль пользователя
  Future<bool> saveRole(int role);

  /// Получить роль пользователя
  Future<int?> getRole();
}

/// Репозиторий работы с пользователем
class UserRepositoryImpl implements IUserRepository {
  static const String _roleKey = '_roleKey';

  @override
  Future<bool> saveRole(int role) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_roleKey, role);
  }

  @override
  Future<int?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_roleKey);
  }
}
