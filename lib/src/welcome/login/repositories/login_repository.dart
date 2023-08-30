import '../../../../core/helpers/dio_helper.dart';
import '../../../../core/helpers/my_logger.dart';
import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/login_start_dto/login_start_dto.dart';

/// Интерфейс репозитория аутентификации
abstract class ILoginRepository {
  /// Начать аутентификацию
  Future<LoginCompleteDto> startLogin(LoginStartDto startDto);
}

/// Репозиторий аутентификации
class LoginRepositoryImpl implements ILoginRepository {
  Future<LoginCompleteDto> startLogin(LoginStartDto startDto) async {
    try {
      final response = await DioHelper.postData(
        url: '/auth',
        data: startDto.toJson(),
        useAuthErrorInterceptor: false,
      );

      switch (response.statusCode) {
        case 200:
          return LoginCompleteDto.fromJson(response.data);
        case 400:
          throw Exception('Неверный логин/пароль. Попробуйте снова.');
        case 404:
          throw Exception('Неверный логин/пароль. Попробуйте снова.');
        default:
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      MyLogger.e("LoginRepository -> startLogin() -> e -> $e");
      rethrow;
    }
  }
}
