import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diccionario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Consumer<AuthService>(
        builder: (context, authService, _) {
          return authService.loggedIn ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
