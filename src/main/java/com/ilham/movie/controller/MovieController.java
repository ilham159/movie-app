package com.ilham.movie.controller;

import com.ilham.movie.model.Movie;
import com.ilham.movie.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/movies")
public class MovieController {

    private final MovieRepository movieRepository;

    @Autowired
    public MovieController(MovieRepository movieRepository) {
        this.movieRepository = movieRepository;
    }

    // POST: Add a new movie
    @PostMapping
    public Movie createMovie(@RequestBody Movie movie) {
        return movieRepository.save(movie);
    }

    // PUT: Update an existing movie by ID
    @PutMapping("/{id}")
    public ResponseEntity<Movie> updateMovie(@PathVariable String id, @RequestBody Movie movie) {
        Optional<Movie> existingMovie = movieRepository.findById(id);

        if (!existingMovie.isPresent()) {
            return ResponseEntity.status(404).body(null); // Return 404 if the movie is not found
        }

        Movie updatedMovie = existingMovie.get();
        updatedMovie.setTitle(movie.getTitle());
        updatedMovie.setDirector(movie.getDirector());
        updatedMovie.setSummary(movie.getSummary());
        updatedMovie.setImageUrl(movie.getImageUrl());
        updatedMovie.setGenres(movie.getGenres());

        movieRepository.save(updatedMovie);
        return ResponseEntity.ok(updatedMovie); // Return the updated movie
    }

    // DELETE: Delete a movie by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteMovie(@PathVariable String id) {
        if (movieRepository.existsById(id)) {
            movieRepository.deleteById(id);
            return ResponseEntity.ok("Movie deleted successfully."); // Return success message
        } else {
            return ResponseEntity.status(404).body("Movie not found."); // Return 404 if movie not found
        }
    }

    // Fetch a movie by its ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getMovieById(@PathVariable String id) {
        // Attempt to retrieve the movie from the database
        Optional<Movie> movieOptional = movieRepository.findById(id);

        // Check if the movie exists and return 200 OK with the movie
        if (movieOptional.isPresent()) {
            Movie movie = movieOptional.get();
            return ResponseEntity.ok(movie); // if movie found, return 200 OK with the movie
        } else {
            // If the movie does not exist, return a 404 response with an error message
            return ResponseEntity.status(404).body("Movie not found with ID: " + id);
        }
    }

    // Fetch all movies
    @GetMapping("")
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<Movie> movies = movieRepository.findAll(); // Fetch all movies from the repository
        if (movies.isEmpty()) {
            return ResponseEntity.noContent().build(); // If no movies found, return 204 No Content
        }
        return ResponseEntity.ok(movies); // Return the list of movies as 200 OK
    }

    // Search movies by title
    @GetMapping("/search")
    public ResponseEntity<List<Movie>> searchMoviesByTitle(@RequestParam String title) {
        // Use the MovieRepository to find movies matching the title
        List<Movie> movies = movieRepository.findByTitleContainingIgnoreCase(title);
        if (movies.isEmpty()) {
            return ResponseEntity.status(404).body(null); // If no movies found, return 404 not found
        }
        return ResponseEntity.ok(movies); // Return the list of movies found as 200 OK
    }
}
