import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../contacts/request_dto/request_dto.dart';
import '../contacts/request_statuses.dart';
import 'request_list.dart';
import 'request_tab_bar_item.dart';

/// Компонент таб-бар
class RequestTabBar extends StatelessWidget {
  const RequestTabBar({
    super.key,
    required this.requests,
    this.initialIndex = 0,
    this.onTap,
  });

  final List<RequestDto> requests;
  final int initialIndex;
  final void Function(int status)? onTap;

  @override
  Widget build(BuildContext context) {
    final tabs = RequestStatuses.names;
    final pickedNotifier = ValueNotifier<int>(initialIndex);
    return ValueListenableBuilder(
      valueListenable: pickedNotifier,
      builder: (context, currentIndex, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 22 : 0,
                      right: index == tabs.length - 1 ? 22 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        pickedNotifier.value = index;
                        onTap?.call(index);
                      },
                      child: RequestTabBarItem(
                        title: tabs[index],
                        isPicked: currentIndex == index,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: requests.isNotEmpty,
              child: RequestList(requests: requests),
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  SvgPicture.asset(AppIcons.emptyRequests),
                  const SizedBox(height: 32),
                  Text(
                    'Здесь пусто',
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Нет заявок в статусе "${tabs[currentIndex]}"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
