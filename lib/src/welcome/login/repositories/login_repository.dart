import '../../../../core/helpers/dio_helper.dart';
import '../../../../core/helpers/my_logger.dart';
import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/login_start_dto/login_start_dto.dart';

abstract class ILoginRepository {
  Future<LoginCompleteDto> startLogin(LoginStartDto startDto);
}

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
          throw Exception('Введен неверный пароль. Попробуйте снова.');
        case 404:
          throw Exception('Пользователь не найден или отключен.');
        default:
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      MyLogger.e("LoginRepository -> startLogin() -> e -> $e");
      rethrow;
    }
  }
}
