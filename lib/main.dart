import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().requestPermissions();
  runApp(const MemoriaApp());
}

class MemoriaApp extends StatelessWidget {
  const MemoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Memoria',
          themeMode: ThemeService().isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF8F9FA),
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF1A1D20)),
              titleTextStyle: TextStyle(color: Color(0xFF1A1D20), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF997DFF),
              secondary: Color(0xFF997DFF),
              surface: Color(0xFFFFFFFF),
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF997DFF),
              selectionHandleColor: Color(0xFF997DFF),
              selectionColor: Color(0x4D997DFF),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFF1A1D20)),
              bodyLarge: TextStyle(color: Color(0xFF1A1D20)),
            ),
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F0F0F),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F0F0F),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF997DFF),
              secondary: Color(0xFF997DFF),
              surface: Color(0xFF0F0F0F),
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF997DFF),
              selectionHandleColor: Color(0xFF997DFF),
              selectionColor: Color(0x4D997DFF),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
            ),
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}