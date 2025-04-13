// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/programmer_life_game.dart';
import '../services/storage_service.dart';
import '../game/game_state.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ProgrammerLifeGame _game;
  String? _playerType;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPlayerType();
  }
  
  Future<void> _loadPlayerType() async {
    final testResult = await StorageService.getTestResult();
    setState(() {
      _playerType = testResult?.dominantType ?? 'backend';
      _isLoading = false;
    });
    _initializeGame();
  }
  
  void _initializeGame() {
    _game = ProgrammerLifeGame(playerType: _playerType!);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: GameWidget<ProgrammerLifeGame>(
        game: _game,
        overlayBuilderMap: {
          'pauseButton': _buildPauseButton,
          'gameOverOverlay': _buildGameOverOverlay,
          'levelCompleteOverlay': _buildLevelCompleteOverlay,
          'dayInfoOverlay': _buildDayInfoOverlay,
        },
        initialActiveOverlays: const ['pauseButton', 'dayInfoOverlay'],
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, error) => Center(
          child: Text(
            'Сталася помилка: $error',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPauseButton(BuildContext context, ProgrammerLifeGame game) {
    return Positioned(
      top: 10,
      right: 10,
      child: ElevatedButton(
        onPressed: () {
          game.pauseEngine();
          _showPauseMenu(context, game);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
        ),
        child: const Icon(Icons.pause),
      ),
    );
  }
  
  Widget _buildGameOverOverlay(BuildContext context, ProgrammerLifeGame game) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Гра завершена!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'На жаль, ви не змогли виконати робочий день.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      game.restartLevel();
                    },
                    child: const Text('Спробувати знову'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Вийти в меню'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLevelCompleteOverlay(BuildContext context, ProgrammerLifeGame game) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Рівень пройдено!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ви успішно завершили день ${game.gameState.currentDay - 1}!',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _getLevelCompleteMessage(game),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.nextLevel();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Продовжити'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDayInfoOverlay(BuildContext context, ProgrammerLifeGame game) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getCareerLevelName(game.gameState.careerLevel),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'День ${game.gameState.currentDay} / 7',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getCareerLevelName(CareerLevel level) {
    switch (level) {
      case CareerLevel.junior:
        return 'Junior Developer';
      case CareerLevel.middle:
        return 'Middle Developer';
      case CareerLevel.senior:
        return 'Senior Developer';
      default:
        return 'Developer';
    }
  }
  
  String _getLevelCompleteMessage(ProgrammerLifeGame game) {
    if (game.gameState.currentDay == 1) {
      switch (game.gameState.careerLevel) {
        case CareerLevel.junior:
          return 'Ви почали кар\'єру Junior розробника!';
        case CareerLevel.middle:
          return 'Вітаємо з підвищенням до Middle розробника!';
        case CareerLevel.senior:
          return 'Вітаємо з підвищенням до Senior розробника!';
        default:
          return '';
      }
    }
    return 'Завтра на вас чекають нові виклики!';
  }
  
  void _showPauseMenu(BuildContext context, ProgrammerLifeGame game) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Пауза'),
        content: const Text('Гра призупинена. Що бажаєте зробити?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              game.resumeEngine();
            },
            child: const Text('Продовжити'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              game.restartLevel();
            },
            child: const Text('Перезапустити день'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Вийти в меню'),
          ),
        ],
      ),
    );
  }
}