import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holbegram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const AuthGate(),
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
          return HomeScreen(user: snapshot.data!);
        }
        return const LoginScreen();
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Holbegram', style: GoogleFonts.lobster()),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: auth.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestore.streamUserProfile(user.uid),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Signed in as ${user.email ?? user.uid}'),
                  const SizedBox(height: 8),
                  Text(
                    data == null
                        ? 'Loading Firestore profile…'
                        : 'Firestore profile OK (uid: ${data['uid'] ?? user.uid})',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
