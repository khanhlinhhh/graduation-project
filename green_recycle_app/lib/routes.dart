import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/camera_screen.dart';
import 'screens/main/result_screen.dart';
import 'screens/main/collection_points_screen.dart';
import 'screens/main/rewards_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String camera = '/camera';
  static const String result = '/result';
  static const String collectionPoints = '/collection-points';
  static const String rewards = '/rewards';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        main: (context) => const MainScreen(),
        camera: (context) => const CameraScreen(),
        result: (context) => const ResultScreen(),
        collectionPoints: (context) => const CollectionPointsScreen(),
        rewards: (context) => const RewardsScreen(),
      };

  static String get initialRoute => onboarding;
}
