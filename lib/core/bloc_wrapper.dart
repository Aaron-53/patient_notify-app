import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocWrapper<T extends BlocBase> extends StatelessWidget {
  final Widget child;
  final T value;

  const BlocWrapper({super.key, required this.child, required this.value});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(value: value, child: child);
  }
}

class MultiBlocWrapper extends StatelessWidget {
  final List<BlocProvider> providers;
  final Widget child;

  const MultiBlocWrapper({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: providers, child: child);
  }
}

/// Extension to make bloc access easier
extension BlocContextExtension on BuildContext {
  /// Read a bloc - for triggering events
  T readBloc<T extends BlocBase>() => read<T>();

  /// Watch a bloc - for rebuilding when state changes
  T watchBloc<T extends BlocBase>() => watch<T>();

  /// Check if a bloc is available in the widget tree
  bool hasBlocProvider<T extends BlocBase>() {
    try {
      read<T>();
      return true;
    } catch (e) {
      return false;
    }
  }
}
