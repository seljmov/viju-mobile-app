import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../theme/theme_constants.dart';
import '../../../theme/theme_extention.dart';
import '../constants/assets_constants.dart';

/// Базовый экран со скроллом
class ThesisSliverScreen extends StatelessWidget {
  const ThesisSliverScreen({
    super.key,
    required this.title,
    required this.child,
    this.floatingActionButton,
    this.leading,
    this.leadingCallback,
  });

  final String title;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? leading;
  final VoidCallback? leadingCallback;

  @override
  Widget build(BuildContext context) {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    final detector = ValueNotifier<bool>(true);
    return ValueListenableBuilder(
      valueListenable: detector,
      builder: (context, visibility, _) {
        return Scaffold(
          //resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: leading ??
                  IconButton(
                    icon: SvgPicture.asset(AppIcons.back),
                    onPressed: () {
                      leadingCallback?.call();
                      Navigator.pop(context);
                    },
                  ),
            ),
            centerTitle: true,
            title: AnimatedOpacity(
              opacity: !visibility ? 1 : 0,
              duration: const Duration(milliseconds: 256),
              child: Visibility(
                visible: !visibility && title.isNotEmpty,
                child: Text(
                  title,
                  style: context.textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          floatingActionButton: floatingActionButton,
          body: SingleChildScrollView(
            padding: kThemeDefaultPaddingHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VisibilityDetector(
                  key: UniqueKey(),
                  onVisibilityChanged: (visibilityInfo) {
                    final count = visibilityInfo.visibleFraction;
                    final isVisibility = count > 0.250;
                    detector.value = isVisibility;
                  },
                  child: Text(
                    title,
                    style: context.textTheme.displaySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
