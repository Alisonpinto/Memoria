import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MemoriaApp());
}

class MemoriaApp extends StatelessWidget {
  const MemoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memoria',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F0F),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0F0F0F),
          background: Color(0xFF0F0F0F),
        ),
        fontFamily: 'Roboto', // Similar to Android's default
      ),
      home: const MainNavigation(),
    );
  }
}