import '../../../../core/helpers/dio_helper.dart';
import '../../../../core/helpers/my_logger.dart';
import '../contacts/contractor/contractor_dto/contractor_dto.dart';
import '../contacts/removal_dto/removal_dto.dart';
import '../contacts/request_cancel_dto/request_cancel_dto.dart';
import '../contacts/request_create_dto/request_create_dto.dart';
import '../contacts/request_detailed_dto/request_detailed_dto.dart';
import '../contacts/request_dto/request_dto.dart';
import '../contacts/request_edit_dto/request_edit_dto.dart';
import '../contacts/waste_dto/waste_dto.dart';

abstract class IRequestRepository {
  Future<List<RequestDto>> getRequests(List<int> statuses);

  Future<List<ContractorDto>> getContractors();

  Future<List<WasteDto>> getWastes();

  Future<List<RemovalDto>> getRemovals();

  Future<RequestDetailedDto> getDetailedRequest(int id);

  Future<bool> editRequest(RequestEditDto requestEditDto);

  Future<int?> createRequest(RequestCreateDto requestCreateDto);

  Future<bool> cancelRequest(RequestCancelDto requestCancelDto);
}

class RequestRepositoryImpl implements IRequestRepository {
  @override
  Future<List<RequestDto>> getRequests(List<int> statuses) async {
    try {
      final response = await DioHelper.postData(
        url: '/request',
        data: {'statuses': statuses},
      );

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => RequestDto.fromJson(e))
              .toList();
        default:
          MyLogger.e(
            'RequestRepositoryImpl -> getRequests \nЧто-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContractorDto>> getContractors() async {
    try {
      final response = await DioHelper.postData(
        url: '/available-contractor-and-location',
      );

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => ContractorDto.fromJson(e))
              .toList();
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RemovalDto>> getRemovals() async {
    try {
      final response = await DioHelper.postData(
        url: '/removal-type',
      );

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => RemovalDto.fromJson(e))
              .toList();
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WasteDto>> getWastes() async {
    try {
      final response = await DioHelper.postData(
        url: '/waste-type',
      );

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => WasteDto.fromJson(e))
              .where((e) => !e.name.toUpperCase().contains('ТБО'))
              .toList();
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int?> createRequest(RequestCreateDto requestCreateDto) async {
    try {
      final response = await DioHelper.postData(
        url: '/request/create',
        data: requestCreateDto.toJson(),
      );

      switch (response.statusCode) {
        case 200:
          return response.data['id'];
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> cancelRequest(RequestCancelDto requestCancelDto) async {
    try {
      final response = await DioHelper.postData(
        url: '/request/cancel',
        data: requestCancelDto.toJson(),
      );

      switch (response.statusCode) {
        case 200:
          return true;
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RequestDetailedDto> getDetailedRequest(int id) async {
    try {
      final response = await DioHelper.postData(
        url: '/request/details',
        data: {'id': id},
      );

      switch (response.statusCode) {
        case 200:
          return RequestDetailedDto.fromJson(response.data);
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> editRequest(RequestEditDto requestEditDto) async {
    try {
      final response = await DioHelper.postData(
        url: '/request/edit',
        data: requestEditDto.toJson(),
      );

      switch (response.statusCode) {
        case 200:
          return true;
        default:
          MyLogger.e(
            'Что-то пошло не так... Попробуйте снова. code = ${response.statusCode}',
          );
          throw Exception('Что-то пошло не так... Попробуйте снова.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
