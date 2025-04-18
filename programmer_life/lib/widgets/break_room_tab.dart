// File: widgets/break_room_tab.dart
import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';

class BreakRoomTab extends StatelessWidget {
  final VoidCallback onCoffeeBreak;
  final VoidCallback onEnergyDrink;
  final VoidCallback onMeditation;
  final VoidCallback onSnack;
  final VoidCallback onPowerNap;
  final bool coffeeBreakActive;
  final Function(String) addToEventLog;
  final GameStateProvider gameState;
  
  const BreakRoomTab({
    required this.onCoffeeBreak,
    required this.onEnergyDrink,
    required this.onMeditation,
    required this.onSnack,
    required this.onPowerNap,
    required this.coffeeBreakActive,
    required this.addToEventLog,
    required this.gameState,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Break room image
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('assets/images/break_room.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  height: double.infinity,
                ),
                Center(
                  child: Text(
                    'Кімната відпочинку',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Break options
          if (coffeeBreakActive) 
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Відпочиваємо...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          else 
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Оберіть вид відпочинку:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildBreakOption(
                          context,
                          'Випити каву',
                          Icons.coffee,
                          Colors.brown,
                          '+25% енергії\n15 секунд',
                          onCoffeeBreak,
                        ),
                        _buildBreakOption(
                          context,
                          'Енергетик',
                          Icons.local_drink,
                          Colors.red,
                          '+30% енергії\n+15% стресу\n10 секунд',
                          onEnergyDrink,
                        ),
                        _buildBreakOption(
                          context,
                          'Медитація',
                          Icons.self_improvement,
                          Colors.green,
                          '-20% стресу\n-5% енергії\n20 секунд',
                          onMeditation,
                        ),
                        _buildBreakOption(
                          context,
                          'Перекус',
                          Icons.fastfood,
                          Colors.orange,
                          '+15% енергії\n+5% стресу\n5 секунд',
                          onSnack,
                        ),
                        _buildBreakOption(
                          context,
                          'Короткий сон',
                          Icons.hotel,
                          Colors.blue,
                          '+35% енергії\n-10% стресу\n30 секунд',
                          onPowerNap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildBreakOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: coffeeBreakActive ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}