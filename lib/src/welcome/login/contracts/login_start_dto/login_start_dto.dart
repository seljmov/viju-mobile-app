import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_start_dto.freezed.dart';
part 'login_start_dto.g.dart';

/// Модель для начала аутентификации
@freezed
class LoginStartDto with _$LoginStartDto {
  const factory LoginStartDto({
    required String userName,
    required String password,
  }) = _LoginStartDto;

  factory LoginStartDto.fromJson(Map<String, dynamic> json) =>
      _$LoginStartDtoFromJson(json);
}
