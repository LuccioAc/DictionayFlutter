import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService with ChangeNotifier {
  String? _token;
  User? _user;
  final String baseUrl = 'http://www.apidict.somee.com/api';

  bool get loggedIn => _token != null;
  bool get isAdmin => _user?.rol ?? false;
  String? get token => _token;
  User? get user => _user;

  Future<bool> login(String codeusr, String passw) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'codeusr': codeusr, 'passw': passw}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _user = User.fromJson(data['user']);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String nameusr, String passw) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nameusr': nameusr, 'passw': passw}),
    );
    return response.statusCode == 200;
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
