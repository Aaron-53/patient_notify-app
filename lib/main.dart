import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'services/auth_service.dart';
import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final authBloc = AuthBloc(authService: authService);
    final router = AppRouter.createRouter();

    return BlocProvider(
      create: (context) => authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Patient Notifications',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
