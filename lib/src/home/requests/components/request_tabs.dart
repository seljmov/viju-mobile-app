import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';
import '../../../welcome/login/contracts/user_roles.dart';
import '../contacts/request_statuses.dart';
import '../widgets/request_list.dart';
import '../widgets/request_tab_bar_item.dart';
import 'request_data_provider.dart';

class RequestTabs extends StatelessWidget {
  const RequestTabs({
    super.key,
    required this.initialStatuses,
    required this.role,
  });

  final List<int> initialStatuses;
  final int role;

  @override
  Widget build(BuildContext context) {
    final statuses = RequestStatuses.statuses;
    final relations = RequestStatuses.relatedStatuses;
    final defaultStatus = [
      role == UserRoles.driver
          ? RequestStatuses.InProgress
          : RequestStatuses.New
    ];

    if (role == UserRoles.driver) {
      statuses.remove(RequestStatuses.New);
      relations.remove(RequestStatuses.New);
      context.read<RequestDataProvider>().loadRequests(defaultStatus);
    }

    final keys = relations.keys.toList();
    final result = relations.entries.firstWhere(
      (element) => listEquals(element.value, initialStatuses),
      orElse: () => relations.entries.first,
    );

    final statusNotifier = ValueNotifier<int>(keys.indexOf(result.key));

    return ValueListenableBuilder(
      valueListenable: statusNotifier,
      builder: (context, currentIndex, child) {
        debugPrint('currentIndex -> $currentIndex');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(statuses.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 22 : 0,
                      right: index == statuses.length - 1 ? 22 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        statusNotifier.value = index;
                        final pickedStatus = statuses.keys.elementAt(index);

                        context.read<RequestDataProvider>().loadRequests(
                            relations[pickedStatus] ?? defaultStatus);
                      },
                      child: RequestTabBarItem(
                        title: statuses.values.elementAt(index),
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
                          provider.loadRequests(
                            relations[statuses.keys.elementAt(currentIndex)]!,
                          );
                        },
                        child: RequestList(
                          requests: requests,
                          role: role,
                          status: 0,
                          //status: statuses[currentIndex],
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
                            'Нет заявок в статусе "${statuses.values.elementAt(currentIndex)}"',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                kPrimaryLighterColor.withOpacity(0.05),
                              ),
                            ),
                            onPressed: () => provider.loadRequests(
                              relations[statuses.keys.elementAt(currentIndex)]!,
                            ),
                            child: Text(
                              'Обновить',
                              style: context.textTheme.labelLarge!.copyWith(
                                color: kPrimaryColor,
                              ),
                            ),
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
