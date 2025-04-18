import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';

class OrientationTestScreen extends StatefulWidget {
  @override
  _OrientationTestScreenState createState() => _OrientationTestScreenState();
}

class _OrientationTestScreenState extends State<OrientationTestScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Чи готові ви працювати в умовах стресу?',
      'answers': ['Так, легко справляюсь зі стресом', 'Залежить від ситуації', 'Ні, намагаюсь уникати стресу'],
    },
    {
      'question': 'Ви віддаєте перевагу роботі в команді чи самостійно?',
      'answers': ['В команді', 'Залежить від проекту', 'Самостійно'],
    },
    {
      'question': 'Наскільки важлива для вас зарплата порівняно з цікавими задачами?',
      'answers': ['Зарплата важливіша', 'Обидва фактори важливі', 'Цікаві задачі важливіші'],
    },
    {
      'question': 'Скільки годин на день ви готові працювати?',
      'answers': ['До 6 годин', '8 годин', 'Більше 8 годин'],
    },
    {
      'question': 'Як часто ви готові вчити нові технології?',
      'answers': ['Постійно', 'Час від часу', 'Лише коли це необхідно'],
    },
    {
      'question': 'Ви проактивний чи реактивний у вирішенні проблем?',
      'answers': ['Проактивний', 'Комбіную обидва підходи', 'Реактивний'],
    },
    {
      'question': 'Чи готові ви до дедлайнів, що регулярно змінюються?',
      'answers': ['Так, це нормально', 'Залежить від частоти змін', 'Ні, це дратує'],
    },
    {
      'question': 'Чи важлива для вас можливість віддаленої роботи?',
      'answers': ['Так, хочу працювати віддалено', 'Комбінований режим', 'Ні, віддаю перевагу офісу'],
    },
    {
      'question': 'Наскільки важливий для вас work-life баланс?',
      'answers': ['Дуже важливий', 'Важливий, але можу іноді жертвувати', 'Робота на першому місці'],
    },
    {
      'question': 'Чи готові ви брати на себе відповідальність за рішення?',
      'answers': ['Так, завжди', 'Залежить від ситуації', 'Віддаю перевагу виконанню чітких завдань'],
    },
  ];
  
  int _currentQuestionIndex = 0;
  List<int> _answers = [];
  
  void _answerQuestion(int answerIndex) {
    setState(() {
      _answers.add(answerIndex);
      
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _finishTest();
      }
    });
  }
  
  void _finishTest() {
    // Calculate test results
    Map<String, dynamic> results = {
      'stressResistance': _calculateScore(_answers[0], _answers[6]),
      'teamwork': _calculateScore(_answers[1], _answers[5]),
      'motivation': _calculateScore(_answers[2], _answers[8]),
      'workEthic': _calculateScore(_answers[3], _answers[7]),
      'learning': _calculateScore(_answers[4], _answers[9]),
    };
    
    // Save results and navigate to main menu
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    gameState.setTestCompleted(results);
    Navigator.pushReplacementNamed(context, '/main_menu');
  }
  
  int _calculateScore(int answer1, int answer2) {
    // Simple calculation based on two related answers
    // 0 is best (first option), 2 is worst (last option)
    // Lower scores are better for the programmer's success
    return ((answer1 + answer2) / 2 * 50).round();
  }
  
  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Профорієнтаційний тест'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Питання ${_currentQuestionIndex + 1} з ${_questions.length}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion['question'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ...List.generate(
              currentQuestion['answers'].length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  child: Text(currentQuestion['answers'][index]),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}