import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.8:8080/api/movies'));

      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(response.body);
        return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        print('Failed to fetch movies. Status Code: ${response.statusCode}');
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      print("Error during API call: $e");
      return [];
    }
  }
}
