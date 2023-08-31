import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/widgets/images/image_helper.dart';
import '../contacts/request_cancel_dto/request_cancel_dto.dart';
import '../contacts/request_create_dto/request_create_dto.dart';
import '../contacts/request_dto/request_dto.dart';
import '../repositories/request_repository.dart';

class RequestDataProvider with ChangeNotifier {
  RequestDataProvider(
    List<int> initialStatuses, {
    required this.requestRepository,
  }) {
    _currentStatuses = initialStatuses;
    _requestsStream = requestRepository
        .getRequests(_currentStatuses)
        .asStream()
        .asBroadcastStream();
  }

  final IRequestRepository requestRepository;
  late Stream<List<RequestDto>> _requestsStream;
  late List<int> _currentStatuses;

  Stream<List<RequestDto>> get requestsStream => _requestsStream;
  List<int> get currentStatuses => _currentStatuses;

  void loadRequests(List<int> statuses) async {
    _currentStatuses = statuses;
    _requestsStream = requestRepository
        .getRequests(_currentStatuses)
        .asStream()
        .asBroadcastStream();
    notifyListeners();
  }

  void refreshRequests() async {
    _requestsStream = requestRepository
        .getRequests(_currentStatuses)
        .asStream()
        .asBroadcastStream();
    notifyListeners();
  }

  Future<void> cancelRequest(RequestCancelDto cancelDto) async {
    await requestRepository.cancelRequest(cancelDto);
  }

  Future<bool> createRequest(
    RequestCreateDto createDto,
    List<File?> images,
  ) async {
    try {
      final result = await requestRepository.createRequest(createDto);
      if (result == null) return false;

      if (images.isNotEmpty) {
        final path = 'requests/$result/upload-photo';
        final futures = images.map((image) {
          if (image == null) return Future.value();
          return ImageHelper.register(image, path);
        });
        Future.wait(futures);
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loadRequestSources() async {
    final futures = await Future.wait([
      requestRepository.getContractors(),
      requestRepository.getWastes(),
      requestRepository.getRemovals(),
    ]);

    return {
      'contractors': futures[0],
      'wastes': futures[1],
      'removals': futures[2],
    };
  }
}
