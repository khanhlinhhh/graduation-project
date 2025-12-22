import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/camera_screen.dart';
import 'screens/main/result_screen.dart';
import 'screens/main/history_screen.dart';
import 'screens/main/collection_points_screen.dart';
import 'screens/main/rewards_screen.dart';
import 'screens/main/redemption_history_screen.dart';
import 'screens/main/edit_profile_screen.dart';
import 'screens/main/help_support_screen.dart';
import 'screens/main/notifications_screen.dart';
import 'screens/tips/tips_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String camera = '/camera';
  static const String result = '/result';
  static const String history = '/history';
  static const String redemptionHistory = '/redemption-history';
  static const String collectionPoints = '/collection-points';
  static const String rewards = '/rewards';
  static const String editProfile = '/edit-profile';
  static const String helpSupport = '/help-support';
  static const String notifications = '/notifications';
  static const String tips = '/tips';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        main: (context) => const MainScreen(),
        camera: (context) => const CameraScreen(),
        result: (context) => const ResultScreen(),
        history: (context) => const HistoryScreen(),
        redemptionHistory: (context) => const RedemptionHistoryScreen(),
        collectionPoints: (context) => const CollectionPointsScreen(),
        rewards: (context) => const RewardsScreen(),
        editProfile: (context) => const EditProfileScreen(),
        helpSupport: (context) => const HelpSupportScreen(),
        notifications: (context) => const NotificationsScreen(),
        tips: (context) => const TipsScreen(),
      };

  static String get initialRoute => onboarding;
}

