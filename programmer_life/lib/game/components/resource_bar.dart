// lib/
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ResourceBar extends PositionComponent {
  double maxValue;
  double currentValue;
  Color color;
  String label;
  
  ResourceBar({
    required Vector2 position,
    required Vector2 size,
    required this.maxValue,
    required this.currentValue,
    required this.color,
    required this.label,
  }) : super(position: position, size: size);
  
  @override
  void render(Canvas canvas) {
    // Малюємо фон індикатора
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(size.toRect(), backgroundPaint);
    
    // Малюємо заповнену частину індикатора
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final fillWidth = (currentValue / maxValue) * size.x;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, fillWidth, size.y),
      fillPaint,
    );
    
    // Малюємо межі індикатора
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawRect(size.toRect(), borderPaint);
    
    // Додаємо назву індикатора і значення
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$label: ${currentValue.toInt()}/${maxValue.toInt()}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(
        5,
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}

