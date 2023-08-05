import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../theme/theme_extention.dart';
import '../bloc/login_scope.dart';
import '../contracts/login_start_dto/login_start_dto.dart';

/// Виджет формы входа
class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController(text: '_zclient');
    final passwordController = TextEditingController(text: 'client');
    final emptyNotifier = ValueNotifier<bool>(
      loginController.text.isEmpty || passwordController.text.isEmpty,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.logo,
                  height: 180,
                ),
                const SizedBox(height: 45),
                TextFormField(
                  controller: loginController,
                  onChanged: (value) => emptyNotifier.value =
                      loginController.text.isEmpty ||
                          passwordController.text.isEmpty,
                  validator: _validateLogin,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                  ),
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Логин',
                    hintText: 'Введите логин',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  onChanged: (value) => emptyNotifier.value =
                      loginController.text.isEmpty ||
                          passwordController.text.isEmpty,
                  validator: _validatePassword,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                  ),
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Пароль',
                    hintText: 'Введите пароль',
                  ),
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder(
                  valueListenable: emptyNotifier,
                  builder: (context, isEmpty, child) {
                    return ThesisButton.fromText(
                      isDisabled: isEmpty,
                      text: 'Войти',
                      onPressed: () {
                        if (isEmpty) return;

                        final loginDto = LoginStartDto(
                          userName: loginController.text,
                          password: passwordController.text,
                        );

                        LoginScope.login(context, loginDto);
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите логин';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    return null;
  }
}
