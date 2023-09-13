import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.725,
      child: AnimationLimiter(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: requests.length,
          itemBuilder: (context, index) {
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
                      Visibility(
                        visible: index != requests.length - 1,
                        child: const Padding(
                          padding: kThemeDefaultPaddingHorizontal,
                          child: Divider(color: kGray2Color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
