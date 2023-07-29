import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/assets_constants.dart';
import '../../theme/theme_constants.dart';
import '../../theme/theme_extention.dart';
import '../welcome/auth/auth_scope.dart';

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
        padding: kThemeDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Заявки',
              style: context.textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
