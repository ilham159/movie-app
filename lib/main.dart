import 'package:flutter/material.dart';
import 'screens/movie_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieList(),
    );
  }
}
