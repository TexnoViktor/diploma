// lib/
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class OfficeMap extends Component with HasGameRef {
  // Розміри карти
  final Vector2 mapSize = Vector2(1000, 600);
  
  @override
  Future<void> onLoad() async {
    // Тут буде завантаження карти з Tiled
    // Але для початкової версії просто створимо прямокутники для зон
  }
  
  @override
  void render(Canvas canvas) {
    // Тимчасове відображення офісу (фон)
    final paint = Paint()..color = Colors.grey.shade200;
    canvas.drawRect(Rect.fromLTWH(0, 0, mapSize.x, mapSize.y), paint);
    
    // Відображення зон
    _drawZone(canvas, Rect.fromLTWH(180, 180, 140, 140), Colors.lightBlue.shade100, 'Робоче місце');
    _drawZone(canvas, Rect.fromLTWH(380, 180, 140, 140), Colors.green.shade100, 'Кімната відпочинку');
    _drawZone(canvas, Rect.fromLTWH(580, 180, 140, 140), Colors.amber.shade100, 'Конференц-зал');
    
    super.render(canvas);
  }
  
  void _drawZone(Canvas canvas, Rect rect, Color color, String name) {
    // Малюємо прямокутник зони
    final paint = Paint()..color = color;
    canvas.drawRect(rect, paint);
    
    // Малюємо межі зони
    final borderPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(rect, borderPaint);
    
    // Додаємо назву зони
    final textStyle = TextStyle(
      color: Colors.black87,
      fontSize: 14,
    );
    
    final textPainter = TextPainter(
      text: TextSpan(text: name, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(
        rect.left + (rect.width - textPainter.width) / 2,
        rect.top + 10,
      ),
    );
  }
}

