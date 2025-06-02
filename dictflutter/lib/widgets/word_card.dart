import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../screens/word_form_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../dialogs/word_detail_dialog.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final VoidCallback onChanged;

  const WordCard({super.key, required this.word, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(word.word),
        subtitle: Text(word.meaning ?? ""),
        onTap: () async {
          final fullWord = await ApiService().fetchWordById(word.idword);
          showDialog(
            context: context,
            builder: (_) => WordDetailDialog(word: fullWord),
          );
        },
        trailing: auth.isAdmin
            ? PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WordFormScreen(existingWord: word),
                      ),
                    );
                    onChanged();
                  } else if (value == 'delete') {
                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirmar eliminación"),
                        content: const Text("¿Deseas eliminar esta palabra?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Eliminar"),
                          ),
                        ],
                      ),
                    );
                    if (confirm) {
                      final ok = await ApiService().deleteWord(word.idword, auth.token!);
                      if (ok) onChanged();
                    }
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text("Editar")),
                  const PopupMenuItem(value: 'delete', child: Text("Eliminar")),
                ],
              )
            : null,
      ),
    );
  }
}
