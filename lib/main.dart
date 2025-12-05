import 'package:festival_rumour/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/locator.dart';
import 'core/services/navigation_service.dart';

/// Main entry point of the Festival Rumour application
void main() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase first
    await Firebase.initializeApp();

    // Initialize dependency injection
    await setupLocator();

    // Set preferred orientations (portrait only for mobile experience)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    runApp(const FestivalRumourApp());
  } catch (e) {
    // Handle Firebase initialization errors
    print('Firebase initialization error: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Firebase initialization failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Error: $e'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Main application widget with MVVM architecture
class FestivalRumourApp extends StatelessWidget {
  const FestivalRumourApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App Configuration
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Routing Configuration
      initialRoute: AppRoutes.splash,
      onGenerateRoute: onGenerateRoute,

      // Navigation Configuration
      navigatorKey: locator<NavigationService>().navigatorKey,

      // Builder for additional configuration
      builder: (context, child) {
        return MediaQuery(
          // Prevent text scaling beyond reasonable limits
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
