import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/button/thesis_outlined_button.dart';
import '../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../bloc/request_scope.dart';
import '../contacts/request_cancel_dto/request_cancel_dto.dart';
import '../contacts/request_dto/request_dto.dart';
import '../contacts/request_statuses.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.status,
  });

  final RequestDto request;
  final int status;

  @override
  Widget build(BuildContext context) {
    final titleSmallBold = context.textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.bold,
    );
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
                kDateTimeFormatter.format(request.createdTimestamp),
                style: context.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              Visibility(
                visible: status == RequestStatuses.New,
                child: IconButton(
                  onPressed: () async {
                    final reasonController = TextEditingController();
                    final isEmptyNotifier = ValueNotifier<bool>(true);
                    var removed = false;
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
                              onChanged: (value) =>
                                  isEmptyNotifier.value = value.isEmpty,
                              decoration: const InputDecoration(
                                hintText: 'Введите причину отмены',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 30,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ThesisOutlinedButton(
                                      text: 'Отмена',
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
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
                                            RequestScope.cancelRequest(
                                              context,
                                              cancelDto,
                                            );
                                            removed = true;
                                            Navigator.of(context).pop();
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
                    ).whenComplete(() {
                      if (removed) {
                        RequestScope.load(context, status);
                      }
                    });
                  },
                  icon: SvgPicture.asset(AppIcons.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
