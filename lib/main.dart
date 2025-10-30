import 'package:flutter/material.dart';
import 'utils/app_router.dart';

void main() {
  runApp(const ARTouristApp());
}

class ARTouristApp extends StatelessWidget {
  const ARTouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AR Tourist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0C73FE),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'DM Sans',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          displaySmall: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500),
          labelMedium: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF2A2A2A),
          selectedItemColor: Color(0xFF0C73FE),
          unselectedItemColor: Colors.white70,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
