import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieCreateScreen extends StatefulWidget {
  @override
  _MovieCreateScreenState createState() => _MovieCreateScreenState();
}

class _MovieCreateScreenState extends State<MovieCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Initial empty data
  String _title = '';
  String _director = '';
  String _summary = '';
  String _imageUrl = '';
  List<String> _genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Adventure'
  ]; // Available genres
  List<String> _selectedGenres = []; // Start with no selected genres

  // Sample function for creating a movie (it communicates with MongoDB API)
  Future<void> _createMovie() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse(
          'http://192.168.0.8:8080/api/movies'), // Replace with actual backend API URL
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
      // If movie is created successfully
      print("Movie Created Successfully!");
      Navigator.pop(context); // Go back after successful creation
    } else {
      print("Failed to create movie.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Movie'),
        backgroundColor: Colors.green,
      ),
      backgroundColor:
          Color(0xFF141414), // Keeping the background dark like before
      body: Padding(
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
                style: TextStyle(color: Colors.white), // Text should be white
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
                style: TextStyle(color: Colors.white), // Text should be white
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
                style: TextStyle(color: Colors.white), // Text should be white
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
                style: TextStyle(color: Colors.white), // Text should be white
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

              // Genre selection with multiple options and bold font for selected genres
              Text(
                'Select Genres:',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                onPressed: _createMovie, // Call the createMovie function
                child: Text('Add Movie'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
