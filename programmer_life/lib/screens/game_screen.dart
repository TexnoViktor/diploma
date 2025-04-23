// File: screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../providers/game_state_provider.dart';
import '../widgets/resource_indicator.dart';
import '../widgets/qte_dialog.dart';
import '../widgets/pause_menu.dart';
import '../widgets/workplace_tab.dart';
import '../widgets/break_room_tab.dart';
import '../widgets/conference_room_tab.dart';
import '../widgets/coding_challenge.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  Timer? _eventTimer;
  Timer? _timerUpdateTimer;
  List<String> _eventLog = [];
  bool _isWorking = false;
  bool _coffeeBreakActive = false;
  Timer? _coffeeBreakTimer;
  String _formattedTime = "6:00";
  
  // Tab controller
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    _initGame();
    _startTimerUpdates();
  }
  
  void _handleTabChange() {
    // When changing tabs, pause any ongoing work
    if (_isWorking && _tabController.index != 0) {
      setState(() {
        _isWorking = false;
      });
      _addToEventLog('Ви тимчасово припинили писати код.');
    }
  }
  
  void _initGame() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    // Start a new day if game is not already active
    if (!gameState.isGameActive) {
      gameState.startNewDay();
    }
    
    // Start event timer - random events occur periodically
    _startEventTimer();
    
    // Add initial event log
    _addToEventLog('День ${gameState.currentDay} почався! Ви на стадії ${_getStageTitle(gameState.currentStage)}.');
  }
  
  void _startTimerUpdates() {
    // Update timer every second
    _timerUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final gameState = Provider.of<GameStateProvider>(context, listen: false);
      
      if (gameState.isGameActive && !gameState.isPaused) {
        gameState.updateRemainingTime();
        
        // Format time as MM:SS
        final minutes = (gameState.remainingSeconds / 60).floor();
        final seconds = gameState.remainingSeconds % 60;
        setState(() {
          _formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
        });
        
        // Check if time is up
        if (gameState.remainingSeconds <= 0) {
          _endDay(false, "Час вийшов!");
        }
      }
    });
  }
  
  String _getStageTitle(CareerStage stage) {
    switch (stage) {
      case CareerStage.Junior:
        return 'Junior розробник';
      case CareerStage.Middle:
        return 'Middle розробник';
      case CareerStage.Senior:
        return 'Senior розробник';
      default:
        return '';
    }
  }
  
  void _startEventTimer() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    // Event frequency depends on career stage
    int minInterval = 15; // seconds
    int maxInterval = 30; // seconds
    
    switch (gameState.currentStage) {
      case CareerStage.Junior:
        minInterval = 20;
        maxInterval = 40;
        break;
      case CareerStage.Middle:
        minInterval = 15;
        maxInterval = 30;
        break;
      case CareerStage.Senior:
        minInterval = 10;
        maxInterval = 20;
        break;
    }
    
    // Schedule next event
    _eventTimer?.cancel();
    _eventTimer = Timer(
      Duration(seconds: minInterval + Random().nextInt(maxInterval - minInterval)),
      _triggerRandomEvent,
    );
  }
  
  void _triggerRandomEvent() {
    if (!mounted) return;
    
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    // Don't trigger events if game is paused or on coffee break
    if (gameState.isPaused || _coffeeBreakActive) {
      _startEventTimer();
      return;
    }
    
    final random = Random();
    
    // Select random event based on probabilities
    final eventRoll = random.nextDouble();
    
    if (_tabController.index == 0) {
      // Events for workplace
      if (eventRoll < 0.4) {
        // Critical error (40% chance)
        _showCriticalErrorEvent();
      } else if (eventRoll < 0.7) {
        // Meeting notification (30% chance)
        _showMeetingNotification();
      } else {
        // Coffee break notification (30% chance)
        _showBreakRoomNotification();
      }
    }
    
    // Schedule next event
    _startEventTimer();
  }
  
  void _showCriticalErrorEvent() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    // Increase stress
    gameState.updateStress(20);
    // Перевірка умов закінчення гри після збільшення стресу
    _checkGameConditions();
    
    // Stop progress for 10 seconds
    setState(() {
      _isWorking = false;
      _addToEventLog('🐛 Критична помилка! Ви не можете писати код 10 секунд.');
    });
    
    // If at Middle or Senior level, show QTE mini-game
    if (gameState.currentStage != CareerStage.Junior) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => QTEDialog(
          title: 'Виправте помилку!',
          onComplete: () {
            gameState.updateStress(-10); // Reduce stress if completed
            _addToEventLog('✅ Ви успішно виправили помилку!');
            // Перевірка умов закінчення гри після зменшення стресу
            _checkGameConditions();
            Timer(Duration(seconds: 2), () {
              setState(() {
                _isWorking = true;
              });
            });
          },
          onFail: () {
            gameState.updateStress(10); // Increase stress if failed
            _addToEventLog('❌ Не вдалося виправити помилку вчасно!');
            // Перевірка умов закінчення гри після збільшення стресу
            _checkGameConditions();
            Timer(Duration(seconds: 10), () {
              setState(() {
                _isWorking = true;
              });
            });
          },
          difficulty: gameState.currentStage == CareerStage.Senior ? 'hard' : 'normal',
        ),
      );
    } else {
      // For Junior, automatically resume after 10 seconds
      Timer(Duration(seconds: 10), () {
        setState(() {
          _isWorking = true;
          _addToEventLog('Помилку виправлено, можна продовжувати роботу.');
        });
      });
    }
  }
  
  void _showMeetingNotification() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('Сповіщення'),
        content: Text('У конференц-залі ваші колеги проводять мітинг. Ви можете приєднатися і допомогти їм.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Потім'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Switch to the conference room tab
              _tabController.animateTo(2);
            },
            child: Text('Перейти до конференц-зали'),
          ),
        ],
      ),
    );
  }
  
  void _showBreakRoomNotification() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('Сповіщення'),
        content: Text('Ви відчуваєте втому. Перейдіть до кімнати відпочинку, щоб відновити енергію.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Потім'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Switch to the break room tab
              _tabController.animateTo(1);
            },
            child: Text('Перейти до кімнати відпочинку'),
          ),
        ],
      ),
    );
  }
  
  void _startCoffeeBreak(int duration, double energyBoost, double stressReduction) {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    setState(() {
      _coffeeBreakActive = true;
      _isWorking = false;
      _addToEventLog('☕ Перерва розпочата. Відпочиньте $duration секунд.');
    });
    
    _coffeeBreakTimer?.cancel();
    _coffeeBreakTimer = Timer(Duration(seconds: duration), () {
      if (mounted) {
        setState(() {
          _coffeeBreakActive = false;
          gameState.updateEnergy(energyBoost);
          gameState.updateStress(stressReduction);
          _addToEventLog('✅ Перерва завершена. +$energyBoost% енергії, ${stressReduction < 0 ? "" : "+"}$stressReduction% стресу!');
          
          // Перевірка умов закінчення гри після завершення перерви
          _checkGameConditions();
        });
      }
    });
  }
  
  void _showPauseMenu() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    gameState.pauseGame();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PauseMenu(
        onResume: () {
          gameState.resumeGame();
          Navigator.of(context).pop();
        },
        onRestart: () {
          Navigator.of(context).pop();
          _restartDay();
        },
        onExit: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop(); // Return to level selection
        },
        availablePowerups: gameState.availablePowerups,
        onUsePowerup: (PowerupType powerupType) {
          gameState.usePowerup(powerupType);
          _addToEventLog(_getPowerupMessage(powerupType));
          
          // Перевірка умов закінчення гри після використання пауерапу
          _checkGameConditions();
          
          Navigator.of(context).pop();
          gameState.resumeGame();
        },
      ),
    );
  }
  
  String _getPowerupMessage(PowerupType powerupType) {
    switch (powerupType) {
      case PowerupType.askColleague:
        return '🧑‍💻 Ви попросили допомоги в колеги. +15% прогресу, +10% стресу.';
      case PowerupType.energyDrink:
        return '🥤 Ви випили енергетик. +30% енергії, +15% стресу.';
      case PowerupType.debuggingTool:
        return '🔧 Ви використали інструмент для дебагу. +20% прогресу, -5% енергії.';
      case PowerupType.meditation:
        return '🧘 Ви помедитували. -20% стресу, -5% енергії.';
      case PowerupType.codeReview:
        return '📝 Ви провели code review. +10% прогресу, -10% стресу.';
    }
  }
  
  void _handleCodeSubmission(bool isCorrect, int codeLength) {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    if (isCorrect) {
      // Calculate progress based on code length and career stage
      // Longer code = more progress
      double progressIncrement = (codeLength / 20.0) * 5.0; // Base progress
      
      // Adjust progress based on career stage (higher levels need more code)
      switch (gameState.currentStage) {
        case CareerStage.Junior:
          progressIncrement *= 1.2; // Easier for juniors
          break;
        case CareerStage.Middle:
          progressIncrement *= 1.0; // Standard for middle
          break;
        case CareerStage.Senior:
          progressIncrement *= 0.8; // Harder for seniors
          break;
      }
      
      // Update game state and add to event log
      gameState.updateCodeProgress(progressIncrement);
      gameState.updateEnergy(-1.0); // Writing code consumes energy
      gameState.recordCodeWritten(codeLength);
      
      // Add random success messages to event log
      final messages = [
        'Відмінно! Код прийнято.',
        'Правильно! Ви написали коректний код.',
        'Чудова робота! Рядок коду працює.',
        'Успіх! Код додано до проекту.',
      ];
      _addToEventLog(messages[Random().nextInt(messages.length)]);
    } else {
      // Incorrect code submission
      gameState.updateStress(3.0); // Increase stress
      gameState.recordCodeError();
      
      // Add error message to event log
      _addToEventLog('❌ Помилка! Неправильний код. Спробуйте ще раз.');
    }
    
    // Check win/lose conditions
    _checkGameConditions();
  }
  
  void _checkGameConditions() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    // Win condition - code progress reached 100%
    if (gameState.codeProgress >= 100) {
      _endDay(true, null);
    }
    
    // Lose conditions
    if (gameState.stress >= 100) {
      _endDay(false, "Рівень стресу досяг максимуму!");
    } else if (gameState.energy <= 0) {
      _endDay(false, "Ваша енергія вичерпалась!");
    }
  }
  
  void _endDay(bool success, String? reasonForFailure) {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    // Cancel all timers
    _eventTimer?.cancel();
    _coffeeBreakTimer?.cancel();
    
    setState(() {
      _isWorking = false;
    });
    
    // Update game state
    gameState.completeDay(success);
    
    if (success) {
      _addToEventLog('🎉 Вітаємо! Ви успішно завершили день!');
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('День завершено!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ви успішно виконали всі завдання на сьогодні.'),
              SizedBox(height: 10),
              Text('Залишилось часу: $_formattedTime'),
              SizedBox(height: 10),
              if (gameState.currentDay == 7 && gameState.currentStage == CareerStage.Senior)
                Text('🏆 Вітаємо! Ви пройшли гру повністю!', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              if (gameState.currentDay == 7 && gameState.currentStage != CareerStage.Senior)
                Text('🎓 Ви готові до підвищення!',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to level selection
              },
              child: Text('До вибору рівнів'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
                // If last day of stage, return to level selection
                if (gameState.currentDay == 7) {
                  Navigator.of(context).pop();
                } else {
                  // Move to next day and start it
                  gameState.setCurrentDay(gameState.currentDay + 1);
                  _startNewDay();
                }
              },
              child: Text(gameState.currentDay == 7 ? 'Завершити етап' : 'Наступний день'),
            ),
          ],
        ),
      );
    } else {
      _addToEventLog('❌ День завершено невдало. ${reasonForFailure ?? ""}');
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('День провалено!'),
          content: Text('${reasonForFailure ?? "Ви не впорались із завданням."} Спробуйте знову.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to level selection
              },
              child: Text('До вибору рівнів'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartDay();
              },
              child: Text('Спробувати знову'),
            ),
          ],
        ),
      );
    }
  }
  
  void _startNewDay() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    gameState.startNewDay();
    setState(() {
      _eventLog = [];
      _coffeeBreakActive = false;
      _isWorking = false;
      _formattedTime = "6:00";
      _addToEventLog('День ${gameState.currentDay} почався! Ви на стадії ${_getStageTitle(gameState.currentStage)}.');
    });
    
    _startEventTimer();
  }
  
  void _restartDay() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    
    gameState.startNewDay();
    setState(() {
      _eventLog = [];
      _coffeeBreakActive = false;
      _isWorking = false;
      _formattedTime = "6:00";
      _addToEventLog('День ${gameState.currentDay} почався! Спробуйте знову.');
    });
    
    _startEventTimer();
  }
  
  void _addToEventLog(String message) {
    setState(() {
      _eventLog.insert(0, message);
      
      // Keep only last 10 messages
      if (_eventLog.length > 10) {
        _eventLog = _eventLog.sublist(0, 10);
      }
    });
  }
  
  @override
  void dispose() {
    _eventTimer?.cancel();
    _coffeeBreakTimer?.cancel();
    _timerUpdateTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    
    return WillPopScope(
      onWillPop: () async {
        if (gameState.isGameActive && !gameState.isPaused) {
          _showPauseMenu();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Життя Програміста - ${_getStageTitle(gameState.currentStage)}'),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: _formattedTime.startsWith('0:') ? Colors.red : Colors.black),
                    SizedBox(width: 5),
                    Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: _formattedTime.startsWith('0:') ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: _showPauseMenu,
              tooltip: 'Пауза',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.computer),
                text: 'Робоче місце',
              ),
              Tab(
                icon: Icon(Icons.weekend),
                text: 'Кімната відпочинку',
              ),
              Tab(
                icon: Icon(Icons.groups),
                text: 'Конференц-зал',
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Resources section
            Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'День ${gameState.currentDay} з 7',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ResourceIndicator(
                            label: 'Енергія',
                            value: gameState.energy,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ResourceIndicator(
                            label: 'Стрес',
                            value: gameState.stress,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ResourceIndicator(
                            label: 'Прогрес коду',
                            value: gameState.codeProgress,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Workplace Tab with new coding challenge
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Actions and event log on the left
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Coding challenge component
                              Card(
                                elevation: 3,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Завдання:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 16),
                                      // Start working button
                                      if (!_isWorking && !_coffeeBreakActive)
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _isWorking = true;
                                            });
                                            _addToEventLog('🖥️ Ви почали писати код.');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: Text(
                                            'Почати писати код', 
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        
                                      // Coding challenge
                                      if (_isWorking || _coffeeBreakActive)
                                        CodingChallenge(
                                          isActive: _isWorking && !_coffeeBreakActive,
                                          careerStage: gameState.currentStage,
                                          onSubmit: _handleCodeSubmission,
                                        ),
                                        
                                      if (_coffeeBreakActive)
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text(
                                            'Відпочиваємо... Перерва активна.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.brown),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              // Event log
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Журнал подій:',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: _eventLog.length,
                                            itemBuilder: (context, index) => Padding(
                                              padding: EdgeInsets.only(bottom: 8.0),
                                              child: Text(_eventLog[index]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 16),
                        
                        // Workplace image on the right
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage('assets/images/workplace.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Break Room Tab with check game conditions
                  BreakRoomTab(
                    onCoffeeBreak: () {
                      _startCoffeeBreak(15, 25, 0);
                    },
                    onEnergyDrink: () {
                      _startCoffeeBreak(10, 30, 15);
                    },
                    onMeditation: () {
                      _startCoffeeBreak(20, -5, -20);
                    },
                    onSnack: () {
                      _startCoffeeBreak(5, 15, 5);
                    },
                    onPowerNap: () {
                      _startCoffeeBreak(30, 35, -10);
                    },
                    coffeeBreakActive: _coffeeBreakActive,
                    addToEventLog: _addToEventLog,
                    gameState: gameState,
                    checkGameConditions: _checkGameConditions,
                  ),
                  
                  // Conference Room Tab with check game conditions
                  ConferenceRoomTab(
                    onAskForHelp: () {
                      final gameState = Provider.of<GameStateProvider>(context, listen: false);
                      gameState.updateCodeProgress(15);
                      gameState.updateStress(10);
                      _addToEventLog('🧑‍💻 Ви попросили допомоги в колеги. +15% прогресу, +10% стресу.');
                    },
                    onHelpColleague: () {
                      final gameState = Provider.of<GameStateProvider>(context, listen: false);
                      gameState.updateCodeProgress(5);
                      gameState.updateEnergy(-10);
                      gameState.updateStress(-5);
                      _addToEventLog('👨‍👩‍👧‍👦 Ви допомогли колезі. +5% прогресу, -10% енергії, -5% стресу.');
                    },
                    onCodeReview: () {
                      final gameState = Provider.of<GameStateProvider>(context, listen: false);
                      gameState.updateCodeProgress(10);
                      gameState.updateStress(-10);
                      _addToEventLog('📝 Ви провели code review. +10% прогресу, -10% стресу.');
                    },
                    onTeamMeeting: () {
                      final gameState = Provider.of<GameStateProvider>(context, listen: false);
                      gameState.updateCodeProgress(8);
                      gameState.updateStress(5);
                      gameState.updateEnergy(-8);
                      _addToEventLog('👥 Ви взяли участь у командній нараді. +8% прогресу, +5% стресу, -8% енергії.');
                    },
                    addToEventLog: _addToEventLog,
                    gameState: gameState,
                    checkGameConditions: _checkGameConditions,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}