import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme_colors.dart';
import '../../theme/theme_extention.dart';
import '../constants/assets_constants.dart';

/// Помощник работы с Snackbar-сообщениями
class MessageHelper {
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static const _showDuration = Duration(milliseconds: 2500);
  static const _padding = EdgeInsets.all(12);

  static void _showDefaultMessage({
    required bool isSuccess,
    required String message,
    double fontSize = 16,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        duration: _showDuration,
        content: Padding(
          padding: _padding,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset(
                  isSuccess ? AppIcons.success : AppIcons.error,
                ),
              ),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Отобразить кастомное сообщение
  static void showCustomMessage({
    required BuildContext context,
    required Widget child,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: context.currentTheme.scaffoldBackgroundColor,
        duration: _showDuration,
        content: child,
      ),
    );
  }

  /// Вывод сообщения об ошибке
  static void showError(String message) {
    _showDefaultMessage(isSuccess: false, message: message);
  }

  /// Вывод сообщения об успешном выполнении
  static void showSuccess(String message) {
    _showDefaultMessage(isSuccess: true, message: message);
  }

  /// Вывод сообщения по статусу
  static void showByStatus({
    required bool isSuccess,
    String successMessage = "",
    String errorMessage = "",
    double fontSize = 16,
  }) {
    _showDefaultMessage(
      isSuccess: isSuccess,
      message: isSuccess ? successMessage : errorMessage,
      fontSize: fontSize,
    );
  }

  /// Вывод информационного сообщения
  static void showInfo({
    required String message,
    bool showOk = false,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        duration: const Duration(seconds: 5),
        content: Padding(
          padding: _padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Visibility(
                  visible: showOk,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: GestureDetector(
                      child: Text(
                        "Ок, понятно".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryLightColor,
                        ),
                      ),
                      onTap: () {
                        rootScaffoldMessengerKey.currentState
                            ?.hideCurrentSnackBar();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
