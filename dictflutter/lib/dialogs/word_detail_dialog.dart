import 'package:flutter/material.dart';
import '../models/word.dart';

class WordDetailDialog extends StatelessWidget {
  final Word word;

  const WordDetailDialog({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(word.word),
      content: Text(word.meaning ?? "Sin significado disponible."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    );
  }
}
