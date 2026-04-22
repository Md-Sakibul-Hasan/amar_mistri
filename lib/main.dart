import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  Bloc.observer = const _AppBlocObserver();
  runApp(const AmarMistriApp());
}

class AmarMistriApp extends StatelessWidget {
  const AmarMistriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context);
          return MaterialApp.router(
            title: 'Amar Mistri',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
              useMaterial3: true,
            ),
            routerConfig: router,
            builder: EasyLoading.init(),
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
