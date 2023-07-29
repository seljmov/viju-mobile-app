import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/tokens/tokens_repository_impl.dart';
import '../../../core/repositories/user/user_repository.dart';
import 'bloc/login_bloc.dart';
import 'login_screen.dart';
import 'repositories/login_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        initialState: const LoginState.initial(),
        tokensRepository: TokensRepositoryImpl(),
        loginRepository: LoginRepositoryImpl(),
        userRepository: UserRepositoryImpl(),
      ),
      child: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
