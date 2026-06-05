import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../pages/detail_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(imdbId: movie.imdbID)),
    );
  },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildPoster(),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  movie.type.isNotEmpty
                      ? movie.type[0].toUpperCase() + movie.type.substring(1)
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFB1B1B1),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    if (movie.poster.isNotEmpty && movie.poster != 'N/A') {
      return Image.network(
        movie.poster,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholderPoster(),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _loadingPoster();
        },
      );
    }
    return _placeholderPoster();
  }

  Widget _placeholderPoster() {
    return Container(
      color: const Color(0xFF380056),
      child: const Center(
        child: Icon(Icons.movie_rounded, color: Color(0xFFA600FF), size: 36),
      ),
    );
  }

  Widget _loadingPoster() {
    return Container(
      color: const Color(0xFF380056),
      child: const Center(
        child: SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2, color: Color(0xFFA600FF),
          ),
        ),
      ),
    );
  }
}