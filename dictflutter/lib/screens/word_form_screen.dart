import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class WordFormScreen extends StatefulWidget {
  final Word? existingWord;

  const WordFormScreen({super.key, this.existingWord});

  @override
  State<WordFormScreen> createState() => _WordFormScreenState();
}

class _WordFormScreenState extends State<WordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingWord != null) {
      _wordController.text = widget.existingWord!.word;
      _meaningController.text = widget.existingWord!.meaning ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingWord == null ? "Nueva palabra" : "Editar palabra"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _wordController,
                decoration: const InputDecoration(labelText: "Palabra"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _meaningController,
                decoration: const InputDecoration(labelText: "Significado"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final word = Word(
                    idword: widget.existingWord?.idword ?? 0,
                    word: _wordController.text,
                    meaning: _meaningController.text,
                  );

                  final ok = widget.existingWord == null
                      ? await ApiService().createWord(word, auth.token!)
                      : await ApiService().updateWord(word.idword, word, auth.token!);

                  if (ok) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error al guardar")),
                    );
                  }
                },
                child: Text(widget.existingWord == null ? "Guardar" : "Actualizar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
