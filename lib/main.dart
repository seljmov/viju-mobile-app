import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import 'core/bloc/bloc_global_observer.dart';
import 'core/constants/constants.dart';
import 'core/constants/routes_constants.dart';
import 'core/helpers/dio_helper.dart';
import 'core/helpers/env_helper.dart';
import 'core/helpers/message_helper.dart';
import 'core/helpers/my_logger.dart';
import 'core/repositories/tokens/tokens_repository_impl.dart';
import 'core/repositories/user/user_repository.dart';
import 'src/welcome/auth/auth_bloc.dart';
import 'src/welcome/auth/auth_scope.dart';
import 'src/welcome/auth/repositories/auth_repository.dart';
import 'core/splash_screen.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

Future<void> main() async {
  await initializeDateFormatting('ru_RU');

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: '.env');

      final userRepository = UserRepositoryImpl();
      await userRepository.getUserIsUsingDevApi().then((value) {
        EnvHelper.mainApiUrl =
            value ? EnvHelper.devApiUrl : EnvHelper.productionApiUrl;
      });
      debugPrint('MainApiUrl: ${EnvHelper.mainApiUrl}');

      Bloc.observer = BlocGlobalObserver();
      Bloc.transformer = bloc_concurrency.sequential();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      final savedTheme = await AdaptiveTheme.getThemeMode();
      runApp(AppConfigurator(savedTheme: savedTheme));
    },
    (error, stackTrace) async {
      MyLogger.e('Error: $error');
      MyLogger.e('StackTrace: $stackTrace');
      if (!kDebugMode) {
        final tokensRepository = TokensRepositoryImpl();
        final accessToken = await tokensRepository.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          final data = {
            'accessToken': accessToken,
            'text': 'runZonedGuarded -> $error',
            'stackTrace': stackTrace.toString(),
          };
          await DioHelper.postData(
            url: '/error',
            data: data,
          ).whenComplete(
            () => MyLogger.i('Информация об ошибке была отправлена'),
          );
        }
      }
    },
  );
}

/// Конфигурация приложения
class AppConfigurator extends StatelessWidget {
  const AppConfigurator({
    super.key,
    this.savedTheme,
  });

  final AdaptiveThemeMode? savedTheme;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            initialState: const AuthState.initial(),
            tokensRepository: TokensRepositoryImpl(),
            authRepository: AuthRepositoryImpl(),
            userRepository: UserRepositoryImpl(),
          ),
        ),
      ],
      child: AdaptiveTheme(
        light: lightThemeData,
        dark: darkThemeData,
        initial: savedTheme ?? AdaptiveThemeMode.light,
        builder: (light, dark) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', 'RU'),
            ],
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: MessageHelper.rootScaffoldMessengerKey,
            title: 'Mobile app',
            navigatorKey: NavigationService.navigationKey,
            onGenerateRoute: AppRoutes.generateRoute,
            theme: light,
            darkTheme: dark,
            home: const AppRunner(),
          );
        },
      ),
    );
  }
}

/// Запуск приложения
class AppRunner extends StatefulWidget {
  const AppRunner({super.key});

  @override
  State<AppRunner> createState() => _AppRunnerState();
}

class _AppRunnerState extends State<AppRunner> {
  @override
  void initState() {
    super.initState();
    AuthScope.start(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: BlocListener<AuthBloc, AuthState>(
        bloc: AuthScope.of(context),
        listener: (context, state) => state.maybeMap(
          unauthenticated: (_) => navService.pushNamedAndRemoveUntil(
            AppRoutes.login,
          ),
          authenticated: (state) {
            return navService.pushNamedAndRemoveUntil(
              AppRoutes.home,
              args: state.role,
            );
          },
          orElse: () => const SplashScreen(),
        ),
        child: const SplashScreen(),
      ),
    );
  }
}
