import 'package:shared_preferences/shared_preferences.dart';

abstract class IUserRepository {
  Future<bool> saveRole(int role);
  Future<int?> getRole();
}

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
