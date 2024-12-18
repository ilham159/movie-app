import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieEditScreen extends StatefulWidget {
  final String movieId;

  MovieEditScreen({required this.movieId});

  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Initial values of the form (initially blank or default)
  String _title = '';
  String _director = '';
  String _summary = '';
  String _imageUrl = '';
  List<String> _genres = ['Action', 'Drama', 'Comedy', 'Sci-Fi', 'Adventure'];
  List<String> _selectedGenres = [];
  bool _isLoading = true; // This flag will help in handling the loading state

  // Function to handle movie data update (communication with MongoDB API)
  Future<void> _updateMovie() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.put(
      Uri.parse(
          'http://192.168.0.8:8080/api/movies/${widget.movieId}'), // Update movie by movieId
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': _title,
        'director': _director,
        'summary': _summary,
        'genres': _selectedGenres,
        'imageUrl': _imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      // Movie update is successful
      print("Movie Updated Successfully!");
      Navigator.pop(context); // Go back to the movie list after update
    } else {
      print("Failed to update movie.");
    }
  }

  // Fetch movie details for editing (Populate form data)
  Future<void> _fetchMovieDetails() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.8:8080/api/movies/${widget.movieId}'));

    if (response.statusCode == 200) {
      final movie = json.decode(response.body);

      setState(() {
        _title = movie['title'];
        _director = movie['director'];
        _summary = movie['summary'];
        _imageUrl = movie['imageUrl'];
        _selectedGenres = List<String>.from(movie['genres']);
        _isLoading =
            false; // Set loading to false after the data has been fetched
      });
    } else {
      print("Failed to fetch movie details.");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch movie details when editing
    if (widget.movieId.isNotEmpty) {
      _fetchMovieDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Movie'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Color(0xFF141414),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show loader while fetching
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Input
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        labelText: 'Movie Title',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.6),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a movie title.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _title = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Director Input
                    TextFormField(
                      initialValue: _director,
                      decoration: InputDecoration(
                        labelText: 'Director',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.6),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a director.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _director = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Summary Input
                    TextFormField(
                      initialValue: _summary,
                      decoration: InputDecoration(
                        labelText: 'Summary',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.6),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _summary = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Image URL Input
                    TextFormField(
                      initialValue: _imageUrl,
                      decoration: InputDecoration(
                        labelText: 'Image URL (assets)',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.6),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _imageUrl = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Genre selection (with multiple selections)
                    Text(
                      'Select Genres:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: _genres.map((genre) {
                        return ChoiceChip(
                          label: Text(
                            genre,
                            style: TextStyle(
                              color: _selectedGenres.contains(genre)
                                  ? Colors.green
                                  : Colors.white,
                              fontWeight: _selectedGenres.contains(genre)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: _selectedGenres.contains(genre),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGenres.add(genre);
                              } else {
                                _selectedGenres.remove(genre);
                              }
                            });
                          },
                          selectedColor: Colors.green,
                          backgroundColor: Colors.grey[800],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),

                    // Summary Section to display the filled information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Movie Summary:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Title: $_title',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Director: $_director',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Summary: $_summary',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Genres: ${_selectedGenres.join(', ')}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Image URL: $_imageUrl',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _updateMovie, // Call updateMovie function
                      child: Text('Update Movie'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
