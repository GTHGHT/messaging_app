import 'package:flutter/material.dart';
import 'package:messaging_app/screens/access_screen.dart';
import 'package:messaging_app/screens/landing_screen.dart';
import 'package:messaging_app/screens/login_screen.dart';

void main() {
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
      displaySmall: TextStyle(
        fontFamily: "Philosopher",
        fontSize: 36,
      ),
    );

    return MaterialApp(
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
        "/": (_) => const LandingScreens(),
        "/access": (_) => const AccessScreens(),
        "/login": (_) => const LoginScreens(),
      },
      initialRoute: "/",
    );
  }
}