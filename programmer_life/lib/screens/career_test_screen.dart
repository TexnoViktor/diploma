// lib/screens/career_test_screen.dart
import 'package:flutter/material.dart';
import '../models/career_test_model.dart';
import '../services/storage_service.dart';

class CareerTestScreen extends StatefulWidget {
  const CareerTestScreen({Key? key}) : super(key: key);

  @override
  State<CareerTestScreen> createState() => _CareerTestScreenState();
}

class _CareerTestScreenState extends State<CareerTestScreen> {
  int _currentQuestionIndex = 0;
  Map<String, int> _scores = {'backend': 0, 'frontend': 0, 'devops': 0};
  bool _isTestCompleted = false;
  CareerTestResult? _testResult;
  final List<CareerTestQuestion> _questions = CareerTest.getQuestions();

  @override
  Widget build(BuildContext context) {
    if (_isTestCompleted && _testResult != null) {
      return _buildResultScreen();
    } else {
      return _buildQuestionScreen();
    }
  }

  Widget _buildQuestionScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профорієнтаційний тест'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Питання ${_currentQuestionIndex + 1} з ${_questions.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ..._buildAnswerWidgets(currentQuestion),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswerWidgets(CareerTestQuestion question) {
    return question.answers.map((answer) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ElevatedButton(
          onPressed: () => _selectAnswer(answer),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: Text(
            answer.text,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }).toList();
  }

  void _selectAnswer(CareerTestAnswer answer) {
    // Оновлюємо рахунок
    answer.scores.forEach((type, score) {
      _scores[type] = (_scores[type] ?? 0) + score;
    });

    // Переходимо до наступного питання або завершуємо тест
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeTest();
    }
  }

  void _completeTest() async {
    final result = CareerTestResult.fromScores(_scores);
    await StorageService.saveTestResult(result);
    
    setState(() {
      _isTestCompleted = true;
      _testResult = result;
    });
  }

  Widget _buildResultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результати тесту'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Ваш профіль: ${_testResult!.dominantType.toUpperCase()}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              _testResult!.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Детальні результати:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ..._buildScoreWidgets(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Почати гру'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScoreWidgets() {
    return _testResult!.scores.entries.map((entry) {
      String typeName = '';
      switch (entry.key) {
        case 'backend':
          typeName = 'Backend-розробка';
          break;
        case 'frontend':
          typeName = 'Frontend-розробка';
          break;
        case 'devops':
          typeName = 'DevOps';
          break;
        default:
          typeName = entry.key;
      }
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(typeName, style: const TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex: 7,
              child: LinearProgressIndicator(
                value: entry.value / 50, // Припускаємо, що максимальний бал 50
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForType(entry.key),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${entry.value}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'backend':
        return Colors.blue;
      case 'frontend':
        return Colors.orange;
      case 'devops':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}