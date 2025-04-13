import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class InteractiveZone extends PositionComponent with Tappable {
  final String zoneName;
  final Function onInteract;
  
  InteractiveZone({
    required Vector2 position,
    required Vector2 size,
    required this.zoneName,
    required this.onInteract,
  }) : super(position: position, size: size);
  
  @override
  bool onTapDown(TapDownInfo info) {
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