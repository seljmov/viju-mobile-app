import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_document_dto.freezed.dart';
part 'request_document_dto.g.dart';

@freezed
class RequestDocumentDto with _$RequestDocumentDto {
  const factory RequestDocumentDto({
    required String id,
    required String documentType,
    required String fileName,
    required String url,
    required DateTime createdTimestamp,
    required String createdUser,
  }) = _RequestDocumentDto;

  factory RequestDocumentDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDocumentDtoFromJson(json);
}
