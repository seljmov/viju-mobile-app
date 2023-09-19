import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/contracts/photo_dto/photo_dto.dart';
import '../request_document_dto/request_document_dto.dart';
import '../request_status_dto/request_status_dto.dart';

part 'request_detailed_dto.freezed.dart';
part 'request_detailed_dto.g.dart';

@freezed
class RequestDetailedDto with _$RequestDetailedDto {
  const RequestDetailedDto._();

  const factory RequestDetailedDto({
    required int id,
    required String location,
    required String locationAddress,
    required String contractor,
    required String removalType,
    required String wasteType,
    required double? volumeInCubicMeters,
    required double? volumeInTons,
    required String? note,
    required String? status,
    required DateTime pickupDate,
    required DateTime createdTimestamp,
    required String? electronicTicket,
    required String? car,
    required String? idleRun,
    required String author,
    required String? phone,
    required List<PhotoDto> photos,
    required List<RequestStatusDto> statuses,
    required List<RequestDocumentDto> documents,
  }) = _RequestDetailedDto;

  String get volume {
    var volume = '';
    if (volumeInCubicMeters != null) {
      volume += '${volumeToString(volumeInCubicMeters)} м³';
    }
    if (volumeInTons != null) {
      if (volume.isNotEmpty) {
        volume += '/';
      }
      volume += '${volumeToString(volumeInTons)} т';
    }
    return volume;
  }

  String get formatPhone {
    if (this.phone == null || this.phone!.isEmpty) return '-';
    final phone =
        '+7 ${this.phone!.substring(0, 3)} ${this.phone!.substring(3, 6)} ${this.phone!.substring(6, 8)} ${this.phone!.substring(8, 10)}';
    return phone;
  }

  String volumeToString(double? volume) {
    if (volume == null) return '';

    return volume.toString().replaceAll('.0', '');
  }

  /// Возвращает последний статус заявки
  RequestStatusDto get lastStatus {
    statuses.sort((a, b) => b.createdTimestamp.compareTo(a.createdTimestamp));
    return statuses.last;
  }

  factory RequestDetailedDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDetailedDtoFromJson(json);
}
