import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/assets_constants.dart';
import '../../core/widgets/thesis_sliver_screen.dart';
import '../welcome/auth/auth_scope.dart';
import 'requests/bloc/request_bloc.dart';
import 'requests/bloc/request_scope.dart';
import 'requests/repositories/request_repository.dart';
import 'requests/request_screen.dart';

/// Экран главной страницы
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestBloc(
        initialState: const RequestState.initial(),
        requestRepository: RequestRepositoryImpl(),
      ),
      child: Builder(
        builder: (context) => ThesisSliverScreen(
          title: 'Заявки',
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
              onPressed: () => AuthScope.loggedOut(context),
              icon: SvgPicture.asset(AppIcons.logout),
            ),
            const SizedBox(width: 8),
          ],
          bodyPadding: EdgeInsets.zero,
          floatingActionButton: FloatingActionButton(
            onPressed: () => RequestScope.openAddRequestPage(context),
            child: SvgPicture.asset(AppIcons.add),
          ),
          child: const RequestScreen(),
        ),
      ),
    );
  }
}
