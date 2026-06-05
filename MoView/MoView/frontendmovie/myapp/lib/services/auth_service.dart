import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:3000/api/auth';

  static String? token;
  static String? username;
  static int? userId;
  static bool get isLoggedIn => token != null;

  Future<Map<String, dynamic>> login(String usernameInput, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameInput,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      AuthService.token = body['data']['token'];
      AuthService.username = body['data']['user']['username'];
      AuthService.userId = body['data']['user']['id'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', AuthService.token!);
      await prefs.setString('username', AuthService.username!);
      await prefs.setInt('userId', AuthService.userId!);

      return body['data'];
    } else {
      throw Exception(body['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> register(String usernameInput, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameInput,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201 && body['success'] == true) {
      return body['data'];
    } else {
      throw Exception(body['message'] ?? 'Registration failed');
    }
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');
    userId = prefs.getInt('userId');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('userId');

    token = null;
    username = null;
    userId = null;
  }

  static Future<bool> verifyToken() async {
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        username = body['data']['username'];
        userId = body['data']['id'];
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }
}