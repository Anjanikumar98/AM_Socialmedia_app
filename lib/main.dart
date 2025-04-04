import 'package:am_socialmedia_app/screens/mainscreen.dart';
import 'package:am_socialmedia_app/utils/providers.dart';
import 'package:am_socialmedia_app/view_models/theme/theme_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'landing/landing_page.dart';
import 'services/user_service.dart';
import 'utils/constants.dart';

// Initialize Firebase
class Config {
  static Future<void> initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized successfully.");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final UserService _userService = UserService(); // Reuse the instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _userService.setUserStatus(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _userService.setUserStatus(false);
        break;
      case AppLifecycleState.detached:
        // Detached is not always triggered reliably
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, notifier, child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.getTheme(notifier.dark),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                print("Snapshot Connection State: ${snapshot.connectionState}");
                print("User: ${snapshot.data?.uid ?? 'No user logged in'}");

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return snapshot.hasData && snapshot.data != null
                    ? TabScreen()
                    : Landing();
              },
            ),
          );
        },
      ),
    );
  }
}

class ThemeConfig {
  static ThemeData getTheme(bool isDark) {
    return (isDark ? Constants.darkTheme : Constants.lightTheme).copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(),
    );
  }
}
