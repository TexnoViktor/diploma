// File: widgets/coding_challenge.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/game_state_provider.dart';

class CodingChallenge extends StatefulWidget {
  final Function(bool isCorrect, int codeLength) onSubmit;
  final bool isActive;
  final CareerStage careerStage;
  
  const CodingChallenge({
    required this.onSubmit,
    required this.isActive,
    required this.careerStage,
  });
  
  @override
  _CodingChallengeState createState() => _CodingChallengeState();
}

class _CodingChallengeState extends State<CodingChallenge> {
  final TextEditingController _codeController = TextEditingController();
  String _currentChallenge = '';
  FocusNode _codeFocusNode = FocusNode();
  bool _showError = false;
  List<String> _recentChallenges = [];
  
  // Lists of code snippets by difficulty
  final List<String> _juniorChallenges = [
    'print("Hello World");',
    'int x = 5;',
    'String name = "User";',
    'if (count > 0) {',
    'for (int i = 0; i < 5; i++) {',
    'bool isActive = true;',
    'return result;',
    'void main() {',
    'List<int> numbers = [1, 2, 3];',
    'sum += value;',
    '} else {',
    'function getData() {',
    'let items = [];',
    'var total = 0;',
    'console.log(message);',
  ];
  
  final List<String> _middleChallenges = [
    'Map<String, dynamic> data = {};',
    'try { await api.fetchData(); }',
    'setState(() { _isLoading = false; });',
    'Future<void> loadUsers() async {',
    'Stream<String> getMessages() {',
    'final response = await http.get(url);',
    'useEffect(() => { setCount(count + 1); });',
    'const [value, setValue] = useState("");',
    'function calculateTotal(items) {',
    'switch (status) { case "loading":',
    'class User implements Person {',
    '@override Widget build(BuildContext context) {',
    'public static void main(String[] args) {',
    'export default function App() {',
    'public class Customer extends Person {',
  ];
  
  final List<String> _seniorChallenges = [
    'factory User.fromJson(Map<String, dynamic> json) {',
    'final completer = Completer<List<String>>();',
    'BlocBuilder<AppBloc, AppState>(',
    'FutureBuilder<QuerySnapshot>(',
    'Stream<List<Message>> getMessages() {',
    'Consumer<ThemeModel>(',
    'await transaction.update(documentRef, {"status": "completed"});',
    'useContext<AuthenticationContext>();',
    'useReducer((state, action) => { switch (action.type) {',
    'static T? _instance;',
    'const memoizedSelector = createSelector(',
    '@InjectRepository(User) private readonly userRepo: Repository<User>,',
    'Observable.fromEvent(element, "click").pipe(',
    'getDerivedStateFromProps(nextProps, prevState) {',
    'const mapStateToProps = (state: RootState) => ({',
  ];
  
  @override
  void initState() {
    super.initState();
    _generateNewChallenge();
  }
  
  @override
  void didUpdateWidget(CodingChallenge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the widget becomes active and was previously inactive, generate a new challenge
    if (widget.isActive && !oldWidget.isActive) {
      _generateNewChallenge();
      _codeFocusNode.requestFocus();
    }
  }
  
  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }
  
  void _generateNewChallenge() {
    List<String> currentPool;
    
    // Select the appropriate challenge pool based on career stage
    switch (widget.careerStage) {
      case CareerStage.Junior:
        currentPool = _juniorChallenges;
        break;
      case CareerStage.Middle:
        currentPool = _middleChallenges;
        break;
      case CareerStage.Senior:
        currentPool = _seniorChallenges;
        break;
    }
    
    // Make sure we don't get the same challenge twice in a row
    String newChallenge;
    do {
      newChallenge = currentPool[Random().nextInt(currentPool.length)];
    } while (_recentChallenges.contains(newChallenge) && _recentChallenges.length < currentPool.length);
    
    // Update recent challenges list (keep last 3)
    _recentChallenges.add(newChallenge);
    if (_recentChallenges.length > 3) {
      _recentChallenges.removeAt(0);
    }
    
    setState(() {
      _currentChallenge = newChallenge;
      _codeController.clear();
      _showError = false;
    });
  }
  
  void _checkCode() {
    // Trim to handle extra spaces that won't affect functionality
    final userInput = _codeController.text.trim();
    final targetCode = _currentChallenge.trim();
    
    // Check if the code is correct
    final bool isCorrect = userInput == targetCode;
    
    if (isCorrect) {
      // Call the callback with success
      widget.onSubmit(true, targetCode.length);
      // Generate a new challenge
      _generateNewChallenge();
    } else {
      // Show error feedback
      setState(() {
        _showError = true;
      });
      // Call the callback with failure
      widget.onSubmit(false, 0);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Code display section - show the code to type
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _currentChallenge,
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'Courier',
              fontSize: 16,
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Code input area
        TextField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          enabled: widget.isActive,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Введіть код тут...',
            errorText: _showError ? 'Неправильний код! Спробуйте ще раз.' : null,
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: widget.isActive ? _checkCode : null,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 16,
          ),
          onSubmitted: (_) => _checkCode(),
        ),
        
        SizedBox(height: 8),
        
        // Suggestion for players (Visible when active)
        if (widget.isActive)
          Text(
            'Введіть точну копію коду, показаного вище, і натисніть Enter або "Відправити"',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}