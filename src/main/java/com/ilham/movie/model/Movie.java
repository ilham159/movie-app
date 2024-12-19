package com.ilham.movie.model;

import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.annotation.Id;

import java.util.List;

@Document(collection = "movies")
public class Movie {
    @Id
    private String id;
    private String title;
    private String director;
    private String summary;
    private String imageUrl;
    private List<String> genres;
}
