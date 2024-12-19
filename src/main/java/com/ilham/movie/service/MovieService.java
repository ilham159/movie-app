package com.ilham.movie.service; // Use the appropriate package

import com.ilham.movie.model.Movie;
import com.ilham.movie.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MovieService {
    @Autowired
    private MovieRepository repository;

    public List<Movie> getAllMovies() {
        return repository.findAll();
    }

    // public List<Movie> searchMoviesByTitle(String title) {
    // return repository.findByTitleContainingIgnoreCase(title);
    // }

    public Movie saveMovie(Movie movie) {
        return repository.save(movie);
    }

    public void deleteMovie(String id) {
        repository.deleteById(id);
    }

    public Movie updateMovie(String id, Movie movieDetails) {
        return repository.findById(id).map(movie -> {
            movie.setTitle(movieDetails.getTitle());
            movie.setDirector(movieDetails.getDirector());
            movie.setSummary(movieDetails.getSummary());
            movie.setGenres(movieDetails.getGenres());
            movie.setImageUrl(movieDetails.getImageUrl());
            return repository.save(movie);
        }).orElseThrow(() -> new RuntimeException("Movie not found"));
    }
}
