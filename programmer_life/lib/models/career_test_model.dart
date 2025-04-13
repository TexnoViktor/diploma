// lib/models/career_test_model.dart
class CareerTestQuestion {
  final String question;
  final List<CareerTestAnswer> answers;

  CareerTestQuestion({
    required this.question,
    required this.answers,
  });
}

class CareerTestAnswer {
  final String text;
  final Map<String, int> scores;

  CareerTestAnswer({
    required this.text,
    required this.scores,
  });
}

class CareerTestResult {
  final Map<String, int> scores;
  final String dominantType;
  final String description;

  CareerTestResult({
    required this.scores,
    required this.dominantType,
    required this.description,
  });

  factory CareerTestResult.fromScores(Map<String, int> scores) {
    String dominantType = '';
    int maxScore = -1;

    scores.forEach((type, score) {
      if (score > maxScore) {
        maxScore = score;
        dominantType = type;
      }
    });

    String description = '';
    switch (dominantType) {
      case 'backend':
        description = 'Ви більше схильні до backend-розробки. Вас приваблюють складні алгоритми, робота з даними та оптимізація систем.';
        break;
      case 'frontend':
        description = 'Ви тяжієте до frontend-розробки. Вам подобається створювати інтерфейси та взаємодіяти з користувачами.';
        break;
      case 'devops':
        description = 'Ви маєте схильність до DevOps. Автоматизація, інфраструктура та оптимізація процесів - ваша стихія.';
        break;
      default:
        description = 'Ви маєте різносторонні здібності у програмуванні. Full-stack розробка може бути вашим покликанням.';
    }

    return CareerTestResult(
      scores: scores,
      dominantType: dominantType,
      description: description,
    );
  }
}

class CareerTest {
  static List<CareerTestQuestion> getQuestions() {
    return [
      CareerTestQuestion(
        question: 'Чи готові ви працювати під тиском дедлайнів?',
        answers: [
          CareerTestAnswer(
            text: 'Так, я працюю ефективніше під тиском',
            scores: {'backend': 3, 'frontend': 2, 'devops': 4},
          ),
          CareerTestAnswer(
            text: 'Інколи, залежить від важливості задачі',
            scores: {'backend': 2, 'frontend': 3, 'devops': 2},
          ),
          CareerTestAnswer(
            text: 'Ні, надаю перевагу спокійній роботі',
            scores: {'backend': 4, 'frontend': 3, 'devops': 1},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Що вас більше приваблює?',
        answers: [
          CareerTestAnswer(
            text: 'Створення красивих інтерфейсів',
            scores: {'backend': 1, 'frontend': 5, 'devops': 1},
          ),
          CareerTestAnswer(
            text: 'Розробка ефективних алгоритмів',
            scores: {'backend': 5, 'frontend': 2, 'devops': 2},
          ),
          CareerTestAnswer(
            text: 'Налаштування та оптимізація систем',
            scores: {'backend': 3, 'frontend': 1, 'devops': 5},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Як ви ставитесь до роботи в команді?',
        answers: [
          CareerTestAnswer(
            text: 'Обожнюю співпрацю та обмін ідеями',
            scores: {'backend': 3, 'frontend': 4, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Працюю в команді, але ціную самостійність',
            scores: {'backend': 4, 'frontend': 3, 'devops': 4},
          ),
          CareerTestAnswer(
            text: 'Надаю перевагу індивідуальній роботі',
            scores: {'backend': 3, 'frontend': 2, 'devops': 3},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Як швидко ви опановуєте нові технології?',
        answers: [
          CareerTestAnswer(
            text: 'Дуже швидко, постійно вивчаю щось нове',
            scores: {'backend': 4, 'frontend': 4, 'devops': 5},
          ),
          CareerTestAnswer(
            text: 'Помірно, коли в цьому є необхідність',
            scores: {'backend': 3, 'frontend': 3, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Повільно, надаю перевагу глибокому вивченню технологій',
            scores: {'backend': 4, 'frontend': 2, 'devops': 2},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Що для вас важливіше в роботі?',
        answers: [
          CareerTestAnswer(
            text: 'Стабільність та передбачуваність',
            scores: {'backend': 4, 'frontend': 3, 'devops': 2},
          ),
          CareerTestAnswer(
            text: 'Креативність та інновації',
            scores: {'backend': 3, 'frontend': 5, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Вирішення складних технічних викликів',
            scores: {'backend': 4, 'frontend': 2, 'devops': 5},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Як ви реагуєте на зміни вимог в проекті?',
        answers: [
          CareerTestAnswer(
            text: 'Адаптуюсь легко і швидко',
            scores: {'backend': 3, 'frontend': 4, 'devops': 4},
          ),
          CareerTestAnswer(
            text: 'Потребую часу на адаптацію',
            scores: {'backend': 4, 'frontend': 3, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Не люблю зміни в останній момент',
            scores: {'backend': 4, 'frontend': 2, 'devops': 2},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Чи цікаво вам взаємодіяти з користувачами?',
        answers: [
          CareerTestAnswer(
            text: 'Так, зворотний зв\'язок важливий',
            scores: {'backend': 2, 'frontend': 5, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Інколи, але не часто',
            scores: {'backend': 3, 'frontend': 3, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Ні, надаю перевагу технічним аспектам',
            scores: {'backend': 5, 'frontend': 1, 'devops': 4},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Що ви найбільше цінуєте в роботі програміста?',
        answers: [
          CareerTestAnswer(
            text: 'Можливість створювати щось корисне',
            scores: {'backend': 4, 'frontend': 4, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Постійне самовдосконалення',
            scores: {'backend': 4, 'frontend': 3, 'devops': 4},
          ),
          CareerTestAnswer(
            text: 'Вирішення складних задач',
            scores: {'backend': 5, 'frontend': 3, 'devops': 4},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Як ви ставитесь до тестування коду?',
        answers: [
          CareerTestAnswer(
            text: 'Дуже важливо, завжди пишу тести',
            scores: {'backend': 5, 'frontend': 3, 'devops': 4},
          ),
          CareerTestAnswer(
            text: 'Важливо для критичних компонентів',
            scores: {'backend': 3, 'frontend': 4, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Тестування забирає багато часу',
            scores: {'backend': 1, 'frontend': 3, 'devops': 2},
          ),
        ],
      ),
      CareerTestQuestion(
        question: 'Що вас більше мотивує?',
        answers: [
          CareerTestAnswer(
            text: 'Визнання моєї роботи колегами та користувачами',
            scores: {'backend': 3, 'frontend': 5, 'devops': 3},
          ),
          CareerTestAnswer(
            text: 'Створення ефективного та надійного коду',
            scores: {'backend': 5, 'frontend': 3, 'devops': 4},
          ),
          CareerTestAnswer(
            text: 'Вирішення технічних проблем та оптимізація',
            scores: {'backend': 4, 'frontend': 2, 'devops': 5},
          ),
        ],
      ),
    ];
  }
}