// lib/game/components/player.dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent with CollisionCallbacks, HasGameRef {
  final String playerType;
  final double moveSpeed = 300.0;
  
  Player({required this.playerType}) : super(size: Vector2(32, 32));
  
  @override
  Future<void> onLoad() async {
    // Завантаження спрайту гравця залежно від типу (з профорієнтаційного тесту)
    String spritePath;
    switch (playerType) {
      case 'backend':
        spritePath = 'player_backend.png';
        break;
      case 'frontend':
        spritePath = 'player_frontend.png';
        break;
      case 'devops':
        spritePath = 'player_devops.png';
        break;
      default:
        spritePath = 'player_default.png';
        break;
    }
    
    // Тимчасово використовуємо простий прямокутник, поки не додали спрайти
    // sprite = await gameRef.loadSprite(spritePath);
    
    // Додаємо компонент колізії
    add(RectangleHitbox());
    
    position = Vector2(100, 100); // Початкова позиція
    anchor = Anchor.center;
  }
  
  @override
  void render(Canvas canvas) {
    // Тимчасове відображення гравця як кольоровий прямокутник (поки немає спрайтів)
    Color playerColor;
    switch (playerType) {
      case 'backend':
        playerColor = Colors.blue;
        break;
      case 'frontend':
        playerColor = Colors.orange;
        break;
      case 'devops':
        playerColor = Colors.green;
        break;
      default:
        playerColor = Colors.grey;
        break;
    }
    
    final paint = Paint()..color = playerColor;
    canvas.drawRect(size.toRect(), paint);
    
    super.render(canvas);
  }
  
  void move(Vector2 delta) {
    position.add(delta);
  }
}

