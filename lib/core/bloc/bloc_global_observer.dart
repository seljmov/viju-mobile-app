import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extension/formatted_message.dart';
import '../helpers/dio_helper.dart';
import '../helpers/my_logger.dart';

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
    try {
      await DioHelper.postData(
        url: '/error',
        data: {
          "text": error,
          "stackTrace": stackTrace,
        },
      ).whenComplete(() => debugPrint('Информация об ошибке была отправлена'));
    } on Exception catch (e) {
      MyLogger.e('DioHelper.postData -> ${e.getMessage}');
    }
    super.onError(bloc, error, stackTrace);
  }
}
