import 'package:flutter/material.dart';

class ResourceIndicator extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  
  const ResourceIndicator({
    required this.label,
    required this.value,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${value.toStringAsFixed(1)}%'),
          ],
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}