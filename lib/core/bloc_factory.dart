import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../services/auth_service.dart';

class BlocFactory {
  static final _authService = AuthService();

  static AuthBloc? _authBlocInstance;

  static AuthBloc getAuthBloc() {
    _authBlocInstance ??= AuthBloc(authService: _authService);
    return _authBlocInstance!;
  }

  // Dispose the AuthBloc instance (call when app is closing)
  static void disposeAuthBloc() {
    _authBlocInstance?.close();
    _authBlocInstance = null;
  }


  static List<BlocProvider> createProviders({bool includeAuth = false}) {
    final providers = <BlocProvider>[];

    if (includeAuth) {
      providers.add(
        BlocProvider<AuthBloc>.value(
          value: getAuthBloc(), 
        ),
      );
    }

    return providers;
  }
}

class BlocCombinations {
  static List<BlocProvider> authScreens() {
    return BlocFactory.createProviders(includeAuth: true);
  }
}
