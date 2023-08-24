import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../theme/theme_constants.dart';
import '../../../theme/theme_extention.dart';
import '../constants/assets_constants.dart';
import '../constants/constants.dart';

/// Базовый экран со скроллом
class ThesisSliverScreen extends StatelessWidget {
  const ThesisSliverScreen({
    super.key,
    required this.title,
    required this.child,
    this.floatingActionButton,
    this.leading,
    this.leadingCallback,
    this.actions,
    this.bodyPadding,
  });

  final String title;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? leading;
  final VoidCallback? leadingCallback;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? bodyPadding;

  @override
  Widget build(BuildContext context) {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    final detector = ValueNotifier<bool>(true);
    return ValueListenableBuilder(
      valueListenable: detector,
      builder: (context, visibility, _) {
        return Scaffold(
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
                  style: context.textTheme.titleMedium,
                ),
              ),
            ),
            actions: actions,
          ),
          floatingActionButton: floatingActionButton,
          body: SingleChildScrollView(
            physics: kDefaultPhysics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: kThemeDefaultPaddingHorizontal,
                  child: VisibilityDetector(
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
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: bodyPadding ?? kThemeDefaultPaddingHorizontal,
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
