import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../../theme/theme_colors.dart';
import '../../../../../theme/theme_extention.dart';
import '../../contacts/request_status_dto/request_status_dto.dart';
import '../../contacts/request_statuses.dart';
import '../../widgets/request_state_card.dart';

/// BottomSheep для статусов заявки
class RequestStatusesSheep {
  static Future<void> show(
    BuildContext context, {
    required List<RequestStatusDto> statuses,
  }) async {
    final titleSmallBold = context.textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.bold,
    );
    ThesisBottomSheep.showBarModalAsync(
      context,
      expand: false,
      backgroundColor: const Color(0xFFF2F4FD),
      builder: (context) {
        return SingleChildScrollView(
          physics: kDefaultPhysics,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Text(
                        'Статусы',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 20,
                      ),
                      child: TimelineTheme(
                        data: TimelineThemeData(
                          lineColor: kPrimaryColor,
                          itemGap: 36,
                          strokeCap: StrokeCap.round,
                        ),
                        child: Timeline(
                          indicatorSize: 16,
                          events: List.generate(statuses.length, (index) {
                            final status = statuses[index];
                            final isCanceled = status.status ==
                                RequestStatuses.statusName(
                                    RequestStatuses.Canceled);
                            return TimelineEventDisplay(
                              indicatorOffset: Offset(0, isCanceled ? -10 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RequestStateCard(
                                    statusName: status.status,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    kDateTimeFormatter.format(DateTime.utc(
                                      status.createdTimestamp.year,
                                      status.createdTimestamp.month,
                                      status.createdTimestamp.day,
                                      status.createdTimestamp.hour,
                                      status.createdTimestamp.minute,
                                    ).toLocal()),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Автор: ',
                                          style: context.textTheme.titleSmall,
                                        ),
                                        TextSpan(
                                          text: status.createdUser,
                                          style: titleSmallBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: isCanceled,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Комментарий: ',
                                              style:
                                                  context.textTheme.titleSmall,
                                            ),
                                            TextSpan(
                                              text: status.note ?? '',
                                              style: titleSmallBold.copyWith(
                                                color: kRedColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              indicatorSize: 32,
                              indicator: const DecoratedBox(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          }),
                          altOffset: const Offset(0, -28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
