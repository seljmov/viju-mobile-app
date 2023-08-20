import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/formatted_message.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/widgets/images/image_helper.dart';
import '../contacts/contractor/contractor_dto/contractor_dto.dart';
import '../contacts/removal_dto/removal_dto.dart';
import '../contacts/request_cancel_dto/request_cancel_dto.dart';
import '../contacts/request_create_dto/request_create_dto.dart';
import '../contacts/request_dto/request_dto.dart';
import '../contacts/request_statuses.dart';
import '../contacts/waste_dto/waste_dto.dart';
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
        openAddRequestPage: (event) => _openAddRequestPage(event, emit),
        createRequest: (event) => _createRequest(event, emit),
        cancelRequest: (event) => _cancelRequest(event, emit),
      ),
    );
  }

  Future<void> _load(
      _RequestLoadEvent event, Emitter<RequestState> emit) async {
    try {
      emit(const RequestState.loading());
      final requests = await _requestRepository.getRequests(event.status);
      emit(RequestState.loaded(status: event.status, requests: requests));
    } on Exception catch (e) {
      emit(RequestState.error(message: e.getMessage));
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }

  Future<void> _openAddRequestPage(
      _RequestOpenAddRequestPageEvent event, Emitter<RequestState> emit) async {
    try {
      emit(const RequestState.loading());
      final contractors = <ContractorDto>[];
      await _requestRepository.getContractors().then((result) {
        for (final contractor in result) {
          if (contractor.locations.isEmpty) continue;
          if (!contractor.locations.any(
            (location) => location.addresses.isNotEmpty,
          )) continue;
          contractors.add(contractor.copyWith(
            locations: contractor.locations
                .where((location) => location.addresses.isNotEmpty)
                .toList(),
          ));
        }
      });
      final wastes = await _requestRepository.getWastes();
      final removals = await _requestRepository.getRemovals();
      emit(RequestState.openedAddRequestPage(
        contractors: contractors,
        wastes: wastes,
        removals: removals,
      ));
    } on Exception catch (e) {
      emit(RequestState.error(message: e.getMessage));
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }

  Future<void> _createRequest(
      _RequestCreateRequestEvent event, Emitter<RequestState> emit) async {
    try {
      emit(const RequestState.loading());
      final result = await _requestRepository.createRequest(event.createDto);
      if (result != null) {
        if (event.images.isNotEmpty) {
          final path = 'requests/$result/upload-photo';
          final futures = event.images.map((image) {
            if (image == null) return Future.value();
            return ImageHelper.register(image, path);
          });
          Future.wait(futures);
        }
        emit(const RequestState.initial());
      } else {
        emit(
          const RequestState.error(
            message: 'Что-то пошло не так... Попробуйте снова.',
          ),
        );
      }
    } on Exception catch (e) {
      emit(RequestState.error(message: e.getMessage));
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }

  Future<void> _cancelRequest(
      _RequestCancelRequestEvent event, Emitter<RequestState> emit) async {
    try {
      final result = await _requestRepository.cancelRequest(event.cancelDto);
      if (result) {
        this.add(const RequestEvent.load(status: RequestStatuses.New));
        emit(const RequestState.initial());
      } else {
        emit(
          const RequestState.error(
            message: 'Что-то пошло не так... Попробуйте снова.',
          ),
        );
      }
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
  /// Событие загрузки страницы заявок
  const factory RequestEvent.load({
    required int status,
  }) = _RequestLoadEvent;

  /// Событие открытия страницы добавления заявки
  const factory RequestEvent.openAddRequestPage() =
      _RequestOpenAddRequestPageEvent;

  /// Событие создания заявки
  const factory RequestEvent.createRequest({
    required RequestCreateDto createDto,
    required List<File?> images,
  }) = _RequestCreateRequestEvent;

  /// Событие отмены заявки
  const factory RequestEvent.cancelRequest({
    required RequestCancelDto cancelDto,
  }) = _RequestCancelRequestEvent;
}

/// Состояния заявок
@freezed
abstract class RequestState with _$RequestState {
  /// Состояние инициализации
  const factory RequestState.initial() = _RequestInitialState;

  /// Состояние загрузки
  const factory RequestState.loading() = _RequestLoadingState;

  /// Состояние успешной загрузки
  const factory RequestState.loaded({
    required int status,
    required List<RequestDto> requests,
  }) = _RequestLoadedState;

  /// Состояние успешного открытия страницы добавления заявки
  const factory RequestState.openedAddRequestPage({
    required List<ContractorDto> contractors,
    required List<WasteDto> wastes,
    required List<RemovalDto> removals,
  }) = _RequestOpenedAddRequestPageState;

  /// Состояние ошибки
  const factory RequestState.error({
    required String message,
  }) = _RequestErrorState;
}
