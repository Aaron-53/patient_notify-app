import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loginFailed = false;

  void _attemptLogin() {
    // Simple fake login check
    const String correctUsername = 'patient';
    const String correctPassword = '1234';

    if (_usernameController.text == correctUsername &&
        _passwordController.text == correctPassword) {
      // Password correct → navigate to WelcomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(
            patientName: _usernameController.text,
            patientAge: 42, // placeholder until backend is ready
          ),
        ),
      );
    } else {
      setState(() {
        _loginFailed = true; // show error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _attemptLogin,
              child: const Text('Login'),
            ),
            if (_loginFailed) ...[
              const SizedBox(height: 12),
              const Text(
                'Invalid username or password',
                style: TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
