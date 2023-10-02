import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/helpers/message_helper.dart';
import '../../../../../core/helpers/my_logger.dart';
import '../../../../../core/models/multi_image.dart';
import '../../../../../core/widgets/images/full_screen_images_carousel.dart';
import '../../../../../core/widgets/images/thesis_image_grid.dart';
import '../../../../../core/widgets/images/thesis_image_view.dart';
import '../../../../../core/widgets/thesis_sliver_screen.dart';
import '../../../../../theme/theme_colors.dart';
import '../../../../../theme/theme_extention.dart';
import '../../contacts/request_detailed_dto/request_detailed_dto.dart';
import '../../widgets/request_state_card.dart';
import 'document_widget.dart';
import 'request_statuses_sheep.dart';

class RequestDetailsPage extends StatelessWidget {
  const RequestDetailsPage({
    super.key,
    required this.request,
  });

  final RequestDetailedDto request;

  @override
  Widget build(BuildContext context) {
    debugPrint('request.documents: ${request.photos}');
    final files = request.photos.map((e) => MultiImage(path: e.url)).toList();
    return ThesisSliverScreen(
      title: 'Заявка №${request.id}',
      child: Column(
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
                kDateTimeFormatter.format(DateTime.utc(
                  request.createdTimestamp.year,
                  request.createdTimestamp.month,
                  request.createdTimestamp.day,
                  request.createdTimestamp.hour,
                  request.createdTimestamp.minute,
                ).toLocal()),
                style: context.textTheme.titleSmall,
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
                          : kDateTimeFormatter.format(DateTime.utc(
                              request.pickupDate.year,
                              request.pickupDate.month,
                              request.pickupDate.day,
                              request.pickupDate.hour,
                              request.pickupDate.minute,
                            ).toLocal()),
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
              ],
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
