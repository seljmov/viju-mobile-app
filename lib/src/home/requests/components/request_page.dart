import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/routes_constants.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../../welcome/auth/auth_scope.dart';
import '../../../welcome/login/contracts/user_roles.dart';
import 'request_data_provider.dart';
import 'request_tabs.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({
    super.key,
    required this.role,
  });

  final int role;

  @override
  Widget build(BuildContext context) {
    debugPrint('role -> $role');
    final loadSourcesNotifier = ValueNotifier<bool>(false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => AuthScope.loggedOut(context),
            icon: SvgPicture.asset(AppIcons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: Visibility(
        visible: role == UserRoles.employee,
        child: FloatingActionButton(
          onPressed: () async {
            loadSourcesNotifier.value = true;
            final provider = context.read<RequestDataProvider>();
            final args = await provider.loadRequestSources();
            Future.delayed(
              Duration.zero,
              () => navService.pushNamed(
                AppRoutes.addRequest,
                args: args,
              ),
            ).whenComplete(() {
              provider.refreshRequests();
              loadSourcesNotifier.value = false;
            });
          },
          child: ValueListenableBuilder(
            valueListenable: loadSourcesNotifier,
            builder: (context, isLoad, child) {
              return isLoad
                  ? const Center(child: ThesisProgressBar(color: Colors.white))
                  : SvgPicture.asset(AppIcons.add);
            },
          ),
        ),
      ),
      body: Consumer<RequestDataProvider>(
        builder: (context, provider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: kThemeDefaultPaddingHorizontal,
              child: Text(
                'Заявки',
                style: context.textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 20),
            RequestTabs(
              initialStatuses: provider.currentStatuses,
            ),
          ],
        ),
      ),
    );
  }
}
