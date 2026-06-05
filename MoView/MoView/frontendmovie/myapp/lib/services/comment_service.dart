import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class CommentService {
  static const String _baseUrl = 'http://localhost:3000/api/comments';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  Future<List<Map<String, dynamic>>> getComments(String imdbId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$imdbId'),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      final comments = body['data']['comments'] as List;
      return comments.cast<Map<String, dynamic>>();
    }
    return [];
  }


  Future<Map<String, dynamic>> addComment(
    String imdbId, 
    String comment, 
    {int? parentId}
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$imdbId'),
      headers: _headers,
      body: jsonEncode({
        'comment': comment,
        if (parentId != null) 'parent_id': parentId,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 201 && body['success'] == true) {
      return body['data'];
    }
    throw Exception(body['message'] ?? 'Failed to add comment');
  }

  Future<void> deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$commentId'),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to delete comment');
    }
  }
}