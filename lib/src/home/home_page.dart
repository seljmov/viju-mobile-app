import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/assets_constants.dart';
import '../../theme/theme_constants.dart';
import '../../theme/theme_extention.dart';
import '../welcome/auth/auth_scope.dart';
import 'requests/bloc/request_bloc.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: kThemeDefaultPadding,
              child: Text(
                'Заявки',
                style: context.textTheme.displaySmall,
              ),
            ),
            BlocProvider(
              create: (_) => RequestBloc(
                initialState: const RequestState.initial(),
                requestRepository: RequestRepositoryImpl(),
              ),
              child: const RequestScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
