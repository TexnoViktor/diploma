// lib/game/game_state.dart
import 'dart:math';
import '../services/storage_service.dart';

// Рівні кар'єри
enum CareerLevel {
  junior,
  middle,
  senior,
}

class GameState {
  // Базові ресурси
  double energy = 100;
  double stress = 0;
  double codeProgress = 0;
  
  // Поточний рівень гри
  CareerLevel careerLevel = CareerLevel.junior;
  int currentDay = 1;
  
  // Множники для різних рівнів кар'єри
  double energyDrainMultiplier = 1.0;
  double stressGainMultiplier = 1.0;
  double progressGainMultiplier = 1.0;
  
  // Параметри ігрового балансу
  final double baseEnergyDrain = 0.1;
  final double baseStressGain = 0.1;
  final double baseProgressGain = 1.0;
  
  // Статус додаткового витрачання енергії (після закінчення таймера)
  bool extraEnergyDrainActive = false;
  final double extraEnergyDrainAmount = 1.0; // % в секунду
  
  // Генератор випадкових чисел
  final Random random = Random();
  
  // Тип гравця з профорієнтаційного тесту
  final String playerType;
  
  GameState({required this.playerType}) {
    _initializeMultipliers();
    _loadGameState();
  }
  
  // Ініціалізація множників на основі типу гравця та рівня кар'єри
  void _initializeMultipliers() {
    // Базові множники на основі типу гравця
    switch (playerType) {
      case 'backend':
        progressGainMultiplier = 1.2; // Кращий прогрес коду
        stressGainMultiplier = 0.9;  // Менший стрес
        break;
      case 'frontend':
        energyDrainMultiplier = 0.9; // Менше витрачання енергії
        progressGainMultiplier = 1.1; // Трохи кращий прогрес
        break;
      case 'devops':
        stressGainMultiplier = 0.8; // Значно менший стрес
        energyDrainMultiplier = 1.1; // Трохи більше витрачання енергії
        break;
      default:
        // Збалансовані налаштування за замовчуванням
        break;
    }
    
    // Додаткові модифікатори на основі рівня кар'єри
    switch (careerLevel) {
      case CareerLevel.junior:
        // Стандартні налаштування для молодшого рівня
        break;
      case CareerLevel.middle:
        // Середній рівень - кращий прогрес, але більше стресу
        progressGainMultiplier *= 1.2;
        stressGainMultiplier *= 1.1;
        break;
      case CareerLevel.senior:
        // Старший рівень - найкращий прогрес, але більше витрат енергії
        progressGainMultiplier *= 1.5;
        energyDrainMultiplier *= 1.2;
        stressGainMultiplier *= 1.2;
        break;
    }
  }
  
  // Зберігання стану гри
  Future<void> saveGameState() async {
    final gameProgress = {
      'energy': energy,
      'stress': stress,
      'codeProgress': codeProgress,
      'careerLevel': careerLevel.index,
      'currentDay': currentDay,
    };
    
    await StorageService.saveGameProgress(gameProgress);
  }
  
  // Завантаження стану гри
  Future<void> _loadGameState() async {
    final gameProgress = await StorageService.getGameProgress();
    
    if (gameProgress != null) {
      energy = gameProgress['energy'];
      stress = gameProgress['stress'];
      codeProgress = gameProgress['codeProgress'];
      careerLevel = CareerLevel.values[gameProgress['careerLevel']];
      currentDay = gameProgress['currentDay'];
      
      // Оновлення множників після завантаження рівня кар'єри
      _initializeMultipliers();
    }
  }
  
  // Написання коду - основна дія на робочому місці
  void writeCode() {
    // Витрачаємо енергію
    energy -= 5.0 * energyDrainMultiplier;
    
    // Збільшуємо прогрес
    codeProgress += 10.0 * progressGainMultiplier;
    
    // Невеликий приріст стресу
    stress += 2.0 * stressGainMultiplier;
    
    _normalizeResources();
  }
  
  // Відпочинок - відновлює енергію або зменшує стрес
  void takeRest() {
    // Відновлюємо енергію
    energy += 20.0;
    
    // Зменшуємо стрес
    stress -= 30.0;
    
    _normalizeResources();
  }
  
  // Участь у нараді
  void attendMeeting() {
    // Витрачаємо енергію
    energy -= 10.0 * energyDrainMultiplier;
    
    // Збільшуємо стрес
    stress += 15.0 * stressGainMultiplier;
    
    // Невеликий приріст прогресу (обговорення проекту)
    codeProgress += 5.0 * progressGainMultiplier;
    
    _normalizeResources();
  }
  
  // Технічна проблема (випадкова подія)
  void triggerTechnicalProblem() {
    energy -= 15.0 * energyDrainMultiplier;
    stress += 20.0 * stressGainMultiplier;
    
    _normalizeResources();
  }
  
  // Допомога колезі (випадкова подія)
  void triggerHelpColleague() {
    energy -= 10.0 * energyDrainMultiplier;
    
    // Невеликий бонус до прогресу (вивчили щось нове)
    codeProgress += 5.0 * progressGainMultiplier;
    
    _normalizeResources();
  }
  
  // Несподіваний дедлайн (випадкова подія)
  void triggerSuddenDeadline() {
    // Великий приріст до прогресу коду (працюємо швидше)
    codeProgress += 40.0 * progressGainMultiplier;
    
    // Але і значний приріст стресу
    stress += 25.0 * stressGainMultiplier;
    
    _normalizeResources();
  }
  
  // Активація додаткового витрачання енергії (після закінчення таймера)
  void startExtraEnergyDrain() {
    extraEnergyDrainActive = true;
  }
  
  // Оновлення стану гри (викликається кожен кадр)
  void update(double dt) {
    // Базове витрачання ресурсів
    energy -= baseEnergyDrain * energyDrainMultiplier * dt;
    stress += baseStressGain * stressGainMultiplier * dt;
    
    // Додаткове витрачання енергії, якщо активовано
    if (extraEnergyDrainActive) {
      energy -= extraEnergyDrainAmount * dt;
    }
    
    _normalizeResources();
  }
  
  // Нормалізація ресурсів (щоб не виходили за межі 0-100%)
  void _normalizeResources() {
    energy = energy.clamp(0.0, 100.0);
    stress = stress.clamp(0.0, 100.0);
    codeProgress = codeProgress.clamp(0.0, 100.0);
  }
  
  // Завершення поточного дня
  void completeCurrentDay() {
    currentDay++;
    
    // Перехід до наступного рівня кар'єри, якщо пройшли 7 днів
    if (currentDay > 7) {
      currentDay = 1;
      
      switch (careerLevel) {
        case CareerLevel.junior:
          careerLevel = CareerLevel.middle;
          break;
        case CareerLevel.middle:
          careerLevel = CareerLevel.senior;
          break;
        case CareerLevel.senior:
          // Гра пройдена, залишаємось на Senior рівні
          break;
      }
      
      // Оновлення множників для нового рівня
      _initializeMultipliers();
    }
    
    // Скидання ресурсів для нового дня
    resetDay();
    
    // Зберігаємо прогрес гри
    saveGameState();
  }
  
  // Скидання ресурсів для нового дня
  void resetDay() {
    energy = 100.0;
    stress = 0.0;
    codeProgress = 0.0;
    extraEnergyDrainActive = false;
  }
  
  // Перехід до наступного дня
  void moveToNextDay() {
    completeCurrentDay();
  }
  
  // Скидання всього прогресу гри
  Future<void> resetProgress() async {
    careerLevel = CareerLevel.junior;
    currentDay = 1;
    resetDay();
    _initializeMultipliers();
    
    await StorageService.resetAll();
  }
}