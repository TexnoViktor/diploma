import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';

class PowerupButton extends StatelessWidget {
  final PowerupType type;
  final bool isAvailable;
  final VoidCallback onPressed;
  
  const PowerupButton({
    required this.type,
    required this.isAvailable,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String tooltip;
    
    switch (type) {
      case PowerupType.askColleague:
        icon = Icons.people;
        color = Colors.blue;
        tooltip = 'Допомога колеги (+15% прогресу, +10% стресу)';
        break;
      case PowerupType.energyDrink:
        icon = Icons.local_drink;
        color = Colors.red;
        tooltip = 'Енергетик (+30% енергії, +15% стресу)';
        break;
      case PowerupType.debuggingTool:
        icon = Icons.bug_report;
        color = Colors.purple;
        tooltip = 'Інструмент дебагу (+20% прогресу, -5% енергії)';
        break;
      case PowerupType.meditation:
        icon = Icons.self_improvement;
        color = Colors.green;
        tooltip = 'Медитація (-20% стресу, -5% енергії)';
        break;
      case PowerupType.codeReview:
        icon = Icons.rate_review;
        color = Colors.amber;
        tooltip = 'Code Review (+10% прогресу, -10% стресу)';
        break;
    }
    
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Stack(
          children: [
            Icon(icon, color: isAvailable ? color : Colors.grey),
            if (!isAvailable)
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.close, color: Colors.red, size: 14),
              ),
          ],
        ),
        onPressed: isAvailable ? onPressed : null,
        iconSize: 24,
      ),
    );
  }
}
