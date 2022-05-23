import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/screens/access_screen.dart';
import 'package:messaging_app/screens/landing_screen.dart';
import 'package:messaging_app/screens/login_screen.dart';
import 'package:messaging_app/services/bottom_nav_bar_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/chat_screen.dart';
import 'screens/main_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth_access.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Kongko());
}

class Kongko extends StatelessWidget {
  const Kongko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textTheme = TextTheme(
      titleLarge: TextStyle(
        fontFamily: "Philosopher",
        fontWeight: FontWeight.w500,
        fontSize: 22,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Mulish",
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Mulish",
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontFamily: "Mulish",
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      displaySmall: TextStyle(
        fontFamily: "Philosopher",
        fontSize: 36,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthAccess>(
          create: (_) => AuthAccess(),
        ),
        ChangeNotifierProvider<BottomNavBarProvider>(
          create: (_) => BottomNavBarProvider(),
        ),
      ],
      child: MaterialApp(
        // Light Theme
        theme: ThemeData.light().copyWith(
          colorScheme: ThemeData.light().colorScheme.copyWith(
                primary: Colors.lightBlue,
                error: Colors.deepOrange,
                onBackground: Colors.grey,
              ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            hintStyle: textTheme.bodyLarge,
          ),
          textTheme: textTheme.apply(
            bodyColor: const Color(0xff2b2b2b),
            displayColor: const Color(0xff2b2b2b),
          ),
          listTileTheme: ListTileThemeData(
            style: ListTileStyle.list,
            textColor: Color(0xff2b2b2b),
          ),
          primaryTextTheme: textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: textTheme.bodyLarge,
            ),
          ),
        ),
        // Dark Theme
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                primary: Colors.lightGreen,
                error: Colors.pink,
                onBackground: Colors.white,
              ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            hintStyle: textTheme.bodyLarge,
          ),
          textTheme: textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          primaryTextTheme: textTheme.apply(
            bodyColor: const Color(0xff2b2b2b),
            displayColor: const Color(0xff2b2b2b),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreen,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: textTheme.bodyLarge,
            ),
          ),
        ),
        routes: {
          "/": (_) => const LandingScreen(),
          "/access": (_) => const AccessScreen(),
          "/login": (_) => const LoginScreens(),
          "/register": (_) => const RegisterScreen(),
          "/main": (_) => MainScreen(),
          "/chat": (_) => ChatScreen(),
        },
        initialRoute: "/",
      ),
    );
  }
}