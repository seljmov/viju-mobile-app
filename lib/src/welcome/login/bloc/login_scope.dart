import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contracts/login_start_dto/login_start_dto.dart';
import 'login_bloc.dart';

/// Скоп для блока аутентификации
class LoginScope {
  static LoginBloc of(BuildContext context) {
    return BlocProvider.of<LoginBloc>(context);
  }

  static void login(BuildContext context, LoginStartDto loginDto) {
    of(context).add(LoginEvent.login(startDto: loginDto));
  }
}
