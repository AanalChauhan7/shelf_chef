import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/core.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Log framework errors instead of dying silently.
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('FlutterError: ${details.exceptionAsString()}');
    };

    // In release builds a failed widget is normally drawn as a blank box.
    // Show the actual error instead so problems are visible and reportable.
    ErrorWidget.builder = (details) => Material(
          color: const Color(0xFFFFF4F4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Text(
                'UI error:\n${details.exceptionAsString()}',
                style: const TextStyle(color: Color(0xFFB00020), fontSize: 11),
              ),
            ),
          ),
        );

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase init failed: $e');
    }
    await ThemeService.init();
    await AppNotificationService.instance.init();
    runApp(const ShelfChefApp());
  }, (error, stack) => debugPrint('Uncaught error: $error\n$stack'));
}

class ShelfChefApp extends StatelessWidget {
  const ShelfChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'ShelfChef AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
