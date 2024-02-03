import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/formatted_message.dart';
import '../../../../core/helpers/env_helper.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/repositories/tokens/tokens_repository.dart';
import '../../../../core/repositories/user/user_repository.dart';
import '../contracts/login_start_dto/login_start_dto.dart';
import '../contracts/user_roles.dart';
import '../repositories/login_repository.dart';

part 'login_bloc.freezed.dart';

/// Блок аутентификации
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TokensRepository _tokensRepository;
  final ILoginRepository _loginRepository;
  final IUserRepository _userRepository;

  LoginBloc({
    required LoginState initialState,
    required TokensRepository tokensRepository,
    required ILoginRepository loginRepository,
    required IUserRepository userRepository,
  })  : _tokensRepository = tokensRepository,
        _loginRepository = loginRepository,
        _userRepository = userRepository,
        super(initialState) {
    on<LoginEvent>(
      (event, emit) => event.map(
        login: (event) => _login(event, emit),
      ),
    );
  }

  Future<void> _login(_LoginStartEvent event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginState.loading());

      var loginDto = event.startDto;
      if (event.startDto.userName.startsWith('_')) {
        EnvHelper.mainApiUrl = EnvHelper.devApiUrl ?? '';
        loginDto = loginDto.copyWith(
          userName: loginDto.userName.substring(1),
        );
      } else {
        EnvHelper.mainApiUrl = EnvHelper.productionApiUrl ?? '';
      }

      await _userRepository.setUserUsingDevApi(
        event.startDto.userName.startsWith('_'),
      );

      MyLogger.i(event.startDto.userName.startsWith('_')
          ? 'Используется dev api'
          : 'Используется production api');

      final tokens = await _loginRepository.startLogin(loginDto);
      if (!UserRoles.allowed.contains(tokens.role)) {
        emit(const LoginState.errorLogin(
          message: 'Ошибка в логине/пароле или отсуствуют права доступа',
        ));
        return;
      }

      await _tokensRepository.saveTokens(
        tokens.accessToken,
        tokens.refreshToken,
      );
      await _userRepository.saveRole(tokens.role);
      emit(LoginState.successLogin(role: tokens.role));
    } on Exception catch (e) {
      emit(LoginState.errorLogin(message: e.getMessage));
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }
}

/// События авторизации
@freezed
abstract class LoginEvent with _$LoginEvent {
  /// Событие начала авторизации
  const factory LoginEvent.login({
    required LoginStartDto startDto,
  }) = _LoginStartEvent;
}

/// Состояния авторизации
@freezed
abstract class LoginState with _$LoginState {
  /// Состояние инициализации
  const factory LoginState.initial() = _LoginInitialState;

  /// Состояние загрузки
  const factory LoginState.loading() = _LoginLoadingState;

  /// Состояние успешной авторизации
  const factory LoginState.successLogin({
    required int role,
  }) = _LoginSuccessState;

  /// Состояние ошибки авторизации
  const factory LoginState.errorLogin({
    required String message,
  }) = _LoginErrorState;
}
