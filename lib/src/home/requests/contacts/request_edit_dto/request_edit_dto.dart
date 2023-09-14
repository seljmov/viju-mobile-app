import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_edit_dto.freezed.dart';
part 'request_edit_dto.g.dart';

@freezed
class RequestEditDto with _$RequestEditDto {
  const factory RequestEditDto({
    required int id,
    required int contractorId,
    required int locationAddressId,
    required int removalTypeId,
    required int wasteTypeId,
    required double? approximateVolumeInCubicMeters,
    required double? approximateVolumeInTons,
    required String? note,
  }) = _RequestEditDto;

  factory RequestEditDto.fromJson(Map<String, dynamic> json) =>
      _$RequestEditDtoFromJson(json);
}
