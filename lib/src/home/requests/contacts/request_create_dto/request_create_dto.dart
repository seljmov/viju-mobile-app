import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_create_dto.freezed.dart';
part 'request_create_dto.g.dart';

@freezed
class RequestCreateDto with _$RequestCreateDto {
  const factory RequestCreateDto({
    required int contractorId,
    required int locationAddressId,
    required int removalTypeId,
    required int wasteTypeId,
    required double? approximateVolumeInCubicMeters,
    required double? approximateVolumeInTons,
    required String? note,
  }) = _RequestCreateDto;

  factory RequestCreateDto.fromJson(Map<String, dynamic> json) =>
      _$RequestCreateDtoFromJson(json);
}
