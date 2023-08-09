import '../../../../core/helpers/dio_helper.dart';
import '../../../../core/helpers/my_logger.dart';
import '../contacts/request_dto/request_dto.dart';

abstract class IRequestRepository {
  Future<List<RequestDto>> getRequests(int status);
}

class RequestRepositoryImpl implements IRequestRepository {
  @override
  Future<List<RequestDto>> getRequests(int status) async {
    try {
      final response = await DioHelper.postData(
        url: '/request',
        data: {
          'statuses': [status]
        },
      );

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => RequestDto.fromJson(e))
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
}
