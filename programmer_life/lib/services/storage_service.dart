// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/career_test_model.dart';

class StorageService {
  static const String _testResultKey = 'career_test_result';
  static const String _gameProgressKey = 'game_progress';
  static const String _hasCompletedTestKey = 'has_completed_test';

  // Збереження результатів тесту
  static Future<void> saveTestResult(CareerTestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_testResultKey, jsonEncode({
      'scores': result.scores,
      'dominantType': result.dominantType,
      'description': result.description,
    }));
    await prefs.setBool(_hasCompletedTestKey, true);
  }

  // Отримання результатів тесту
  static Future<CareerTestResult?> getTestResult() async {
    final prefs = await SharedPreferences.getInstance();
    final resultJson = prefs.getString(_testResultKey);
    
    if (resultJson == null) {
      return null;
    }
    
    final resultMap = jsonDecode(resultJson);
    return CareerTestResult(
      scores: Map<String, int>.from(resultMap['scores']),
      dominantType: resultMap['dominantType'],
      description: resultMap['description'],
    );
  }

  // Перевірка, чи користувач вже пройшов тест
  static Future<bool> hasCompletedTest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedTestKey) ?? false;
  }

  // Збереження прогресу в грі
  static Future<void> saveGameProgress(Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameProgressKey, jsonEncode(progress));
  }

  // Отримання прогресу гри
  static Future<Map<String, dynamic>?> getGameProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_gameProgressKey);
    
    if (progressJson == null) {
      return null;
    }
    
    return Map<String, dynamic>.from(jsonDecode(progressJson));
  }

  // Скидання всіх даних (для тестування або перезапуску гри)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}