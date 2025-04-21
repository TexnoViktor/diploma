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
  bool _showResults = false;
  late Map<String, dynamic> _results;
  double _totalScore = 0;
  final double _passingScoreThreshold = 60.0; // Поріг прохідного балу (60%)
  
  void _answerQuestion(int answerIndex) {
    setState(() {
      _answers.add(answerIndex);
      
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _calculateResults();
      }
    });
  }
  
  void _calculateResults() {
    // Calculate test results
    _results = {
      'stressResistance': _calculateScore(_answers[0], _answers[6]),
      'teamwork': _calculateScore(_answers[1], _answers[5]),
      'motivation': _calculateScore(_answers[2], _answers[8]),
      'workEthic': _calculateScore(_answers[3], _answers[7]),
      'learning': _calculateScore(_answers[4], _answers[9]),
    };
    
    // Calculate total score (average of all results)
    _totalScore = _results.values.reduce((value, element) => value + element) / _results.length;
    
    // Show results screen
    setState(() {
      _showResults = true;
    });
  }
  
  void _finishTest() {
    // Save results and navigate to main menu
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    gameState.setTestCompleted(_results);
    Navigator.pushReplacementNamed(context, '/main_menu');
  }
  
  void _restartTest() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = [];
      _showResults = false;
    });
  }
  
  int _calculateScore(int answer1, int answer2) {
    // Simple calculation based on two related answers
    // 0 is best (first option), 2 is worst (last option)
    // Lower scores are better in original logic, but we'll invert it
    // to make higher scores better for clearer UI presentation
    // Now 100 is best and 0 is worst
    return 100 - ((answer1 + answer2) / 2 * 50).round();
  }
  
  String _getSkillName(String key) {
    switch(key) {
      case 'stressResistance': 
        return 'Стресостійкість';
      case 'teamwork': 
        return 'Командна робота';
      case 'motivation': 
        return 'Мотивація';
      case 'workEthic': 
        return 'Робоча етика';
      case 'learning': 
        return 'Здатність навчатись';
      default: 
        return key;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _buildResultsScreen();
    } else {
      return _buildQuestionScreen();
    }
  }
  
  Widget _buildQuestionScreen() {
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
  
  Widget _buildResultsScreen() {
    final bool passed = _totalScore >= _passingScoreThreshold;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Результати тесту'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ваш загальний результат:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '${_totalScore.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 42, 
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passed 
                          ? 'Вітаємо! Ви маєте потенціал стати програмістом.'
                          : 'На жаль, результати тесту вказують, що вам варто краще підготуватись.',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      passed 
                          ? 'Ваші відповіді демонструють необхідні якості та мотивацію для успішної кар\'єри в програмуванні. Продовжуйте розвиватись у цьому напрямку!'
                          : 'Можливо, вам слід приділити більше уваги розвитку навичок, необхідних для програміста, або розглянути інші професійні напрямки. Ви можете пройти тест ще раз після кращої підготовки.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Детальні результати:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (ctx, index) {
                  String key = _results.keys.elementAt(index);
                  int value = _results[key];
                  return ListTile(
                    title: Text(_getSkillName(key)),
                    subtitle: LinearProgressIndicator(
                      value: value / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        value >= 60 ? Colors.green : Colors.orange,
                      ),
                    ),
                    trailing: Text('$value%'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                if (!passed)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: _restartTest,
                        child: Text('Пройти тест ще раз'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: passed ? 0 : 8.0),
                    child: ElevatedButton(
                      onPressed: _finishTest,
                      child: Text('Продовжити'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: passed ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}