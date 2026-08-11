import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home.dart';
import 'services/auth_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Holbegram',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return StreamBuilder<User?>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return FutureBuilder(
            future: context.read<UserProvider>().refreshUser(),
            builder: (context, refreshSnapshot) {
              if (refreshSnapshot.connectionState != ConnectionState.done) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return const Home();
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}
