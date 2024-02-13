import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_dto.freezed.dart';
part 'request_dto.g.dart';

@freezed
class RequestDto with _$RequestDto {
  const RequestDto._();

  const factory RequestDto({
    required int id,
    required String status,
    required String location,
    required String locationAddress,
    required String removalType,
    required String wasteType,
    required double? volumeInCubicMeters,
    required double? volumeInTons,
    required String? note,
    required DateTime createdTimestamp,
    required bool agreed,
  }) = _RequestDto;

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

  String volumeToString(double? volume) {
    if (volume == null) return '';

    return volume.toString().replaceAll('.0', '');
  }

  factory RequestDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDtoFromJson(json);
}
