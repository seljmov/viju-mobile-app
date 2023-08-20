import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../theme/theme_extention.dart';
import '../contacts/request_dto/request_dto.dart';
import '../contacts/request_statuses.dart';
import '../repositories/request_repository.dart';
import 'request_list.dart';
import 'request_tab_bar_item.dart';

/// Компонент таб-бар
class RequestTabBar extends StatefulWidget {
  const RequestTabBar({
    super.key,
    this.currentStatus = 1,
    this.onTap,
  });

  final int currentStatus;
  final void Function(int status)? onTap;

  @override
  State<RequestTabBar> createState() => _RequestTabBarState();
}

class _RequestTabBarState extends State<RequestTabBar> {
  final requestRepository = RequestRepositoryImpl();
  final statusesDictinary = RequestStatuses.toDictionary;
  Future<List<RequestDto>>? future;

  @override
  void initState() {
    future = requestRepository.getRequests(widget.currentStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    final initialIndex = statusesDictinary.keys.toList().indexOf(
          widget.currentStatus,
        );
    final pickedNotifier = ValueNotifier<int>(
      initialIndex == -1 ? 0 : initialIndex,
    );
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
                children: List.generate(statusesDictinary.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 22 : 0,
                      right: index == statusesDictinary.length - 1 ? 22 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        pickedNotifier.value = index;
                        final pickedStatus =
                            statusesDictinary.keys.elementAt(index);
                        widget.onTap?.call(pickedStatus);
                        future = requestRepository.getRequests(pickedStatus);
                      },
                      child: RequestTabBarItem(
                        title: statusesDictinary[
                            statusesDictinary.keys.elementAt(index)]!,
                        isPicked: currentIndex == index,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<RequestDto>?>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: ThesisProgressBar());
                }

                final requests = (snapshot.data ?? []).reversed.toList();
                return Visibility(
                  visible: requests.isNotEmpty,
                  child: RefreshIndicator(
                    key: refreshIndicatorKey,
                    onRefresh: () async {
                      setState(() {
                        future = requestRepository.getRequests(
                          statusesDictinary.keys.elementAt(currentIndex),
                        );
                      });
                    },
                    child: RequestList(
                      requests: requests,
                      status: statusesDictinary.keys.elementAt(currentIndex),
                    ),
                  ),
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
                        'Нет заявок в статусе "${statusesDictinary.values.elementAt(currentIndex)}"',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
