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
          primary: Color(0xFF7C5CFF),
          secondary: Color(0xFF7C5CFF),
          surface: Color(0xFF0F0F0F),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF7C5CFF),
          selectionHandleColor: Color(0xFF7C5CFF),
          selectionColor: Color(0x4D7C5CFF), // 30% opacity
        ),
        fontFamily: 'Roboto', // Similar to Android's default
      ),
      home: const MainNavigation(),
    );
  }
}