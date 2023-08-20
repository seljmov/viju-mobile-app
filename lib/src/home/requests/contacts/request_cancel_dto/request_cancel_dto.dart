import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_cancel_dto.freezed.dart';
part 'request_cancel_dto.g.dart';

@freezed
class RequestCancelDto with _$RequestCancelDto {
  const factory RequestCancelDto({
    required int id,
    required String note,
  }) = _RequestCancelDto;

  factory RequestCancelDto.fromJson(Map<String, dynamic> json) =>
      _$RequestCancelDtoFromJson(json);
}
