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
  final VoidCallback checkGameConditions;  // Додано callback для перевірки умов закінчення гри
  
  const BreakRoomTab({
    required this.onCoffeeBreak,
    required this.onEnergyDrink,
    required this.onMeditation,
    required this.onSnack,
    required this.onPowerNap,
    required this.coffeeBreakActive,
    required this.addToEventLog,
    required this.gameState,
    required this.checkGameConditions,  // Новий обов'язковий параметр
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(  // Changed from Column to Row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Break options on the left
          Expanded(
            flex: 3,  // Take 60% of the space
            child: coffeeBreakActive 
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Оберіть вид відпочинку:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  
                  Expanded(
                    child: ListView(
                      children: [
                        _buildBreakOption(
                          context,
                          'Випити каву',
                          Icons.coffee,
                          Colors.brown,
                          'Відновлює енергію та зосередженість',
                          '+25% енергії, 15 секунд',
                          () {
                            onCoffeeBreak();
                            // Перевірка умов закінчення гри після впливу бафу
                            checkGameConditions();
                          },
                        ),
                        
                        SizedBox(height: 10),
                        
                        _buildBreakOption(
                          context,
                          'Енергетик',
                          Icons.local_drink,
                          Colors.red,
                          'Швидкий заряд енергії, але підвищує стрес',
                          '+30% енергії, +15% стресу, 10 секунд',
                          () {
                            onEnergyDrink();
                            // Перевірка умов закінчення гри після впливу бафу
                            checkGameConditions();
                          },
                        ),
                        
                        SizedBox(height: 10),
                        
                        _buildBreakOption(
                          context,
                          'Медитація',
                          Icons.self_improvement,
                          Colors.green,
                          'Знижує рівень стресу, але забирає трохи енергії',
                          '-20% стресу, -5% енергії, 20 секунд',
                          () {
                            onMeditation();
                            // Перевірка умов закінчення гри після впливу бафу
                            checkGameConditions();
                          },
                        ),
                        
                        SizedBox(height: 10),
                        
                        _buildBreakOption(
                          context,
                          'Перекус',
                          Icons.fastfood,
                          Colors.orange,
                          'Швидкий перекус для додаткової енергії',
                          '+15% енергії, +5% стресу, 5 секунд',
                          () {
                            onSnack();
                            // Перевірка умов закінчення гри після впливу бафу
                            checkGameConditions();
                          },
                        ),
                        
                        SizedBox(height: 10),
                        
                        _buildBreakOption(
                          context,
                          'Короткий сон',
                          Icons.hotel,
                          Colors.blue,
                          'Значно відновлює енергію та знижує стрес',
                          '+35% енергії, -10% стресу, 30 секунд',
                          () {
                            onPowerNap();
                            // Перевірка умов закінчення гри після впливу бафу
                            checkGameConditions();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
          
          SizedBox(width: 16),  // Space between actions and image
          
          // Break room image on the right
          Expanded(
            flex: 2,  // Take 40% of the space
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/images/break_room.png'),
                  fit: BoxFit.contain,
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ],
              ),
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
    String effects,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: coffeeBreakActive ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: coffeeBreakActive ? Colors.grey[200] : color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: coffeeBreakActive ? Colors.grey : color,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: coffeeBreakActive ? Colors.grey : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: coffeeBreakActive ? Colors.grey : Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      effects,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: coffeeBreakActive ? Colors.grey : color,
                      ),
                    ),
                  ],
                ),
              ),
              if (coffeeBreakActive)
                Icon(Icons.lock, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}