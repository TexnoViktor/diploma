// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_screen.dart';
import 'screens/career_test_screen.dart';
import 'screens/game_screen.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Фіксуємо орієнтацію (опціонально)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(const ProgrammerLifeApp());
}

class ProgrammerLifeApp extends StatelessWidget {
  const ProgrammerLifeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Життя Програміста',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainScreen(),
        '/test': (context) => const CareerTestScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // Затримка для відображення заставки (2 секунди)
    await Future.delayed(const Duration(seconds: 2));
    
    // Перевірка, чи користувач вже проходив тест
    final hasCompletedTest = await StorageService.hasCompletedTest();
    
    if (hasCompletedTest) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/test');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.code,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Життя Програміста',
              style: TextStyle(
                fontSize: 32,
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
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Звукові ефекти'),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Музика'),
            value: _musicEnabled,
            onChanged: (value) {
              setState(() {
                _musicEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Вібрація'),
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Пройти тест заново'),
            leading: const Icon(Icons.quiz),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/test');
            },
          ),
          ListTile(
            title: const Text('Скинути прогрес'),
            leading: const Icon(Icons.refresh),
            onTap: () {
              _showResetConfirmationDialog();
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Зберегти'),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Скинути прогрес?'),
        content: const Text('Ви впевнені, що хочете скинути весь прогрес гри? Цю дію неможливо скасувати.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.resetAll();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/test');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Скинути'),
          ),
        ],
      ),
    );
  }
}