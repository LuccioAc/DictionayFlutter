import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word.dart';

class ApiService {
  final String baseUrl = 'http://www.apidict.somee.com/api';

  Future<List<Word>> fetchWords() async {
    final res = await http.get(Uri.parse('$baseUrl/Palabras'));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((json) => Word.fromJson(json)).toList();
    }
    throw Exception('Error al cargar palabras');
  }

  Future<Word> fetchWordById(int id) async {
  final res = await http.get(Uri.parse('$baseUrl/Palabras/$id'));
  if (res.statusCode == 200) {
    final json = jsonDecode(res.body);
    return Word.fromJson(json);
  }
  throw Exception("No se pudo obtener la palabra");
}

  Future<bool> createWord(Word word, String token) async {
    final res = await http.post(
      Uri.parse('$baseUrl/Palabras'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(word.toJson()),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> updateWord(int id, Word word, String token) async {
    final res = await http.put(
      Uri.parse('$baseUrl/Palabras/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(word.toJson()),
    );
    return res.statusCode == 200;
  }

  Future<bool> deleteWord(int id, String token) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/Palabras/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );
    return res.statusCode == 200;
  }
}
