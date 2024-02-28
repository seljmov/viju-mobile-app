import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_photo_dto.freezed.dart';
part 'driver_photo_dto.g.dart';

/// Модель данных фотографии водителя
@freezed
class DriverPhotoDto with _$DriverPhotoDto {
  const factory DriverPhotoDto({
    required String fileName,
    required String url,
    required DateTime createdTimestamp,
  }) = _DriverPhotoDto;

  factory DriverPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$DriverPhotoDtoFromJson(json);
}
