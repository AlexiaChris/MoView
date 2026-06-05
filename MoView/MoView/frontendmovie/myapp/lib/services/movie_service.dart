import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'http://localhost:3000/api/movies';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> searchMovies({
    required String query,
    int page = 1,
    String type = '',
    String year = '',
    String genre = '',
  }) async {
    final params = {
      'q': query,
      'page': page.toString(),
      if (type.isNotEmpty) 'type': type,
      if (year.isNotEmpty) 'year': year,
      if (genre.isNotEmpty) 'genre': genre,
    };

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        final data = body['data'];
        return {
          'results': (data['results'] as List)
              .map((e) => Movie.fromJson(e))
              .toList(),
          'totalResults': data['totalResults'] ?? 0,
          'page': data['page'] ?? page,
          'totalPages': data['totalPages'] ?? 1,
        };
      }
    }
    throw Exception('Gagal mengambil data film');
  }

  Future<Map<String, dynamic>> getMoviesByGenre({
    required String genre,
    int page = 1,
    String type = '',
  }) async {
    final params = {
      'genre': genre,
      'page': page.toString(),
      if (type.isNotEmpty) 'type': type,
    };

    final uri = Uri.parse('$_baseUrl/genre').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        final data = body['data'];
        return {
          'results': (data['results'] as List)
              .map((e) => Movie.fromJson(e))
              .toList(),
          'totalResults': data['totalResults'] ?? 0,
          'page': data['page'] ?? page,
          'totalPages': data['totalPages'] ?? 1,
        };
      }
    }
    throw Exception('Gagal mengambil film berdasarkan genre');
  }

  Future<MovieDetail> getMovieById(String imdbId) async {
    final uri = Uri.parse('$_baseUrl/$imdbId');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        return MovieDetail.fromJson(body['data']);
      }
    }
    throw Exception('Film tidak ditemukan');
  }

  Future<MovieDetail> getMovieByTitle(String title, {String year = ''}) async {
    final params = <String, String>{};
    if (year.isNotEmpty) params['year'] = year;

    final uri = Uri.parse('$_baseUrl/title/${Uri.encodeComponent(title)}')
        .replace(queryParameters: params.isNotEmpty ? params : null);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        return MovieDetail.fromJson(body['data']);
      }
    }
    throw Exception('Film tidak ditemukan');
  }
}