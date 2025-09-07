import 'package:go_router/go_router.dart';
import 'package:patient_notification/core/bloc_factory.dart';
import 'package:patient_notification/core/bloc_wrapper.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/welcome_screen.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MultiBlocWrapper(
            providers: BlocCombinations.authScreens(),
            child: const SplashScreen(),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => BlocWrapper(
            value: BlocFactory.getAuthBloc(),
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => BlocWrapper(
            value: BlocFactory.getAuthBloc(),
            child: const WelcomeScreen(),
          ),
        ),
      ],
    );
  }
}
