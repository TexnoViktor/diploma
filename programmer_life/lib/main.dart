import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/orientation_test_screen.dart';
import 'screens/game_screen.dart';
import 'screens/main_menu_screen.dart';
import 'providers/game_state_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameStateProvider(),
      child: ProgrammerLifeApp(),
    ),
  );
}

class ProgrammerLifeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Життя Програміста',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
      routes: {
        '/orientation_test': (context) => OrientationTestScreen(),
        '/main_menu': (context) => MainMenuScreen(),
        '/game': (context) => GameScreen(),
      },
    );
  }
}