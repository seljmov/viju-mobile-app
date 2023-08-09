import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/routes_constants.dart';
import '../../../core/extension/formatted_message.dart';
import '../../../core/helpers/my_logger.dart';
import '../../../core/repositories/tokens/tokens_repository.dart';
import 'repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';

/// Блок авторизации
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokensRepository _tokensRepository;
  final IAuthRepository _authRepository;

  AuthBloc({
    required AuthState initialState,
    required TokensRepository tokensRepository,
    required IAuthRepository authRepository,
  })  : _tokensRepository = tokensRepository,
        _authRepository = authRepository,
        super(initialState) {
    on<AuthEvent>(
      (event, emit) => event.map(
        start: (event) => _start(event, emit),
        loggedOut: (event) => _loggedOut(event, emit),
      ),
    );
  }

  Future<void> _start(_AuthStartEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.loading());
      final isLogged = await _authRepository.userHasBeenLoggedIn();
      emit(!isLogged
          ? const AuthState.unauthenticated()
          : const AuthState.authenticated());
    } on Exception catch (e) {
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }

  Future<void> _loggedOut(
      _AuthLoggedOutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.loading());
      await _tokensRepository.deleteTokens();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      navService.pushNamedAndRemoveUntil(AppRoutes.start);
    } on Exception catch (e) {
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }
}

/// События авторизации
@freezed
abstract class AuthEvent with _$AuthEvent {
  /// Событие начала авторизации
  const factory AuthEvent.start() = _AuthStartEvent;

  /// Событие выхода из авторизации
  const factory AuthEvent.loggedOut() = _AuthLoggedOutEvent;
}

/// Состояния авторизации
@freezed
abstract class AuthState with _$AuthState {
  /// Состояние инициализации
  const factory AuthState.initial() = _AuthInitialState;

  /// Состояние загрузки
  const factory AuthState.loading() = _AuthLoadingState;

  /// Состояние авторизованности пользователя
  const factory AuthState.authenticated() = _AuthAuthenticatedState;

  /// Состояние неавторизованности пользователя
  const factory AuthState.unauthenticated() = _AuthUnauthenticatedState;
}
