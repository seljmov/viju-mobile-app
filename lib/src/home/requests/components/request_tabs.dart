import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';
import '../contacts/request_statuses.dart';
import '../widgets/request_list.dart';
import '../widgets/request_tab_bar_item.dart';
import 'request_data_provider.dart';

class RequestTabs extends StatelessWidget {
  const RequestTabs({
    super.key,
    required this.initialStatus,
  });

  final int initialStatus;

  @override
  Widget build(BuildContext context) {
    final statusesDictinary = RequestStatuses.toDictionary;
    final statuses = statusesDictinary.keys.toList();
    final initialIndex = statuses.indexOf(initialStatus);
    final statusNotifier = ValueNotifier<int>(
      initialIndex == -1 ? 0 : initialIndex,
    );

    return ValueListenableBuilder(
      valueListenable: statusNotifier,
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
                        statusNotifier.value = index;
                        final pickedStatus = statuses[index];
                        context
                            .read<RequestDataProvider>()
                            .loadRequests(pickedStatus);
                      },
                      child: RequestTabBarItem(
                        title: statusesDictinary[statuses[index]]!,
                        isPicked: currentIndex == index,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<RequestDataProvider>(
              builder: (context, provider, child) {
                return StreamBuilder(
                  stream: provider.requestsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: ThesisProgressBar());
                    }

                    final requests = (snapshot.data ?? []).reversed.toList();
                    return Visibility(
                      visible: requests.isNotEmpty,
                      child: RefreshIndicator(
                        color: kPrimaryColor,
                        onRefresh: () async {
                          provider.loadRequests(statuses[currentIndex]);
                        },
                        child: RequestList(
                          requests: requests,
                          status: statuses[currentIndex],
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
                );
              },
            ),
          ],
        );
      },
    );
  }
}
