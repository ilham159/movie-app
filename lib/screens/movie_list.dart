import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie_edit.dart'; // Add/Edit Movie Screen
import 'movie_create.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For working with files
import 'package:path_provider/path_provider.dart'; // For accessing device storage

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<dynamic> _movies = [];
  String _searchQuery = "";

  // Fetch movie data
  Future<void> _fetchMovies() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.8:8080/api/movies'));
    if (response.statusCode == 200) {
      setState(() {
        _movies = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Filter movies based on search query
  List<dynamic> get filteredMovies {
    if (_searchQuery.isEmpty) {
      return _movies;
    }
    return _movies.where((movie) {
      return movie['title'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies(); // Fetch movie data on page load
  }

  // This is for saving images locally in the device
  Future<String> _saveImageToLocalFile(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File('$path/$fileName');

    await imageFile.copy(file.path); // Save to local storage
    return file.path; // Return file path for further use
  }

  // Pick image and show a result
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      // Save the image to local storage
      String savedImagePath = await _saveImageToLocalFile(image);
      print('Image saved at $savedImagePath');
      // You can implement a call to your API to upload this image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Movie Collection", // Adjusted title style to match Netflix
          style: TextStyle(
            fontSize: 28, // Large title
            fontWeight: FontWeight.bold, // Bold text for prominence
            letterSpacing: 2, // Space between letters for a sleek design
            color: Colors.white, // White text to ensure visibility
            fontFamily:
                'Roboto', // Choose a sleek font similar to Netflix (you can also use "Arial")
          ),
        ),
        backgroundColor: Color(0xFF141414), // Dark background like Netflix
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Change to white
          onPressed: () {
            Navigator.pop(context); // Pop to previous screen with white arrow
          },
        ),
      ),
      backgroundColor: Color(0xFF141414), // Dark background for main screen
      body: Column(
        children: [
          // Search Bar with a cleaner style and white text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              style: TextStyle(color: Colors.white), // White text color
              decoration: InputDecoration(
                labelText: 'Search Movies',
                labelStyle:
                    TextStyle(color: Colors.white), // Search label color
                hintText: 'Search by title...',
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5)), // Hint text color
                filled: true,
                fillColor: Colors.black
                    .withOpacity(0.5), // Background color for search bar
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                var movie = filteredMovies[index];
                String title = movie['title'] ?? 'No Title Available';
                String director = movie['director'] ?? 'Director Unknown';
                String imageUrl = movie['imageUrl'] ?? '';
                List<String> genres = List<String>.from(movie['genres'] ?? []);

                return GestureDetector(
                  onTap: () {
                    // Navigate to movie edit screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieEditScreen(movieId: movie['id']),
                      ),
                    ).then((_) {
                      // Refresh the list after returning from MovieEditScreen
                      _fetchMovies();
                    });
                  },
                  child: Card(
                    elevation: 5,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Movie image thumbnail
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/default_image.jpg')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // Title, Director, and Genre position on top of the image
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white, // White text color
                                  overflow: TextOverflow.ellipsis,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                director,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors
                                      .white70, // Light gray for description
                                  overflow: TextOverflow.ellipsis,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Genres at the bottom-right corner
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Text(
                            genres.join(', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              backgroundColor: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to movie add screen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieCreateScreen()),
          ).then((_) {
            // Refresh the list after adding a new movie
            _fetchMovies();
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
