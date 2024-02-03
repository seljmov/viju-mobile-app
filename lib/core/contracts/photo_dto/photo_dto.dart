import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_dto.freezed.dart';
part 'photo_dto.g.dart';

/// Модель данных фотографии
@freezed
class PhotoDto with _$PhotoDto {
  const factory PhotoDto({
    required String fileName,
    required String url,
  }) = _PhotoDto;

  factory PhotoDto.fromJson(Map<String, dynamic> json) =>
      _$PhotoDtoFromJson(json);
}
