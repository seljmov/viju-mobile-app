import 'package:freezed_annotation/freezed_annotation.dart';

part 'removal_dto.freezed.dart';
part 'removal_dto.g.dart';

/// Тип вывоза
@freezed
class RemovalDto with _$RemovalDto {
  const factory RemovalDto({
    required int id,
    required String name,
  }) = _RemovalDto;

  factory RemovalDto.fromJson(Map<String, dynamic> json) =>
      _$RemovalDtoFromJson(json);
}
