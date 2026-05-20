import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'core/di/injection_container.dart';
import 'core/services/push_notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApp();
  await initDependencies();
  await sl<PushNotificationService>().initialize();
  _configureWidgetErrorUI();
  Bloc.observer = const _AppBlocObserver();
  runApp(const AmarMistriApp());
}

void _configureWidgetErrorUI() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!kReleaseMode) {
      return ErrorWidget(details.exception);
    }

    return const _ReleaseErrorFallback();
  };
}

class AmarMistriApp extends StatelessWidget {
  const AmarMistriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context);
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) => MaterialApp.router(
              title: 'Amar Mistri',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepOrange,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              themeMode: themeMode,
              routerConfig: router,
              builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}

class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('[BLoC] ${bloc.runtimeType}: $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint('[BLoC] ${bloc.runtimeType}: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('[BLoC] ${bloc.runtimeType} error: $error');
    super.onError(bloc, error, stackTrace);
  }
}

class _ReleaseErrorFallback extends StatelessWidget {
  const _ReleaseErrorFallback();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F7FA),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF1A73E8)),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Something went wrong on this screen. Please go back and try again.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
