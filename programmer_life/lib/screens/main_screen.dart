// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _hasCompletedTest = false;
  
  @override
  void initState() {
    super.initState();
    _checkTestCompletion();
  }

  Future<void> _checkTestCompletion() async {
    final completed = await StorageService.hasCompletedTest();
    setState(() {
      _hasCompletedTest = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Життя Програміста',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                _buildMenuButton(
                  'Почати гру',
                  Icons.play_arrow,
                  () {
                    if (_hasCompletedTest) {
                      Navigator.pushNamed(context, '/game');
                    } else {
                      Navigator.pushNamed(context, '/test');
                    }
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  'Профорієнтаційний тест',
                  Icons.quiz,
                  () {
                    Navigator.pushNamed(context, '/test');
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  'Налаштування',
                  Icons.settings,
                  () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  'Вийти',
                  Icons.exit_to_app,
                  () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                const Text(
                  '© 2025 Flutter Game Studio',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.indigo.shade900,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }
}