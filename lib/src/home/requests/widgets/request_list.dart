import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/constants/constants.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../contacts/request_dto/request_dto.dart';
import 'request_card.dart';

class RequestList extends StatelessWidget {
  const RequestList({
    super.key,
    required this.requests,
    required this.status,
  });

  final List<RequestDto> requests;
  final int status;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SingleChildScrollView(
        physics: kDefaultPhysics,
        child: Column(
          children: List.generate(requests.length, (index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Column(
                    children: [
                      RequestCard(
                        request: requests[index],
                        status: status,
                      ),
                      const Visibility(
                        child: Padding(
                          padding: kThemeDefaultPaddingHorizontal,
                          child: Divider(color: kGray2Color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
