class Movie {
  final String id;
  final String title;
  final String director;
  final String summary;
  final List<String> genres;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.summary,
    required this.genres,
    required this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      director: json['director'] ?? '',
      summary: json['summary'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
