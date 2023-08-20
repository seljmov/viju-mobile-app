import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../core/constants/routes_constants.dart';
import '../../../core/widgets/thesis_progress_bar.dart';
import 'bloc/request_bloc.dart';
import 'bloc/request_scope.dart';
import 'contacts/request_statuses.dart';
import 'widgets/request_tab_bar.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    RequestScope.load(context, RequestStatuses.New);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentStatusNotifier = ValueNotifier<int>(RequestStatuses.New);
    return BlocConsumer<RequestBloc, RequestState>(
      bloc: RequestScope.of(context),
      listener: (context, state) => state.mapOrNull(
        initial: (state) => RequestScope.load(context, RequestStatuses.New),
        openedAddRequestPage: (state) => navService.pushNamed(
          AppRoutes.addRequest,
          args: {
            'contractors': state.contractors,
            'wastes': state.wastes,
            'removals': state.removals,
          },
        ).whenComplete(
          () => RequestScope.load(context, currentStatusNotifier.value),
        ),
      ),
      builder: (context, state) => state.maybeMap(
        loaded: (state) => RequestTabBar(
          currentStatus: currentStatusNotifier.value,
          onTap: (status) {
            //RequestScope.load(context, status);
            currentStatusNotifier.value = status;
          },
        ),
        orElse: () => const Center(child: ThesisProgressBar()),
      ),
    );
  }
}
