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

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _auth = AuthService();

  // Kept in sync with the uid currently being (or already) refreshed, so
  // rebuilds triggered while a refresh is in flight reuse the same Future
  // instead of firing a brand new Firestore read every time.
  String? _refreshedUid;
  Future<void>? _refreshFuture;

  Future<void> _refreshFor(String uid) {
    if (_refreshedUid != uid) {
      _refreshedUid = uid;
      _refreshFuture = context.read<UserProvider>().refreshUser();
    }
    return _refreshFuture!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          _refreshedUid = null;
          _refreshFuture = null;
          return const LoginScreen();
        }

        return FutureBuilder<void>(
          future: _refreshFor(user.uid),
          builder: (context, refreshSnapshot) {
            if (refreshSnapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (refreshSnapshot.hasError) {
              // The Firestore profile is missing (e.g. deleted) even
              // though a Firebase Auth session is still cached locally.
              // Sign out so the stream above emits null and routes back
              // to the login screen instead of crashing on a never
              // initialized user.
              _auth.signOut();
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return const Home();
          },
        );
      },
    );
  }
}
