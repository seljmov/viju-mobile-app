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
    final loginFormKey = GlobalKey<FormFieldState>();
    final passwordController = TextEditingController(text: 'client');
    final passwordFormKey = GlobalKey<FormFieldState>();
    final passwordObscureNotifier = ValueNotifier<bool>(true);
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
                  key: loginFormKey,
                  controller: loginController,
                  onChanged: (value) {
                    loginFormKey.currentState?.validate();
                    emptyNotifier.value = loginController.text.isEmpty ||
                        passwordController.text.isEmpty;
                  },
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
                ValueListenableBuilder(
                  valueListenable: passwordObscureNotifier,
                  builder: (context, obscure, child) {
                    return TextFormField(
                      key: passwordFormKey,
                      controller: passwordController,
                      obscureText: obscure,
                      onChanged: (value) {
                        passwordFormKey.currentState?.validate();
                        emptyNotifier.value = loginController.text.isEmpty ||
                            passwordController.text.isEmpty;
                      },
                      validator: _validatePassword,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Пароль',
                        hintText: 'Введите пароль',
                        suffixIcon: Visibility(
                          visible: obscure,
                          child: IconButton(
                            onPressed: () =>
                                passwordObscureNotifier.value = false,
                            icon: SvgPicture.asset(
                              AppIcons.eye,
                            ),
                          ),
                          replacement: IconButton(
                            onPressed: () =>
                                passwordObscureNotifier.value = true,
                            icon: SvgPicture.asset(
                              AppIcons.eyeOff,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
