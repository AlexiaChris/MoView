class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String type;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'] ?? '',
      title: json['title'] ?? json['Title'] ?? '',
      year: json['year'] ?? json['Year'] ?? '',
      poster: json['poster'] ?? json['Poster'] ?? '',
      type: json['type'] ?? json['Type'] ?? '',
    );
  }
}

class MovieDetail {
  final String imdbID;
  final String title;
  final String year;
  final String genre;
  final String plot;
  final String poster;
  final String rottenTomatoesRating;
  final String imdbRating;

  MovieDetail({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.genre,
    required this.plot,
    required this.poster,
    required this.rottenTomatoesRating,
    required this.imdbRating,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      imdbID: json['imdbID'] ?? '',
      title: json['title'] ?? '',
      year: json['year'] ?? '',
      genre: json['genre'] ?? '',
      plot: json['plot'] ?? '',
      poster: json['poster'] ?? '',
      rottenTomatoesRating: json['rottenTomatoesRating'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
    );
  }

  List<String> get genreList =>
      genre.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();
}