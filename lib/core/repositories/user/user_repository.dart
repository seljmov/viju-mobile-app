import 'package:shared_preferences/shared_preferences.dart';

/// Интерфейс репозиторий работы с пользователем
abstract class IUserRepository {
  /// Сохранить роль пользователя
  Future<bool> saveRole(int role);

  /// Получить роль пользователя
  Future<int?> getRole();

  /// Установить флаг использования dev API
  Future<bool> setUserUsingDevApi(bool value);

  /// Получить флаг использования dev API
  Future<bool> getUserIsUsingDevApi();
}

/// Репозиторий работы с пользователем
class UserRepositoryImpl implements IUserRepository {
  static const String _roleKey = '_roleKey';
  static const String _apiAddress = '_apiAddress';

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

  @override
  Future<bool> setUserUsingDevApi(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_apiAddress, value);
  }

  @override
  Future<bool> getUserIsUsingDevApi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_apiAddress) ?? false;
  }
}
