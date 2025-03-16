import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/quick_calculate_screen.dart';
import 'screens/custom_calculate_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bye-Bye Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/quick-calculate': (context) => const QuickCalculateScreen(),
        '/custom-calculate': (context) => const CustomCalculateScreen(),
      },
    );
  }
}
