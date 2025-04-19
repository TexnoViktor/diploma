import 'package:flutter/material.dart';

class WorkplaceTab extends StatelessWidget {
  final List<String> eventLog;
  final bool isWorking;
  final bool coffeeBreakActive;
  final VoidCallback onStartWorking;
  
  const WorkplaceTab({
    required this.eventLog,
    required this.isWorking,
    required this.coffeeBreakActive,
    required this.onStartWorking,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(  // Changed from Column to Row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Actions and event log on the left
          Expanded(
            flex: 3,  // Take 60% of the space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Start working button
                ElevatedButton(
                  onPressed: onStartWorking,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isWorking ? Colors.green : null,
                  ),
                  child: Text(
                    isWorking 
                      ? 'Працюю (Натискайте клавіші)' 
                      : 'Почати писати код', 
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Event log
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Журнал подій:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: eventLog.length,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(eventLog[index]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Instructions
                if (isWorking)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Натискайте будь-які клавіші для написання коду!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                
                if (coffeeBreakActive)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Відпочиваємо... Перерва активна.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.brown),
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(width: 16),  // Space between actions and image
          
          // Workplace image on the right
          Expanded(
            flex: 2,  // Take 40% of the space
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/images/workplace.png'),
                  fit: BoxFit.contain,
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
                      'Робоче місце',
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
          ),
        ],
      ),
    );
  }
}