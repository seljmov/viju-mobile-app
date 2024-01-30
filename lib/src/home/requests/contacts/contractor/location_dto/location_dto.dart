import 'package:freezed_annotation/freezed_annotation.dart';

import '../address_dto/address_dto.dart';

part 'location_dto.freezed.dart';
part 'location_dto.g.dart';

@freezed
class LocationDto with _$LocationDto {
  const factory LocationDto({
    required int id,
    required String name,
    required List<AddressDto> addresses,
  }) = _LocationDto;

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);
}
