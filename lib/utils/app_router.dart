import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/chat_assistant_screen.dart';
import '../screens/districts_screen.dart';
import '../screens/district_map_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/assistant',
        name: 'assistant',
        builder: (context, state) => const ChatAssistantScreen(),
      ),
      GoRoute(
        path: '/districts',
        name: 'districts',
        builder: (context, state) => const DistrictsScreen(),
      ),
      GoRoute(
        path: '/district/:id',
        name: 'district-detail',
        builder: (context, state) {
          final districtId = state.pathParameters['id'] ?? '';
          // For now, we'll pass null and let the screen handle it
          return const DistrictsScreen();
        },
      ),
      GoRoute(
        path: '/district-map',
        name: 'district-map',
        builder: (context, state) => const DistrictMapScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Страница не найдена',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ошибка: ${state.error}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C73FE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
