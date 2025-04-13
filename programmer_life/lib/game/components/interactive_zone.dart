// lib/game/components/interactive_zone.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class InteractiveZone extends PositionComponent with TapCallbacks {
  final String zoneName;
  final Function onInteract;
  
  InteractiveZone({
    required Vector2 position,
    required Vector2 size,
    required this.zoneName,
    required this.onInteract,
  }) : super(position: position, size: size);
  
  @override
  bool onTapDown(TapDownEvent event) {
    onInteract();
    return true;
  }
  
  @override
  void render(Canvas canvas) {
    // Візуалізація зони взаємодії (для відлагодження)
    final paint = Paint()
      ..color = Colors.purple.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(size.toRect(), paint);
    
    super.render(canvas);
  }
}