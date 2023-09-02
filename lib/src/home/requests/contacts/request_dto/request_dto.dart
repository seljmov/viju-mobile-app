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

  factory RequestDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDtoFromJson(json);
}
