import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class QTEDialog extends StatefulWidget {
  final String title;
  final VoidCallback onComplete;
  final VoidCallback onFail;
  final String difficulty;
  
  const QTEDialog({
    required this.title,
    required this.onComplete,
    required this.onFail,
    this.difficulty = 'normal',
  });
  
  @override
  _QTEDialogState createState() => _QTEDialogState();
}

class _QTEDialogState extends State<QTEDialog> {
  int _qteCounter = 5;
  Timer? _qteTimer;
  int _timeLeft = 10; // 10 seconds to complete
  final FocusNode _qteFocusNode = FocusNode();
  List<LogicalKeyboardKey> _requiredKeys = [];
  int _currentKeyIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _generateKeyCombination();
    _startQTETimer();
    _qteFocusNode.requestFocus();
  }
  
  void _generateKeyCombination() {
    final random = Random();
    final allKeys = [
      LogicalKeyboardKey.keyF,
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.keyE,
      LogicalKeyboardKey.keyR,
      LogicalKeyboardKey.keyT,
      LogicalKeyboardKey.keyZ,
      LogicalKeyboardKey.keyX,
      LogicalKeyboardKey.keyC,
      LogicalKeyboardKey.keyV,
    ];
    
    // Generate a random sequence based on difficulty
    _requiredKeys = [];
    int numKeys;
    
    if (widget.difficulty == 'hard') {
      numKeys = 5;
      _timeLeft = 8; // Less time for Senior level
    } else {
      numKeys = 3;
      _timeLeft = 10;
    }
    
    for (int i = 0; i < numKeys; i++) {
      _requiredKeys.add(allKeys[random.nextInt(allKeys.length)]);
    }
  }
  
  void _startQTETimer() {
    _qteTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        
        if (_timeLeft <= 0) {
          _qteTimer?.cancel();
          Navigator.of(context).pop();
          widget.onFail();
        }
      });
    });
  }
  
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Check if pressed key matches the current required key
      if (event.logicalKey == _requiredKeys[_currentKeyIndex]) {
        setState(() {
          _currentKeyIndex++;
          
          // If all keys in the sequence are pressed
          if (_currentKeyIndex >= _requiredKeys.length) {
            _qteCounter--;
            
            if (_qteCounter <= 0) {
              // Successfully completed all sequences
              _qteTimer?.cancel();
              Navigator.of(context).pop();
              widget.onComplete();
            } else {
              // Reset for next sequence
              _currentKeyIndex = 0;
              _generateKeyCombination();
            }
          }
        });
      } else {
        // Wrong key pressed, reset the current sequence
        setState(() {
          _currentKeyIndex = 0;
        });
      }
    }
  }
  
  String _getKeyName(LogicalKeyboardKey key) {
    // Convert LogicalKeyboardKey to human-readable name
    String keyString = key.keyLabel;
    if (keyString.isEmpty) {
      // Fallback for special keys
      keyString = key.keyId.toString().split('.').last;
    }
    return keyString.toUpperCase();
  }
  
  @override
  void dispose() {
    _qteTimer?.cancel();
    _qteFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _qteFocusNode,
      onKey: _handleKeyEvent,
      child: AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Натисніть послідовність клавіш для виправлення помилки:'),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _requiredKeys.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: index < _currentKeyIndex ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        _getKeyName(_requiredKeys[index]),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: index < _currentKeyIndex ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text('Залишилось послідовностей: $_qteCounter'),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: _timeLeft / (widget.difficulty == 'hard' ? 8 : 10),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _timeLeft > 3 ? Colors.green : Colors.red
              ),
            ),
            SizedBox(height: 5),
            Text('Залишилось часу: $_timeLeft с'),
          ],
        ),
      ),
    );
  }
}