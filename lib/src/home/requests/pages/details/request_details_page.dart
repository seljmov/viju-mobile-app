import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/helpers/message_helper.dart';
import '../../../../../core/helpers/my_logger.dart';
import '../../../../../core/models/multi_image.dart';
import '../../../../../core/widgets/button/thesis_button.dart';
import '../../../../../core/widgets/images/image_full_screen.dart';
import '../../../../../core/widgets/images/full_screen_images_carousel.dart';
import '../../../../../core/widgets/images/image_helper.dart';
import '../../../../../core/widgets/images/image_selector.dart';
import '../../../../../core/widgets/images/network_image_preview.dart';
import '../../../../../core/widgets/images/thesis_image_grid.dart';
import '../../../../../core/widgets/images/thesis_image_view.dart';
import '../../../../../core/widgets/thesis_sliver_screen.dart';
import '../../../../../theme/theme_colors.dart';
import '../../../../../theme/theme_extention.dart';
import '../../../../welcome/login/contracts/user_roles.dart';
import '../../contacts/driver_photo_dto/driver_photo_dto.dart';
import '../../contacts/request_detailed_dto/request_detailed_dto.dart';
import '../../extensions/datetime_extensions.dart';
import '../../widgets/request_state_card.dart';
import '../put/widgets/image_select_button.dart';
import 'document_widget.dart';
import 'request_statuses_sheep.dart';

/// Страница деталей заявки
class RequestDetailsPage extends StatelessWidget {
  const RequestDetailsPage({
    super.key,
    required this.request,
    required this.role,
  });

  final RequestDetailedDto request;
  final int role;

  @override
  Widget build(BuildContext context) {
    debugPrint('request.documents: ${request.photos}');
    final files = request.photos.map((e) => MultiImage(path: e.url)).toList();
    return ThesisSliverScreen(
      title: 'Заявка №${request.id}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => RequestStatusesSheep.show(
                      context,
                      statuses: request.statuses,
                    ),
                    child: RequestStateCard(
                      statusName: request.statuses.last.status,
                    ),
                  ),
                  Text(
                    request.createdTimestamp.toLocalFormattedString(),
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Visibility(
                visible: request.agreed,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      'Согласовано ЗДС',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Локация',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.location,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Адрес',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.locationAddress,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Контрагент',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                request.contractor,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип вывоза',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.removalType,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип отходов',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.wasteType,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Примерный объем, м³',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.volumeInCubicMeters == null
                          ? '-'
                          : request.volumeToString(request.volumeInCubicMeters),
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Примерный объем, т',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.volumeInTons == null
                          ? '-'
                          : request.volumeToString(request.volumeInTons),
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дата/время вывоза',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.pickupDate.year == 1
                          ? '-'
                          : request.pickupDate.toLocalFormattedString(),
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Электронный талон',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.electronicTicket == null ||
                              request.electronicTicket!.isEmpty
                          ? '-'
                          : request.electronicTicket!,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Машина',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                request.car == null || request.car!.isEmpty
                    ? '-'
                    : request.car!,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Divider(color: kGray2Color),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Автор',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.author,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Телефон',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.formatPhone,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Примечание',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                request.note == null || request.note!.isEmpty
                    ? '-'
                    : request.note!,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Visibility(
            visible: files.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: kGray2Color),
                const SizedBox(height: 30),
                Text(
                  'Фото',
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                ThesisImageGrid(
                  children: List.generate(
                    files.length,
                    (index) => ThesisImageView(
                      image: files[index],
                      size: const Size(100, 100),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return FullScreenImagesCarousel(
                            currentIndex: index,
                            images: files,
                            fromNetwork: true,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: request.documents.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const SizedBox(height: 30),
                const Divider(color: kGray2Color),
                const SizedBox(height: 30),
                Text(
                  'Документы',
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: kDefaultPhysics,
                  child: Row(
                    children: List.generate(
                      request.documents.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              await FlutterWebBrowser.openWebPage(
                                url: request.documents[index].url,
                              );
                            } catch (e) {
                              MyLogger.e('Error: $e');
                              MessageHelper.showError(
                                'Не удалось открыть документ',
                              );
                              rethrow;
                            }
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                              maxHeight: 70,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kGray1Color,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    DocumentWidget(
                                      type: request.documents[index].fileName
                                          .split('.')
                                          .last,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        request.documents[index].documentType,
                                        style: context.textTheme.titleLarge
                                            ?.copyWith(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Visibility(
            visible: request.driver != null,
            child: Builder(builder: (context) {
              final beforePhoto = ValueNotifier<_DriverPhoto>(
                request.driverPhotos.isNotEmpty
                    ? _DriverPhoto(dto: request.driverPhotos.first)
                    : _DriverPhoto(),
              );
              final afterPhoto = ValueNotifier<_DriverPhoto>(
                request.driverPhotos.length > 1
                    ? _DriverPhoto(dto: request.driverPhotos.last)
                    : _DriverPhoto(),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Водитель',
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.driver!,
                    style: context.textTheme.titleLarge,
                  ),
                  Visibility(
                    visible: role == UserRoles.driver ||
                        request.driverPhotos.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Фото до и после',
                            style: context.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DriverPhotoWidget(
                                role: role,
                                photoNotifier: beforePhoto,
                                title: 'До',
                              ),
                              const SizedBox(width: 20),
                              ValueListenableBuilder(
                                valueListenable: beforePhoto,
                                builder: (context, beforeModel, child) =>
                                    _DriverPhotoWidget(
                                  role: role,
                                  photoNotifier: afterPhoto,
                                  title: 'После',
                                  isDisabled: !beforeModel.isUploaded,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: afterPhoto,
                    builder: (context, afterDriverPhoto, child) {
                      return Visibility(
                        visible: role == UserRoles.driver &&
                            !afterDriverPhoto.isUploaded,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ValueListenableBuilder(
                            valueListenable: beforePhoto,
                            builder: (context, beforeDriverPhoto, child) {
                              return ThesisButton.fromText(
                                text: 'Сохранить',
                                isDisabled: beforeDriverPhoto.isEmpty ||
                                    (beforeDriverPhoto.isUploaded &&
                                        afterDriverPhoto.isEmpty),
                                onPressed: () async {
                                  if (!beforeDriverPhoto.isUploaded) {
                                    await _uploadPhoto(request.id, beforePhoto);
                                  } else if (!afterDriverPhoto.isUploaded) {
                                    await _uploadPhoto(request.id, afterPhoto);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Future<void> _uploadPhoto(
    int requestId,
    ValueNotifier<_DriverPhoto> photoNotifier,
  ) async {
    final file = photoNotifier.value.file;
    if (file != null) {
      final path = '/upload-request-photo/$requestId';
      final result = await ImageHelper.register(file, path);

      if (result.isNotEmpty) {
        photoNotifier.value = _DriverPhoto(
          dto: DriverPhotoDto(
            url: result,
            fileName: file.path.split('/').last,
            createdTimestamp: DateTime.now(),
          ),
        );
        MessageHelper.showSuccess('Фото успешно загружено');
      }
    }
  }
}

class _DriverPhotoWidget extends StatelessWidget {
  const _DriverPhotoWidget({
    required this.role,
    required this.title,
    required this.photoNotifier,
    this.isDisabled = false,
  });

  final int role;
  final String title;
  final ValueNotifier<_DriverPhoto> photoNotifier;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: photoNotifier,
      builder: (context, model, child) {
        if (role != UserRoles.driver) {
          return model.isUploaded
              ? _DriverPhotoPreviewWidget(
                  photoDto: model.dto!,
                  title: title,
                )
              : const SizedBox.shrink();
        }

        return model.isUploaded
            ? _DriverPhotoPreviewWidget(photoDto: model.dto!, title: title)
            : _DriverPhotoUploadWidget(
                photoNotifier: photoNotifier,
                title: title,
                isDisabled: isDisabled,
              );
      },
    );
  }
}

class _DriverPhotoPreviewWidget extends StatelessWidget {
  const _DriverPhotoPreviewWidget({
    required this.photoDto,
    required this.title,
  });

  final DriverPhotoDto photoDto;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ImageFullScreen(
              image: MultiImage(path: photoDto.url),
            );
          }),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            height: 125,
            child: NetworkImagePreview(
              imageUrl: photoDto.url,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: context.textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              photoDto.createdTimestamp.toLocalFormattedString(),
              style: context.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverPhotoUploadWidget extends StatelessWidget {
  const _DriverPhotoUploadWidget({
    required this.photoNotifier,
    required this.title,
    this.isDisabled = false,
  });

  final ValueNotifier<_DriverPhoto> photoNotifier;
  final String title;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: photoNotifier,
      builder: (context, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                if (isDisabled) {
                  MessageHelper.showError(
                    'Недоступно для загрузки! Сначала загрузите фото до.',
                  );
                  return;
                }

                if (model.file != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ImageFullScreen(
                        image: MultiImage(file: model.file),
                      );
                    }),
                  );
                  return;
                }

                final pickFile =
                    await ImageSeletorHelper.pickImageFromGallery();
                if (pickFile != null) {
                  photoNotifier.value = _DriverPhoto(file: pickFile);
                }
              },
              child: SizedBox(
                width: 125,
                height: 125,
                child: Builder(builder: (context) {
                  return model.file == null
                      ? ImageSelectWidget(
                          size: const Size(125, 125),
                          isDisabled: isDisabled,
                        )
                      : ThesisImageView(
                          image: MultiImage(file: model.file),
                          size: const Size(125, 125),
                          onRemove: () {
                            photoNotifier.value = _DriverPhoto();
                          });
                }),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: context.textTheme.titleLarge,
            ),
          ],
        );
      },
    );
  }
}

class _DriverPhoto {
  final File? file;
  final DriverPhotoDto? dto;

  _DriverPhoto({
    this.file,
    this.dto,
  });

  bool get isUploaded => dto != null;
  bool get isEmpty => file == null && dto == null;

  void set file(File? value) => file = value;
}
