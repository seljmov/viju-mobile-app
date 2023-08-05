import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/helpers/my_logger.dart';
import '../../../../core/repositories/tokens/tokens_repository.dart';
import '../../../../core/repositories/tokens/tokens_repository_impl.dart';

/// Интерфейс репозиторий авторизации
abstract class IAuthRepository {
  /// Проверить авторизованность пользователя
  Future<bool> userHasBeenLoggedIn();

  /// Проверить первый ли это запуск приложения
  Future<bool> checkIsLoginAndFirstRun();
}

/// Репозиторий авторизации
class AuthRepositoryImpl implements IAuthRepository {
  final TokensRepository _tokensRepository = TokensRepositoryImpl();

  @override
  Future<bool> userHasBeenLoggedIn() async {
    // Достаточно проверить наличие одного токена
    final token = await _tokensRepository.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> checkIsLoginAndFirstRun() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('first_run') ?? true) {
        //await _userRepository.removeAllInfoFromDevice();
        await prefs.setBool('first_run', false);
      }
      return await userHasBeenLoggedIn();
    } catch (e) {
      MyLogger.e("AuthRepository -> isFirstRun() -> e -> $e");
      rethrow;
    }
  }
}
