import 'package:flutter/material.dart';

class EventDialog extends StatelessWidget {
  final String title;
  final String question;
  final VoidCallback onYes;
  final VoidCallback onNo;
  
  const EventDialog({
    required this.title,
    required this.question,
    required this.onYes,
    required this.onNo,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(question),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onYes();
          },
          child: Text('Так'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onNo();
          },
          child: Text('Ні'),
        ),
      ],
    );
  }
}