import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/word.dart';
import '../services/auth_service.dart';
import 'word_form_screen.dart';
import '../widgets/word_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Word>> words;

  void reloadWords() {
    setState(() {
      words = ApiService().fetchWords();
    });
  }

  @override
  void initState() {
    super.initState();
    reloadWords();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Palabras"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: words,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) return const Center(child: Text("No se encontraron palabras"));

          return ListView(
            children: snapshot.data!
                .map((w) => WordCard(word: w, onChanged: reloadWords))
                .toList(),
          );
        },
      ),
      floatingActionButton: auth.isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WordFormScreen()),
                );
                reloadWords();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
