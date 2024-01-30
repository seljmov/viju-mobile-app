import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extension/formatted_message.dart';
import '../helpers/dio_helper.dart';
import '../helpers/my_logger.dart';
import '../repositories/tokens/tokens_repository_impl.dart';

/// Глобальный обработчик действий блока
class BlocGlobalObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  Future<void> onError(
    BlocBase bloc,
    Object error,
    StackTrace stackTrace,
  ) async {
    MyLogger.e('${bloc.runtimeType} $error $stackTrace');
    if (!kDebugMode) {
      try {
        final tokensRepository = TokensRepositoryImpl();
        final accessToken = await tokensRepository.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          final data = {
            'accessToken': accessToken,
            'text': '${bloc.runtimeType} -> $error',
            'stackTrace': stackTrace.toString(),
          };
          await DioHelper.postData(
            url: '/error',
            data: data,
          ).whenComplete(
            () => MyLogger.i('Информация об ошибке была отправлена'),
          );
        }
      } on Exception catch (e) {
        MyLogger.e('DioHelper.postData -> ${e.getMessage}');
      }
    }
    super.onError(bloc, error, stackTrace);
  }
}
