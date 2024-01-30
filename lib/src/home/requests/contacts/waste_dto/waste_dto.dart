import 'package:freezed_annotation/freezed_annotation.dart';

part 'waste_dto.freezed.dart';
part 'waste_dto.g.dart';

/// Тип отхода
@freezed
class WasteDto with _$WasteDto {
  const factory WasteDto({
    required int id,
    required String name,
  }) = _WasteDto;

  factory WasteDto.fromJson(Map<String, dynamic> json) =>
      _$WasteDtoFromJson(json);
}
