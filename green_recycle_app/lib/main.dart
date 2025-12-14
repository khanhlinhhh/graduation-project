import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app_theme.dart';
import 'routes.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables (optional - may be empty)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // .env file is empty or missing - this is OK since we use Cloud Functions
    debugPrint('Note: .env file not loaded: $e');
  }
  
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user to determine initial route
    final currentUser = FirebaseAuth.instance.currentUser;
    final initialRoute = currentUser != null ? AppRoutes.main : AppRoutes.onboarding;

    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Green Recycle',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: initialRoute,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
