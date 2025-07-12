import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';

void main() {
  runApp(const SaccoApp());
}

class SaccoApp extends StatelessWidget {
  const SaccoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SACCO Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Basic color scheme
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1976D2),
        ),

        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}