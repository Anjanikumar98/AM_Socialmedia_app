import 'package:am_socialmedia_app/services/user_service.dart';
import 'package:am_socialmedia_app/utils/config.dart';
import 'package:am_socialmedia_app/utils/constants.dart';
import 'package:am_socialmedia_app/utils/providers.dart';
import 'package:am_socialmedia_app/view_models/theme/theme_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'components/life_cycle_event_handler.dart';
import 'landing/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () => UserService().setUserStatus(false),
        resumeCallBack: () => UserService().setUserStatus(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            // home: StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: ((BuildContext context, snapshot) {
            //     if (snapshot.hasData) {
            //       return TabScreen();
            //     } else
            //       return Landing();
            //   }),
            // ),
            home: StreamBuilder(
              stream: null, // Temporarily disable Firebase stream
              builder: (context, snapshot) {
                return Landing(); // Default to Landing screen
              },
            ),
          );
        },
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(theme.textTheme),
    );
  }
}
