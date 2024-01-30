import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/routes_constants.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/button/thesis_outlined_button.dart';
import '../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../../welcome/login/contracts/user_roles.dart';
import '../components/request_data_provider.dart';
import '../contacts/request_cancel_dto/request_cancel_dto.dart';
import '../contacts/request_dto/request_dto.dart';
import '../contacts/request_statuses.dart';
import 'request_state_card.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.role,
  });

  final RequestDto request;
  final int role;

  @override
  Widget build(BuildContext context) {
    final editPageIsOpeningNotifier = ValueNotifier<bool>(false);
    final titleSmallBold = context.textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.bold,
    );
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        editPageIsOpeningNotifier.value = true;
        final provider = context.read<RequestDataProvider>();
        final detailed = await provider.getDetailedRequest(request.id);

        if (role == UserRoles.employee &&
            request.status == RequestStatuses.statusName(RequestStatuses.New)) {
          final args = await provider.loadRequestSources();
          args['request'] = detailed;
          navService
              .pushNamed(AppRoutes.editRequest, args: args)
              .whenComplete(() => editPageIsOpeningNotifier.value = false);
        } else {
          navService
              .pushNamed(AppRoutes.detailsRequest, args: detailed)
              .whenComplete(() => editPageIsOpeningNotifier.value = false);
        }
      },
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Заявка №${request.id}',
                    style: context.textTheme.headlineSmall,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      RequestStateCard(statusName: request.status),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Локация: ',
                              style: context.textTheme.titleSmall,
                            ),
                            TextSpan(
                              text: request.location,
                              style: titleSmallBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Адрес: ',
                              style: context.textTheme.titleSmall,
                            ),
                            TextSpan(
                              text: request.locationAddress,
                              style: titleSmallBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Visibility(
                        visible: request.volume.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Примерный объем: ',
                                  style: context.textTheme.titleSmall,
                                ),
                                TextSpan(
                                  text: request.volume,
                                  style: titleSmallBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Тип вывоза: ',
                              style: context.textTheme.titleSmall,
                            ),
                            TextSpan(
                              text: request.removalType,
                              style: titleSmallBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Тип мусора: ',
                              style: context.textTheme.titleSmall,
                            ),
                            TextSpan(
                              text: request.wasteType,
                              style: titleSmallBold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: editPageIsOpeningNotifier,
                    builder: (context, isOpening, child) {
                      return Visibility(
                        visible: isOpening,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: ThesisProgressBar(),
                        ),
                        replacement: Visibility(
                          visible: role == UserRoles.employee &&
                              request.status ==
                                  RequestStatuses.statusName(
                                      RequestStatuses.New),
                          child: _RequestDeleteButton(request: request),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _RequestDeleteButton extends StatelessWidget {
  const _RequestDeleteButton({
    required this.request,
  });

  final RequestDto request;

  Future<void> _cancelRequest(
    BuildContext context,
    RequestCancelDto cancelDto,
  ) async {
    await context.read<RequestDataProvider>().cancelRequest(cancelDto);
    context.read<RequestDataProvider>().refreshRequests();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(AppIcons.delete),
      onPressed: () async {
        final reasonController = TextEditingController();
        final isEmptyNotifier = ValueNotifier<bool>(true);
        await ThesisBottomSheep.showBarModalAsync(
          context,
          builder: (context) => Padding(
            padding: kBottomSheepDefaultPaddingHorizontal,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Отменить заявку',
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                TextFormField(
                  controller: reasonController,
                  onChanged: (value) => isEmptyNotifier.value = value.isEmpty,
                  decoration: const InputDecoration(
                    hintText: 'Введите причину отмены',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ThesisOutlinedButton(
                          text: 'Отмена',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ValueListenableBuilder(
                        valueListenable: isEmptyNotifier,
                        builder: (context, isEmpty, child) {
                          return Expanded(
                            child: ThesisButton.fromText(
                              text: 'Готово',
                              isDisabled: isEmpty,
                              onPressed: () async {
                                final cancelDto = RequestCancelDto(
                                  id: request.id,
                                  note: reasonController.text,
                                );
                                await _cancelRequest(
                                  context,
                                  cancelDto,
                                ).whenComplete(() {
                                  context
                                      .read<RequestDataProvider>()
                                      .refreshRequests();
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
