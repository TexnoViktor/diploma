// File: screens/main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Життя Програміста'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Center(
              child: Text(
                'Життя Програміста',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Симулятор життя розробника',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 40),
            
            // Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelSelectionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Почати гру', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showInstructionsDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Інструкції', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showSettingsDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Налаштування', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showResetProgressDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red[400],
              ),
              child: Text('Скинути прогрес', style: TextStyle(fontSize: 18)),
            ),
            
            Spacer(),
            
            // Footer
            Center(
              child: Text(
                '© 2025 Життя Програміста',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Інструкції'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Про гру:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Ви - програміст, який повинен пройти шлях від Junior до Senior розробника.'),
              Text('• Кожен етап кар\'єри складається з 7 днів.'),
              Text('• На проходження одного дня відведено 6 хвилин.'),
              SizedBox(height: 10),
              Text('Управління ресурсами:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Енергія: витрачається при написанні коду.'),
              Text('• Стрес: зростає через випадкові події.'),
              Text('• Прогрес коду: необхідно досягти 100% для завершення дня.'),
              SizedBox(height: 10),
              Text('Як грати:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Натискайте будь-які клавіші для написання коду.'),
              Text('• Використовуйте кава-брейк для відновлення енергії.'),
              Text('• Реагуйте на випадкові події та приймайте рішення.'),
              Text('• Використовуйте додаткові опції з меню паузи (1 раз на рівень).'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Зрозуміло'),
          ),
        ],
      ),
    );
  }
  
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Налаштування'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Звукові ефекти'),
              value: true, // Заглушка, потрібно замінити на реальне значення
              onChanged: (value) {
                // Заглушка, потрібно реалізувати
              },
            ),
            SwitchListTile(
              title: Text('Повноекранний режим'),
              value: false, // Заглушка, потрібно замінити на реальне значення
              onChanged: (value) {
                // Заглушка, потрібно реалізувати
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрити'),
          ),
        ],
      ),
    );
  }
  
  void _showResetProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Скинути прогрес'),
        content: Text('Ви впевнені, що хочете скинути весь прогрес у грі? Ця дія незворотна.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              final gameState = Provider.of<GameStateProvider>(context, listen: false);
              gameState.resetAllProgress();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Прогрес скинуто!'))
              );
            },
            child: Text('Скинути', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class LevelSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Вибір рівня'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Виберіть етап кар\'єри та день:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      // Junior Career Stage
                      _buildCareerStageCard(
                        context: context,
                        gameState: gameState,
                        stage: CareerStage.Junior,
                        title: 'Junior розробник',
                        description: 'Початок шляху. Менша складність, але й менший вплив.',
                        color: Colors.green,
                        isUnlocked: true, // Junior is always unlocked
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Middle Career Stage
                      _buildCareerStageCard(
                        context: context,
                        gameState: gameState,
                        stage: CareerStage.Middle,
                        title: 'Middle розробник',
                        description: 'Середня складність. Більше подій і складніші виклики.',
                        color: Colors.blue,
                        isUnlocked: gameState.highestUnlockedStage.index >= CareerStage.Middle.index,
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Senior Career Stage
                      _buildCareerStageCard(
                        context: context,
                        gameState: gameState,
                        stage: CareerStage.Senior,
                        title: 'Senior розробник',
                        description: 'Висока складність. Стрес зростає швидше, складні задачі.',
                        color: Colors.purple,
                        isUnlocked: gameState.highestUnlockedStage.index >= CareerStage.Senior.index,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCareerStageCard({
    required BuildContext context,
    required GameStateProvider gameState,
    required CareerStage stage,
    required String title,
    required String description,
    required Color color,
    required bool isUnlocked,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (!isUnlocked) Icon(Icons.lock, color: Colors.grey),
              ],
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 16),
            if (isUnlocked) _buildDaySelectionGrid(context, gameState, stage)
            else Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Пройдіть попередній етап, щоб розблокувати',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDaySelectionGrid(BuildContext context, GameStateProvider gameState, CareerStage stage) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 7, // 7 days per career stage
      itemBuilder: (context, index) {
        final dayNumber = index + 1;
        final isUnlocked = gameState.isLevelUnlocked(stage, dayNumber);
        
        return InkWell(
          onTap: isUnlocked
              ? () {
                  gameState.setCurrentStage(stage);
                  gameState.setCurrentDay(dayNumber);
                  gameState.startNewDay();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(),
                    ),
                  );
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isUnlocked ? Colors.blue : Colors.grey,
                width: 2,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'День $dayNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (!isUnlocked)
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Icon(Icons.lock, size: 16, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}