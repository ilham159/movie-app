import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  MovieDetailsScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display movie details here based on movieId
            Text('Movie ID: $movieId'),
            // You can make a network call to fetch more details using the movieId
          ],
        ),
      ),
    );
  }
}
