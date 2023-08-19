import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/contracts/photo_dto/photo_dto.dart';
import '../request_document_dto/request_document_dto.dart';
import '../request_status_dto/request_status_dto.dart';

part 'request_dto.freezed.dart';
part 'request_dto.g.dart';

@freezed
class RequestDto with _$RequestDto {
  const RequestDto._();

  const factory RequestDto({
    required int id,
    required String location,
    required String locationAddress,
    required String contractor,
    required String removalType,
    required String wasteType,
    required double? volumeInCubicMeters,
    required double? volumeInTons,
    required String? note,
    required DateTime pickupDate,
    required String? electronicTicket,
    required String? car,
    required String? idleRun,
    required String author,
    required String? phone,
    required List<PhotoDto> photos,
    required List<RequestStatusDto> statuses,
    required List<RequestDocumentDto> documents,
  }) = _RequestDto;

  String get volume {
    var volume = '';
    if (volumeInCubicMeters != null) {
      volume += '$volumeInCubicMeters м³';
    }
    if (volumeInTons != null) {
      if (volume.isNotEmpty) {
        volume += '/';
      }
      volume += '$volumeInTons т';
    }
    return volume;
  }

  /// Возвращает последний статус заявки
  RequestStatusDto get lastStatus {
    statuses.sort((a, b) => b.createdTimestamp.compareTo(a.createdTimestamp));
    return statuses.last;
  }

  factory RequestDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDtoFromJson(json);
}
