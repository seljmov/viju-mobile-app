import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';
import '../contacts/request_dto/request_dto.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
  });

  final RequestDto request;

  @override
  Widget build(BuildContext context) {
    final titleSmallBold = context.textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        Padding(
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
                    kDateTimeFormatter.format(request.pickupDate),
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
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
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Divider(color: kGray2Color),
        ),
      ],
    );
  }
}
