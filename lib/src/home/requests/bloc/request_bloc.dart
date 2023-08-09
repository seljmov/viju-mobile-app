import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/formatted_message.dart';
import '../../../../core/helpers/my_logger.dart';
import '../contacts/request_dto/request_dto.dart';
import '../repositories/request_repository.dart';

part 'request_bloc.freezed.dart';

/// Блок заявок
class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final IRequestRepository _requestRepository;

  RequestBloc({
    required RequestState initialState,
    required IRequestRepository requestRepository,
  })  : _requestRepository = requestRepository,
        super(initialState) {
    on<RequestEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
      ),
    );
  }

  Future<void> _load(
      _RequestLoadEvent event, Emitter<RequestState> emit) async {
    try {
      emit(const RequestState.loading());
      final requests = await _requestRepository.getRequests(event.status);
      emit(requests.isEmpty
          ? RequestState.empty(status: event.status)
          : RequestState.loaded(status: event.status, requests: requests));
    } on Exception catch (e) {
      emit(RequestState.error(message: e.getMessage));
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }
}

/// События заявок
@freezed
abstract class RequestEvent with _$RequestEvent {
  /// Событие начала авторизации
  const factory RequestEvent.load({
    required int status,
  }) = _RequestLoadEvent;
}

/// Состояния заявок
@freezed
abstract class RequestState with _$RequestState {
  /// Состояние инициализации
  const factory RequestState.initial() = _RequestInitialState;

  /// Состояние загрузки
  const factory RequestState.loading() = _RequestLoadingState;

  /// Состояние загрузки
  const factory RequestState.empty({
    required int status,
  }) = _RequestEmptyState;

  /// Состояние успешной загрузки
  const factory RequestState.loaded({
    required int status,
    required List<RequestDto> requests,
  }) = _RequestLoadedState;

  /// Состояние ошибки
  const factory RequestState.error({
    required String message,
  }) = _RequestErrorState;
}
