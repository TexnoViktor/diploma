import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;
  final Map<PowerupType, bool> availablePowerups;
  final Function(PowerupType) onUsePowerup;
  
  const PauseMenu({
    required this.onResume,
    required this.onRestart,
    required this.onExit,
    required this.availablePowerups,
    required this.onUsePowerup,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Пауза'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Game flow buttons
          ElevatedButton(
            onPressed: onResume,
            child: Text('Продовжити'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRestart,
            child: Text('Перезапустити день'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onExit,
            child: Text('Вийти до меню'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.red[400],
            ),
          ),
          
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 10),
          
          // Powerups section
          Text('Доступні бонуси (доступні 1 раз на рівень):',
               style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          
          // Powerup options
          _buildPowerupOption(
            context,
            PowerupType.askColleague,
            'Допомога колеги',
            '+15% прогресу, +10% стресу',
            Icons.people,
            Colors.blue,
          ),
          SizedBox(height: 8),
          _buildPowerupOption(
            context,
            PowerupType.energyDrink,
            'Енергетик',
            '+30% енергії, +15% стресу',
            Icons.local_drink,
            Colors.red,
          ),
          SizedBox(height: 8),
          _buildPowerupOption(
            context,
            PowerupType.debuggingTool,
            'Інструмент дебагу',
            '+20% прогресу, -5% енергії',
            Icons.bug_report,
            Colors.purple,
          ),
          SizedBox(height: 8),
          _buildPowerupOption(
            context,
            PowerupType.meditation,
            'Медитація',
            '-20% стресу, -5% енергії',
            Icons.self_improvement,
            Colors.green,
          ),
          SizedBox(height: 8),
          _buildPowerupOption(
            context,
            PowerupType.codeReview,
            'Code Review',
            '+10% прогресу, -10% стресу',
            Icons.rate_review,
            Colors.amber,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPowerupOption(
    BuildContext context,
    PowerupType type,
    String name,
    String description,
    IconData icon,
    Color color,
  ) {
    final isAvailable = availablePowerups[type] ?? false;
    
    return Card(
      elevation: 2,
      color: isAvailable ? Colors.white : Colors.grey[200],
      child: InkWell(
        onTap: isAvailable ? () => onUsePowerup(type) : null,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: isAvailable ? color : Colors.grey),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: isAvailable ? Colors.black : Colors.grey,
                         )),
                    Text(description,
                         style: TextStyle(
                           fontSize: 12,
                           color: isAvailable ? Colors.black54 : Colors.grey,
                         )),
                  ],
                ),
              ),
              if (!isAvailable)
                Icon(Icons.lock, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}