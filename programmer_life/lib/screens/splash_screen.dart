import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }
  
  Future<void> _checkFirstRun() async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    await gameState.initialize();
    
    // Navigate to appropriate screen based on whether the orientation test is completed
    Future.delayed(Duration(seconds: 2), () {
      if (gameState.testCompleted) {
        Navigator.pushReplacementNamed(context, '/main_menu');
      } else {
        Navigator.pushReplacementNamed(context, '/orientation_test');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[600]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Життя Програміста',
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Симулятор життя розробника',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}