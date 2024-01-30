import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_status_dto.freezed.dart';
part 'request_status_dto.g.dart';

@freezed
class RequestStatusDto with _$RequestStatusDto {
  const factory RequestStatusDto({
    required int id,
    required String status,
    required String? note,
    required DateTime createdTimestamp,
    required String createdUser,
  }) = _RequestStatusDto;

  factory RequestStatusDto.fromJson(Map<String, dynamic> json) =>
      _$RequestStatusDtoFromJson(json);
}
