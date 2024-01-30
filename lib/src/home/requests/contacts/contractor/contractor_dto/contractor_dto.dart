import 'package:freezed_annotation/freezed_annotation.dart';

import '../location_dto/location_dto.dart';

part 'contractor_dto.freezed.dart';
part 'contractor_dto.g.dart';

@freezed
class ContractorDto with _$ContractorDto {
  const factory ContractorDto({
    required int id,
    required String name,
    required List<LocationDto> locations,
  }) = _ContractorDto;

  factory ContractorDto.fromJson(Map<String, dynamic> json) =>
      _$ContractorDtoFromJson(json);
}
