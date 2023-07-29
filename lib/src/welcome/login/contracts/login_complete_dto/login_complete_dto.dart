import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_complete_dto.freezed.dart';
part 'login_complete_dto.g.dart';

@freezed
class LoginCompleteDto with _$LoginCompleteDto {
  const factory LoginCompleteDto({
    required String accessToken,
    required String refreshToken,
    required int role,
  }) = _LoginCompleteDto;

  factory LoginCompleteDto.fromJson(Map<String, dynamic> json) =>
      _$LoginCompleteDtoFromJson(json);
}
