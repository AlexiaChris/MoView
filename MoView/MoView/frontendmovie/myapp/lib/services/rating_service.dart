import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class RatingService {
  static const String _baseUrl = 'http://localhost:3000/api/ratings';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  Future<Map<String, dynamic>> getMovieRatings(String movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$movieId'),
      headers: _headers,
    );
    
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'];
    }
    throw Exception(body['message'] ?? 'Failed to get ratings');
  }

  Future<Map<String, dynamic>> addOrUpdateRating(String movieId, int rating) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$movieId'),
      headers: _headers,
      body: jsonEncode({'rating': rating}),
    );
    
    final body = jsonDecode(response.body);
    if (response.statusCode == 201 && body['success'] == true) {
      return body['data'];
    }
    throw Exception(body['message'] ?? 'Failed to rate');
  }

  Future<void> deleteRating(String movieId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$movieId'),
      headers: _headers,
    );
    
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to delete rating');
    }
  }
}