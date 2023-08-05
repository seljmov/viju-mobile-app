import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants/assets_constants.dart';
import 'widgets/thesis_progress_bar.dart';

/// Экран загрузки
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              AppIcons.logo,
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThesisProgressBar(size: Size(16, 16)),
              SizedBox(width: 10),
              Text('Загрузка...'),
            ],
          ),
        ],
      ),
    );
  }
}
