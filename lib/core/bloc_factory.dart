import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/treatment_plan/treatment_plan_bloc.dart';
import '../services/auth_service.dart';

class BlocFactory {
  static final _authService = AuthService();

  static AuthBloc? _authBlocInstance;
  static TreatmentPlanBloc? _treatmentPlanBlocInstance;

  static AuthBloc getAuthBloc() {
    _authBlocInstance ??= AuthBloc(authService: _authService);
    return _authBlocInstance!;
  }

  static TreatmentPlanBloc getTreatmentPlanBloc() {
    _treatmentPlanBlocInstance ??= TreatmentPlanBloc();
    return _treatmentPlanBlocInstance!;
  }

  // Dispose the AuthBloc instance (call when app is closing)
  static void disposeAuthBloc() {
    _authBlocInstance?.close();
    _authBlocInstance = null;
  }

  // Dispose the TreatmentPlanBloc instance
  static void disposeTreatmentPlanBloc() {
    _treatmentPlanBlocInstance?.close();
    _treatmentPlanBlocInstance = null;
  }

  // Dispose all blocs
  static void disposeAllBlocs() {
    disposeAuthBloc();
    disposeTreatmentPlanBloc();
  }

  static List<BlocProvider> createProviders({
    bool includeAuth = false,
    bool includeTreatmentPlan = false,
  }) {
    final providers = <BlocProvider>[];

    if (includeAuth) {
      providers.add(BlocProvider<AuthBloc>.value(value: getAuthBloc()));
    }

    if (includeTreatmentPlan) {
      providers.add(
        BlocProvider<TreatmentPlanBloc>.value(value: getTreatmentPlanBloc()),
      );
    }

    return providers;
  }
}

class BlocCombinations {
  static List<BlocProvider> authScreens() {
    return BlocFactory.createProviders(includeAuth: true);
  }

  static List<BlocProvider> treatmentPlanScreens() {
    return BlocFactory.createProviders(
      includeAuth: true,
      includeTreatmentPlan: true,
    );
  }
}
