import 'package:flutter/material.dart';
import 'core/core.dart';
import 'features/onboarding/screens/splash_screen.dart';

void main() {
  runApp(const ShelfChefApp());
}

class ShelfChefApp extends StatelessWidget {
  const ShelfChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShelfChef AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
