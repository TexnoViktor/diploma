// lib/game/programmer_life_game.dart
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'game_state.dart';
import 'components/office_map.dart';
import 'components/player.dart';
import 'components/resource_bar.dart';
import 'components/interactive_zone.dart';

class ProgrammerLifeGame extends FlameGame with TapCallbacks, DragCallbacks, HasCollisionDetection {
  late final GameState gameState;
  late final Player player;
  late final OfficeMap officeMap;
  late final JoystickComponent joystick;
  late final CameraComponent cameraComponent;
  
  // Ресурсні індикатори
  late final ResourceBar energyBar;
  late final ResourceBar stressBar;
  late final ResourceBar codeProgressBar;
  
  // Інтерактивні зони
  late final InteractiveZone workplaceZone;
  late final InteractiveZone restRoomZone;
  late final InteractiveZone conferenceRoomZone;
  
  // Таймер рівня
  late final Timer levelTimer;
  late final Timer randomEventTimer;
  
  final String playerType; // Тип гравця з профорієнтаційного тесту
  
  ProgrammerLifeGame({required this.playerType}) {
    gameState = GameState(playerType: playerType);
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Налаштування камери
    cameraComponent = CameraComponent(world: world)
      ..viewfinder.anchor = Anchor.center;
    addAll([cameraComponent, world]);
    
    // Завантаження карти офісу
    officeMap = OfficeMap();
    await world.add(officeMap);
    
    // Створення гравця
    player = Player(playerType: playerType);
    await world.add(player);
    
    // Налаштування камери для слідкування за гравцем
    cameraComponent.follow(player);
    
    // Додавання інтерактивних зон
    workplaceZone = InteractiveZone(
      position: Vector2(200, 200),
      size: Vector2(100, 100),
      zoneName: 'Робоче місце',
      onInteract: _onWorkplaceInteract,
    );
    
    restRoomZone = InteractiveZone(
      position: Vector2(400, 200),
      size: Vector2(100, 100),
      zoneName: 'Кімната відпочинку',
      onInteract: _onRestRoomInteract,
    );
    
    conferenceRoomZone = InteractiveZone(
      position: Vector2(600, 200),
      size: Vector2(100, 100),
      zoneName: 'Конференц-зал',
      onInteract: _onConferenceRoomInteract,
    );
    
    await world.addAll([workplaceZone, restRoomZone, conferenceRoomZone]);
    
    // Створення ресурсних індикаторів
    energyBar = ResourceBar(
      position: Vector2(10, 10),
      size: Vector2(150, 20),
      maxValue: 100,
      currentValue: gameState.energy,
      color: Colors.blue,
      label: 'Енергія',
    );
    
    stressBar = ResourceBar(
      position: Vector2(10, 40),
      size: Vector2(150, 20),
      maxValue: 100,
      currentValue: gameState.stress,
      color: Colors.red,
      label: 'Стрес',
    );
    
    codeProgressBar = ResourceBar(
      position: Vector2(10, 70),
      size: Vector2(150, 20),
      maxValue: 100,
      currentValue: gameState.codeProgress,
      color: Colors.green,
      label: 'Прогрес',
    );
    
    camera.viewport.add(energyBar);
    camera.viewport.add(stressBar);
    camera.viewport.add(codeProgressBar);
    
    // Налаштування таймера рівня (8 хвилин = 480 секунд)
    levelTimer = Timer(480.0, onTick: _onTimerTick, repeat: false);
    
    // Створення джойстика для переміщення на мобільних пристроях
    final knobPaint = Paint()..color = Colors.blue.withOpacity(0.5);
    final backgroundPaint = Paint()..color = Colors.blue.withOpacity(0.2);
    
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(bottom: 40, left: 40),
    );
    
    camera.viewport.add(joystick);
    
    // Запускаємо таймер випадкових подій
    _setupRandomEvents();
  }
  
  @override
void update(double dt) {
  super.update(dt);
  
  levelTimer.update(dt);
  randomEventTimer.update(dt); // Додаємо оновлення таймера випадкових подій
  
  // Оновлення руху гравця на основі джойстика
  if (joystick.direction != JoystickDirection.idle) {
    player.move(joystick.relativeDelta * player.moveSpeed * dt);
  }
  
  // Оновлення ресурсних індикаторів
  energyBar.currentValue = gameState.energy;
  stressBar.currentValue = gameState.stress;
  codeProgressBar.currentValue = gameState.codeProgress;
  
  // Оновлення стану гри (додаємо цей виклик)
  gameState.update(dt);
  
  // Перевірка умов перемоги/поразки
  _checkGameConditions();
}
  
  void _onTimerTick() {
    // Коли таймер рівня закінчується, енергія починає витрачатись додатково
    gameState.startExtraEnergyDrain();
  }
  
  void _setupRandomEvents() {
  // Налаштування випадкових подій (кожні 2-3 хвилини)
  randomEventTimer = Timer(
    120 + (60 * gameState.random.nextDouble()),
    onTick: _triggerRandomEvent,
    repeat: true,
  );
  
  // Не додаємо таймер через add(), бо Timer не є компонентом
  // Замість цього, ми будемо його оновлювати в методі update()
}
  
  void _triggerRandomEvent() {
    // Після закінчення основного часу випадкові події не відбуваються
    if (levelTimer.isRunning()) {
      final eventType = gameState.random.nextInt(3);
      
      switch (eventType) {
        case 0:
          // Технічна поломка
          gameState.triggerTechnicalProblem();
          break;
        case 1:
          // Допомога колезі
          gameState.triggerHelpColleague();
          break;
        case 2:
          // Несподіваний дедлайн
          gameState.triggerSuddenDeadline();
          levelTimer.limit -= 120; // Відняти 2 хвилини від таймера
          break;
      }
    }
  }
  
  void _checkGameConditions() {
    // Перевірка умов перемоги
    if (gameState.codeProgress >= 100) {
      // Перемога!
      pauseEngine();
      gameState.completeCurrentDay();
      overlays.add('levelCompleteOverlay');
    }
    
    // Перевірка умов поразки
    if (gameState.energy <= 0 || gameState.stress >= 100) {
      // Поразка!
      pauseEngine();
      overlays.add('gameOverOverlay');
    }
  }
  
  void _onWorkplaceInteract() {
    // Робота за комп'ютером - витрачає енергію, але збільшує прогрес коду
    gameState.writeCode();
  }
  
  void _onRestRoomInteract() {
    // Відпочинок - відновлює енергію або зменшує стрес
    gameState.takeRest();
  }
  
  void _onConferenceRoomInteract() {
    // Нарада - витрачає енергію, збільшує стрес
    gameState.attendMeeting();
  }
  
  // Перезапуск рівня
  void restartLevel() {
    gameState.resetDay();
    resumeEngine();
    overlays.remove('gameOverOverlay');
  }
  
  // Перехід до наступного рівня
  void nextLevel() {
    gameState.moveToNextDay();
    resumeEngine();
    overlays.remove('levelCompleteOverlay');
  }
}