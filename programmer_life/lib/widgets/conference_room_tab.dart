import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';

class ConferenceRoomTab extends StatelessWidget {
  final VoidCallback onAskForHelp;
  final VoidCallback onHelpColleague;
  final VoidCallback onCodeReview;
  final VoidCallback onTeamMeeting;
  final Function(String) addToEventLog;
  final GameStateProvider gameState;
  
  const ConferenceRoomTab({
    required this.onAskForHelp,
    required this.onHelpColleague,
    required this.onCodeReview,
    required this.onTeamMeeting,
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
          // Conference room image
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('assets/images/conference_room.png'),
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
                    'Конференц-зал',
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
                  onAskForHelp,
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
                  onHelpColleague,
                  true, // Always available
                ),
                
                SizedBox(height: 10),
                
                _buildInteractionCard(
                  context,
                  'Code Review',
                  Icons.rate_review,
                  Colors.amber,
                  'Проведіть code review проекту команди',
                  '+10% прогресу, -10% стресу',
                  onCodeReview,
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
                  onTeamMeeting,
                  true, // Always available
                ),
              ],
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