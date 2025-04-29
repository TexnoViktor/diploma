import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';

class ConferenceRoomTab extends StatelessWidget {
  final Function(String) addToEventLog;
  final GameStateProvider gameState;
  final VoidCallback checkGameConditions;
  
  const ConferenceRoomTab({
    required this.addToEventLog,
    required this.gameState,
    required this.checkGameConditions,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interaction options on the left
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Взаємодія з колегами:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 16),
                
                Expanded(
                  child: ListView(
                    children: [
                      _buildInteractionCard(
                        context,
                        'Попросити допомоги',
                        Icons.pan_tool,
                        Colors.blue,
                        'Попросіть колег допомогти з вашим завданням',
                        '+15% прогресу, +10% стресу',
                        () {
                          // Використовуємо той самий пауерап, що і в меню паузи
                          gameState.usePowerup(PowerupType.askColleague);
                          addToEventLog('🧑‍💻 Ви попросили допомоги в колеги. +15% прогресу, +10% стресу.');
                          checkGameConditions();
                        },
                        gameState.availablePowerups[PowerupType.askColleague] ?? false,
                      ),
                      
                      SizedBox(height: 10),
                      
                      _buildInteractionCard(
                        context,
                        'Допомогти колезі',
                        Icons.handshake,
                        Colors.green,
                        'Допоможіть колезі з його завданням',
                        '+5% прогресу, -10% енергії, -5% стресу',
                        () {
                          gameState.helpColleague();
                          addToEventLog('👨‍👩‍👧‍👦 Ви допомогли колезі. +5% прогресу, -10% енергії, -5% стресу.');
                          checkGameConditions();
                        },
                        !gameState.isInteractionOnCooldown('helpColleague'),
                      ),
                      
                      SizedBox(height: 10),
                      
                      _buildInteractionCard(
                        context,
                        'Code Review',
                        Icons.rate_review,
                        Colors.amber,
                        'Проведіть code review проекту команди',
                        '+10% прогресу, -10% стресу',
                        () {
                          // Використовуємо той самий пауерап, що і в меню паузи
                          gameState.usePowerup(PowerupType.codeReview);
                          addToEventLog('📝 Ви провели code review. +10% прогресу, -10% стресу.');
                          checkGameConditions();
                        },
                        gameState.availablePowerups[PowerupType.codeReview] ?? false,
                      ),
                      
                      SizedBox(height: 10),
                      
                      _buildInteractionCard(
                        context,
                        'Командна нарада',
                        Icons.groups,
                        Colors.purple,
                        'Візьміть участь у командній нараді',
                        '+8% прогресу, +5% стресу, -8% енергії',
                        () {
                          gameState.attendMeeting();
                          addToEventLog('👥 Ви взяли участь у командній нараді. +8% прогресу, +5% стресу, -8% енергії.');
                          checkGameConditions();
                        },
                        !gameState.isInteractionOnCooldown('meeting'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(width: 16),  // Space between actions and image
          
          // Conference room image on the right
          Expanded(
            flex: 2,  // Take 40% of the space
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/images/conference_room.png'),
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
  
  Widget _buildInteractionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    String effects,
    VoidCallback onTap,
    bool isAvailable,
  ) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isAvailable ? color.withOpacity(0.2) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: isAvailable ? color : Colors.grey,
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
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isAvailable ? Colors.black54 : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      effects,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? color : Colors.grey,
                      ),
                    ),
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