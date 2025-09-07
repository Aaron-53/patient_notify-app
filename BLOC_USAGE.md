# Bloc Management System Usage Guide

This system provides a clean, scalable way to manage blocs across your Flutter app. You only provide blocs where they're actually needed.

## 🏗️ Architecture Overview

```
main.dart → Clean, no blocs
app_router.dart → Provides blocs per route
bloc_factory.dart → Creates all blocs
bloc_wrapper.dart → Reusable bloc utilities
```

## 📦 Files Created

1. **lib/core/bloc_factory.dart** - Centralized bloc creation
2. **lib/core/bloc_wrapper.dart** - Reusable bloc utilities
3. **Updated app_router.dart** - Route-specific bloc provision

## 🚀 How to Use

### Adding a New Bloc (e.g., ThemeBloc)

1. **Create your bloc** as usual:

```dart
// lib/bloc/theme/theme_bloc.dart
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> { ... }
```

2. **Add to BlocFactory**:

```dart
// lib/core/bloc_factory.dart
static ThemeBloc createThemeBloc() {
  return ThemeBloc();
}

static BlocProvider<ThemeBloc> themeBlocProvider({
  required Widget child,
  bool lazy = true,
}) {
  return BlocProvider<ThemeBloc>(
    create: (context) => createThemeBloc(),
    lazy: lazy,
    child: child,
  );
}

// Update createProviders method
static List<BlocProvider> createProviders({
  bool includeAuth = false,
  bool includeTheme = false, // Add this
}) {
  final providers = <BlocProvider>[];

  if (includeAuth) {
    providers.add(BlocProvider<AuthBloc>(
      create: (context) => createAuthBloc(),
      lazy: true,
    ));
  }

  if (includeTheme) { // Add this
    providers.add(BlocProvider<ThemeBloc>(
      create: (context) => createThemeBloc(),
      lazy: true,
    ));
  }

  return providers;
}
```

3. **Add to BlocCombinations**:

```dart
// lib/core/bloc_factory.dart
static List<BlocProvider> settingsScreens() {
  return BlocFactory.createProviders(
    includeAuth: true,
    includeTheme: true, // Add theme for settings
  );
}
```

### Using Blocs in Routes

#### Method 1: Predefined combinations

```dart
// In app_router.dart
GoRoute(
  path: '/settings',
  builder: (context, state) {
    return MultiBlocProvider(
      providers: BlocCombinations.settingsScreens(), // Auth + Theme
      child: const SettingsScreen(),
    );
  },
),
```

#### Method 2: Custom combinations

```dart
GoRoute(
  path: '/profile',
  builder: (context, state) {
    return MultiBlocProvider(
      providers: BlocFactory.createProviders(
        includeAuth: true,
        includeTheme: false, // Only auth, no theme
      ),
      child: const ProfileScreen(),
    );
  },
),
```

#### Method 3: Single bloc

```dart
GoRoute(
  path: '/login',
  builder: (context, state) {
    return BlocFactory.authBlocProvider(
      child: const LoginScreen(),
    );
  },
),
```

#### Method 4: No blocs

```dart
GoRoute(
  path: '/about',
  builder: (context, state) => const AboutScreen(), // No blocs needed
),
```

### Using Blocs in Widgets

```dart
// In your screens
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Your UI here
      },
    );
  }

  void _login() {
    context.readBloc<AuthBloc>().add(LoginRequested()); // Using extension
    // or
    context.read<AuthBloc>().add(LoginRequested()); // Standard way
  }
}
```

## 🎯 Benefits

✅ **Memory efficient** - Blocs only exist where needed
✅ **Clean main.dart** - No bloc management clutter
✅ **Scalable** - Easy to add new blocs
✅ **Flexible** - Mix and match blocs per screen
✅ **Type safe** - Full type checking
✅ **Testable** - Easy to mock specific blocs

## 📋 Current Setup

- **AuthBloc**: Available on splash, login, welcome screens
- **Other screens**: No blocs unless specified
- **Future blocs**: Just add to BlocFactory and use anywhere

## 🔧 Maintenance

When adding new blocs:

1. Create the bloc
2. Add factory method to BlocFactory
3. Update createProviders() method
4. Add to BlocCombinations if needed
5. Use in routes where required

This system scales infinitely - add as many blocs as you need! 🚀
