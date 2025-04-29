// File: providers/game_state_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum CareerStage { Junior, Middle, Senior }

enum PowerupType {
  askColleague,  // +15% code progress, +10% stress
  energyDrink,   // +30% energy, +15% stress
  debuggingTool, // +20% code progress, -5% energy
  meditation,    // -20% stress, -5% energy
  codeReview,    // +10% code progress, -10% stress
}

enum Location {
  workplace,
  breakRoom,
  conferenceRoom,
}

class GameStateProvider with ChangeNotifier {
  // Resources
  double _energy = 100.0;
  double _stress = 0.0;
  double _codeProgress = 0.0;
  
  // Game state
  CareerStage _currentStage = CareerStage.Junior;
  int _currentDay = 1;
  bool _isGameActive = false;
  bool _isPaused = false;
  DateTime? _levelStartTime;
  int _remainingSeconds = 360; // 6 minutes
  Location _currentLocation = Location.workplace;
  
  // Career orientation test results
  Map<String, dynamic> _testResults = {};
  bool _testCompleted = false;
  
  // Level progression
  CareerStage _highestUnlockedStage = CareerStage.Junior;
  Map<String, int> _highestUnlockedDay = {
    CareerStage.Junior.toString(): 1,
    CareerStage.Middle.toString(): 0,
    CareerStage.Senior.toString(): 0,
  };
  
  // Coding stats
  int _totalLinesOfCodeWritten = 0;
  int _codeErrorsCount = 0;
  double _typingAccuracy = 100.0; // % of typing accuracy
  
  // Powerups and interactions
  Map<PowerupType, bool> _availablePowerups = {
    PowerupType.askColleague: true,
    PowerupType.energyDrink: true,
    PowerupType.debuggingTool: true,
    PowerupType.meditation: true,
    PowerupType.codeReview: true,
  };
  
  // Cooldowns for location interactions
  Map<String, DateTime> _interactionCooldowns = {};
  
  // Getters
  double get energy => _energy;
  double get stress => _stress;
  double get codeProgress => _codeProgress;
  CareerStage get currentStage => _currentStage;
  int get currentDay => _currentDay;
  bool get isGameActive => _isGameActive;
  bool get isPaused => _isPaused;
  bool get testCompleted => _testCompleted;
  Map<String, dynamic> get testResults => _testResults;
  CareerStage get highestUnlockedStage => _highestUnlockedStage;
  int get remainingSeconds => _remainingSeconds;
  Map<PowerupType, bool> get availablePowerups => _availablePowerups;
  Location get currentLocation => _currentLocation;
  int get totalLinesOfCodeWritten => _totalLinesOfCodeWritten;
  int get codeErrorsCount => _codeErrorsCount;
  double get typingAccuracy => _typingAccuracy;
  
  // Initialize game state from shared preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _testCompleted = prefs.getBool('testCompleted') ?? false;
    
    if (_testCompleted) {
      // Load basic game state
      _currentStage = CareerStage.values[prefs.getInt('currentStage') ?? 0];
      _currentDay = prefs.getInt('currentDay') ?? 1;
      _energy = prefs.getDouble('energy') ?? 100.0;
      _stress = prefs.getDouble('stress') ?? 0.0;
      _codeProgress = prefs.getDouble('codeProgress') ?? 0.0;
      
      // Load progression data
      final highestStageIndex = prefs.getInt('highestUnlockedStage') ?? 0;
      _highestUnlockedStage = CareerStage.values[highestStageIndex];
      
      // Load highest unlocked day for each stage
      final juniorDay = prefs.getInt('highestDay_${CareerStage.Junior}') ?? 1;
      final middleDay = prefs.getInt('highestDay_${CareerStage.Middle}') ?? 0;
      final seniorDay = prefs.getInt('highestDay_${CareerStage.Senior}') ?? 0;
      
      _highestUnlockedDay = {
        CareerStage.Junior.toString(): juniorDay,
        CareerStage.Middle.toString(): middleDay,
        CareerStage.Senior.toString(): seniorDay,
      };
      
      // Load powerups
      final powerupsJson = prefs.getString('availablePowerups');
      if (powerupsJson != null) {
        final Map<String, dynamic> powerupsMap = jsonDecode(powerupsJson);
        _availablePowerups = {
          for (var entry in powerupsMap.entries)
            PowerupType.values.firstWhere((e) => e.toString() == entry.key): entry.value as bool
        };
      }
      
      // Load test results
      final testResultsJson = prefs.getString('testResults');
      if (testResultsJson != null) {
        _testResults = jsonDecode(testResultsJson);
      }
      
      // Load interaction cooldowns
      final cooldownsJson = prefs.getString('interactionCooldowns');
      if (cooldownsJson != null) {
        final Map<String, dynamic> cooldownsMap = jsonDecode(cooldownsJson);
        _interactionCooldowns = {
          for (var entry in cooldownsMap.entries)
            entry.key: DateTime.parse(entry.value as String)
        };
      }
      
      // Load coding stats
      _totalLinesOfCodeWritten = prefs.getInt('totalLinesOfCodeWritten') ?? 0;
      _codeErrorsCount = prefs.getInt('codeErrorsCount') ?? 0;
      _typingAccuracy = prefs.getDouble('typingAccuracy') ?? 100.0;
    }
    
    notifyListeners();
  }
  
  // Save current state to shared preferences
  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save basic game state
    prefs.setBool('testCompleted', _testCompleted);
    prefs.setInt('currentStage', _currentStage.index);
    prefs.setInt('currentDay', _currentDay);
    prefs.setDouble('energy', _energy);
    prefs.setDouble('stress', _stress);
    prefs.setDouble('codeProgress', _codeProgress);
    
    // Save progression data
    prefs.setInt('highestUnlockedStage', _highestUnlockedStage.index);
    prefs.setInt('highestDay_${CareerStage.Junior}', _highestUnlockedDay[CareerStage.Junior.toString()] ?? 1);
    prefs.setInt('highestDay_${CareerStage.Middle}', _highestUnlockedDay[CareerStage.Middle.toString()] ?? 0);
    prefs.setInt('highestDay_${CareerStage.Senior}', _highestUnlockedDay[CareerStage.Senior.toString()] ?? 0);
    
    // Save powerups
    final powerupsMap = {
      for (var entry in _availablePowerups.entries)
        entry.key.toString(): entry.value
    };
    prefs.setString('availablePowerups', jsonEncode(powerupsMap));
    
    // Save test results
    prefs.setString('testResults', jsonEncode(_testResults));
    
    // Save interaction cooldowns
    final cooldownsMap = {
      for (var entry in _interactionCooldowns.entries)
        entry.key: entry.value.toIso8601String()
    };
    prefs.setString('interactionCooldowns', jsonEncode(cooldownsMap));
    
    // Save coding stats
    prefs.setInt('totalLinesOfCodeWritten', _totalLinesOfCodeWritten);
    prefs.setInt('codeErrorsCount', _codeErrorsCount);
    prefs.setDouble('typingAccuracy', _typingAccuracy);
  }
  
  // Check if a specific level is unlocked
  bool isLevelUnlocked(CareerStage stage, int day) {
    if (stage.index < _highestUnlockedStage.index) {
      // All days in previous stages are unlocked
      return true;
    } else if (stage.index > _highestUnlockedStage.index) {
      // No days in future stages are unlocked
      return false;
    } else {
      // For current stage, check day against highest unlocked day
      return day <= (_highestUnlockedDay[stage.toString()] ?? 0);
    }
  }
  
  // Unlock a specific level
  void unlockLevel(CareerStage stage, int day) {
    // Update highest unlocked stage if needed
    if (stage.index > _highestUnlockedStage.index) {
      _highestUnlockedStage = stage;
    }
    
    // Update highest unlocked day for this stage if needed
    final currentHighest = _highestUnlockedDay[stage.toString()] ?? 0;
    if (day > currentHighest) {
      _highestUnlockedDay[stage.toString()] = day;
    }
    
    saveState();
    notifyListeners();
  }
  
  // Set current stage
  void setCurrentStage(CareerStage stage) {
    _currentStage = stage;
    saveState();
    notifyListeners();
  }
  
  // Set current day
  void setCurrentDay(int day) {
    _currentDay = day;
    saveState();
    notifyListeners();
  }
  
  // Set current location
  void setCurrentLocation(Location location) {
    _currentLocation = location;
    notifyListeners();
  }
  
  // Check if an interaction is on cooldown
  bool isInteractionOnCooldown(String interactionId) {
    final cooldownEnd = _interactionCooldowns[interactionId];
    if (cooldownEnd == null) {
      return false;
    }
    
    return DateTime.now().isBefore(cooldownEnd);
  }
  
  // Set interaction cooldown
  void setInteractionCooldown(String interactionId, int cooldownMinutes) {
    _interactionCooldowns[interactionId] = DateTime.now().add(Duration(minutes: cooldownMinutes));
    saveState();
    notifyListeners();
  }
  
  // Game mechanics
  
  // Update code progress based on the code submitted
  void updateCodeProgress(double amount) {
    _codeProgress += amount;
    
    // Ensure progress doesn't exceed 100%
    if (_codeProgress > 100) _codeProgress = 100;
    
    saveState();
    notifyListeners();
  }
  
  // Record a successfully written line of code
  void recordCodeWritten(int lineLength) {
    _totalLinesOfCodeWritten += 1;
    
    // Typing longer code lines is more tiring
    double energyDecrease = (lineLength / 20.0) * 0.5;
    _energy -= energyDecrease;
    if (_energy < 0) _energy = 0;
    
    saveState();
    notifyListeners();
  }
  
  // Record a code error
  void recordCodeError() {
    _codeErrorsCount += 1;
    
    // Update typing accuracy
    if (_totalLinesOfCodeWritten > 0) {
      int totalAttempts = _totalLinesOfCodeWritten + _codeErrorsCount;
      _typingAccuracy = (_totalLinesOfCodeWritten / totalAttempts) * 100;
    }
    
    saveState();
    notifyListeners();
  }
  
  void updateStress(double amount) {
    _stress += amount;
    
    // Ensure stress stays within bounds
    if (_stress < 0) _stress = 0;
    if (_stress > 100) _stress = 100;
    
    saveState();
    notifyListeners();
  }
  
  void updateEnergy(double amount) {
    _energy += amount;
    
    // Ensure energy stays within bounds
    if (_energy < 0) _energy = 0;
    if (_energy > 100) _energy = 100;
    
    saveState();
    notifyListeners();
  }
  
  void startNewDay() {
    _energy = 100.0;
    _stress = 0.0;
    _codeProgress = 0.0;
    _isGameActive = true;
    _isPaused = false;
    _remainingSeconds = 360; // 6 minutes
    _levelStartTime = DateTime.now();
    _currentLocation = Location.workplace;
    
    // Reset powerups for the day
    _availablePowerups = {
      PowerupType.askColleague: true,
      PowerupType.energyDrink: true,
      PowerupType.debuggingTool: true,
      PowerupType.meditation: true,
      PowerupType.codeReview: true,
    };
    
    // Reset interaction cooldowns
    _interactionCooldowns = {};
    
    saveState();
    notifyListeners();
  }
  
  void pauseGame() {
    if (_isGameActive && !_isPaused) {
      _isPaused = true;
      
      // Calculate time remaining
      if (_levelStartTime != null) {
        final elapsedSeconds = DateTime.now().difference(_levelStartTime!).inSeconds;
        _remainingSeconds = 360 - elapsedSeconds;
        if (_remainingSeconds < 0) _remainingSeconds = 0;
      }
      
      saveState();
      notifyListeners();
    }
  }
  
  void resumeGame() {
    if (_isGameActive && _isPaused) {
      _isPaused = false;
      _levelStartTime = DateTime.now().subtract(Duration(seconds: 360 - _remainingSeconds));
      
      saveState();
      notifyListeners();
    }
  }
  
  void updateRemainingTime() {
    if (_isGameActive && !_isPaused && _levelStartTime != null) {
      final elapsedSeconds = DateTime.now().difference(_levelStartTime!).inSeconds;
      _remainingSeconds = 360 - elapsedSeconds;
      
      // Ensure time doesn't go negative
      if (_remainingSeconds < 0) _remainingSeconds = 0;
      
      // Check for time's up condition
      if (_remainingSeconds <= 0) {
        _isGameActive = false;
        notifyListeners();
        return;
      }
      
      notifyListeners();
    }
  }
  
  void completeDay(bool success) {
    _isGameActive = false;
    
    if (success) {
      // Unlock next day
      if (_currentDay < 7) {
        unlockLevel(_currentStage, _currentDay + 1);
      } else if (_currentStage != CareerStage.Senior) {
        // If completed all days in current stage, unlock first day of next stage
        final nextStageIndex = _currentStage.index + 1;
        if (nextStageIndex < CareerStage.values.length) {
          final nextStage = CareerStage.values[nextStageIndex];
          unlockLevel(nextStage, 1);
        }
      }
    }
    
    saveState();
    notifyListeners();
  }
  
  void usePowerup(PowerupType powerup) {
    if (_availablePowerups[powerup] != true) return;
    
    switch (powerup) {
      case PowerupType.askColleague:
        _codeProgress += 15;
        updateStress(10);
        break;
      case PowerupType.energyDrink:
        updateEnergy(30);
        updateStress(15);
        break;
      case PowerupType.debuggingTool:
        _codeProgress += 20;
        updateEnergy(-5);
        break;
      case PowerupType.meditation:
        updateStress(-20);
        updateEnergy(-5);
        break;
      case PowerupType.codeReview:
        _codeProgress += 10;
        updateStress(-10);
        break;
    }
    
    // Ensure code progress doesn't exceed 100%
    if (_codeProgress > 100) _codeProgress = 100;
    
    // Mark powerup as used
    _availablePowerups[powerup] = false;
    
    saveState();
    notifyListeners();
  }
  
  // Location-specific functions
  
   void drinkCoffee() {
    if (!isInteractionOnCooldown('coffee')) {
      updateEnergy(25);
      setInteractionCooldown('coffee', 15); // 15 minutes cooldown
      saveState();
      notifyListeners();
    }
  }
  
  void drinkEnergyDrink() {
    if (!isInteractionOnCooldown('energyDrink')) {
      updateEnergy(30);
      updateStress(15);
      setInteractionCooldown('energyDrink', 30); // 30 minutes cooldown
      saveState();
      notifyListeners();
    }
  }
  
  void doMeditation() {
    if (!isInteractionOnCooldown('meditation')) {
      updateStress(-20);
      updateEnergy(-5);
      setInteractionCooldown('meditation', 20); // 20 minutes cooldown
      saveState();
      notifyListeners();
    }
  }
  
  void helpColleague() {
    if (!isInteractionOnCooldown('helpColleague')) {
      _codeProgress += 5;
      updateEnergy(-10);
      updateStress(-5);
      setInteractionCooldown('helpColleague', 10); // 10 minutes cooldown
      saveState();
      notifyListeners();
    }
  }
  
  void attendMeeting() {
    if (!isInteractionOnCooldown('meeting')) {
      _codeProgress += 8;
      updateStress(5);
      updateEnergy(-8);
      setInteractionCooldown('meeting', 20); // 20 minutes cooldown
      saveState();
      notifyListeners();
    }
  }
  
  void setTestCompleted(Map<String, dynamic> results) {
    _testCompleted = true;
    _testResults = results;
    saveState();
    notifyListeners();
  }
  
  void resetAllProgress() {
    _energy = 100.0;
    _stress = 0.0;
    _codeProgress = 0.0;
    _currentStage = CareerStage.Junior;
    _currentDay = 1;
    _isGameActive = false;
    _isPaused = false;
    _highestUnlockedStage = CareerStage.Junior;
    _highestUnlockedDay = {
      CareerStage.Junior.toString(): 1,
      CareerStage.Middle.toString(): 0,
      CareerStage.Senior.toString(): 0,
    };
    _testCompleted = false;
    _testResults = {};
    _availablePowerups = {
      PowerupType.askColleague: true,
      PowerupType.energyDrink: true,
      PowerupType.debuggingTool: true,
      PowerupType.meditation: true,
      PowerupType.codeReview: true,
    };
    _interactionCooldowns = {};
    _totalLinesOfCodeWritten = 0;
    _codeErrorsCount = 0;
    _typingAccuracy = 100.0;
    
    saveState();
    notifyListeners();
  }
  
  // Get player statistics for current game
  Map<String, dynamic> getGameStats() {
    return {
      'stage': _currentStage.toString().split('.').last,
      'day': _currentDay,
      'totalLinesOfCode': _totalLinesOfCodeWritten,
      'codeErrors': _codeErrorsCount,
      'typingAccuracy': _typingAccuracy.toStringAsFixed(1) + '%',
      'remainingTime': '${(_remainingSeconds / 60).floor()}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
      'energy': _energy.toStringAsFixed(1) + '%',
      'stress': _stress.toStringAsFixed(1) + '%',
      'codeProgress': _codeProgress.toStringAsFixed(1) + '%',
    };
  }
}