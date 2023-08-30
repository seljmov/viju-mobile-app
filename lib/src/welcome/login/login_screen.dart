import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../core/constants/routes_constants.dart';
import '../../../core/helpers/message_helper.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_scope.dart';
import 'widgets/login_form_widget.dart';

/// Экран входа в приложение
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      bloc: LoginScope.of(context),
      listener: (context, state) => state.maybeMap(
        errorLogin: (state) => MessageHelper.showError(state.message),
        successLogin: (state) => navService.pushNamedAndRemoveUntil(
          AppRoutes.home,
          args: state.role,
        ),
        orElse: () => const LoginFormWidget(),
      ),
      child: const LoginFormWidget(),
    );
  }
}
