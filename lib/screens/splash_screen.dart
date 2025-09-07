import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/auth/auth_event.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _showNetworkErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.orange),
              SizedBox(width: 8),
              Text('Network Issue'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Retry token verification
                context.read<AuthBloc>().add(AuthTokenVerificationRequested());
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Go to login screen
                context.go('/login');
              },
              child: const Text('Login Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to welcome screen
          context.go('/welcome');
        } else if (state is AuthUnauthenticated || state is AuthError) {
          // Navigate to login screen
          context.go('/login');
        } else if (state is AuthNetworkError) {
          // Show network error dialog
          _showNetworkErrorDialog(context, state.message);
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Patient Notify',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 48),
              CupertinoActivityIndicator(radius: 20, color: Colors.blue),
              SizedBox(height: 24),
              Text(
                'Verifying credentials...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}