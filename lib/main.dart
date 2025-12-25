import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thriftly_app/config/app_theme.dart';
import 'package:thriftly_app/screens/splash_screen.dart';
import 'package:thriftly_app/services/auth_service.dart';
import 'package:thriftly_app/services/firestore_service.dart';
import 'package:thriftly_app/services/storage_service.dart';
// Import ini akan dibuat setelah run flutterfire configure
// import 'firebase_options.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // IMPORTANT: Uncomment this after running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const ThriftlyApp());
}

class ThriftlyApp extends StatelessWidget {
  const ThriftlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Service Provider
        Provider<AuthService>(create: (_) => AuthService()),

        // Firestore Service Provider
        Provider<FirestoreService>(create: (_) => FirestoreService()),

        // Storage Service Provider
        Provider<StorageService>(create: (_) => StorageService()),

        // Auth State Stream
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Thriftly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
