import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// This acts as a global "remote control" for your app's theme
class ThemeManager {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Listen to the theme changes here
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'TaskFlow',
          debugShowCheckedModeBanner: false,

          // 1. Set the current mode
          themeMode: currentMode,

          // 2. Light Theme Definition
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF6F7FB),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8E2DE2),
              brightness: Brightness.light,
            ),
            cardColor: Colors.white,
          ),

          // 3. Dark Theme Definition
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(
              0xFF121212,
            ), // Deep dark background
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8E2DE2),
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E), // Darker card surfaces
            ),
            // Customizing text themes for visibility in dark mode
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}
