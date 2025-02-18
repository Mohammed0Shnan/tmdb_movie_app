
import 'package:tmdb_movie_app/features/movies/data/models/movie_model.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';

Map<String, dynamic> mockMoviesEntityJson() {
  return {
    'results': [
      {
        'id': 1,
        'title': 'Movie 1',
        'overview': 'Overview of Movie 1',
        'poster_path': '/path/to/poster',
        'vote_average': 8.0,
        'release_date': '2022-01-01',
      },
      {
        'id': 2,
        'title': 'Movie 2',
        'overview': 'Overview of Movie 2',
        'poster_path': '/path/to/poster',
        'vote_average': 7.5,
        'release_date': '2022-01-02',
      },
    ],
    'total_results': 2,
    'total_pages': 1,
  };
}
MoviesEntity mockMoviesEntity() {
  return MoviesEntity(
    items: [
      Movie(
        id: 1,
        title: 'Movie 1',
        overview: 'Overview of Movie 1',
        posterPath: 'poster1.jpg',
        backdropPath: 'backdrop1.jpg',
        voteAverage: 8.0,
        releaseDate: '2022-01-01',
        genreIds: [28, 35],
        adult: false,
        originalLanguage: 'en',
        originalTitle: 'Original Movie 1',
        popularity: 10.0,
        video: false,
      ),
      Movie(
        id: 2,
        title: 'Movie 2',
        overview: 'Overview of Movie 2',
        posterPath: 'poster2.jpg',
        backdropPath: 'backdrop2.jpg',
        voteAverage: 7.5,
        releaseDate: '2022-01-02',
        genreIds: [18, 27],
        adult: false,
        originalLanguage: 'en',
        originalTitle: 'Original Movie 2',
        popularity: 12.0,
        video: false,
      ),
    ],
    totalResult: 2,
    totalPages: 1,
  );
}

MoviesModel mockMoviesModel() {
  return MoviesModel(
    items: [
      MovieModel(
        id: 1,
        title: 'Movie 1',
        overview: 'Overview of Movie 1',
        posterPath: 'poster1.jpg',
        backdropPath: 'backdrop1.jpg',
        voteAverage: 8.0,
        releaseDate: '2022-01-01',
        genreIds: [28, 35],
        adult: false,
        originalLanguage: 'en',
        originalTitle: 'Original Movie 1',
        popularity: 10.0,
        video: false,
      ),

    ],
    totalResults: 1,
    totalPages: 1,
  );
}
Movie mockMovieDetailsModel(){
 return Movie(
    id: 1,
    title: 'Movie 2',
    overview: 'Overview of Movie 2',
    posterPath: 'poster2.jpg',
    backdropPath: 'backdrop2.jpg',
    voteAverage: 7.5,
    releaseDate: '2022-01-02',
    genreIds: [18, 27],
    adult: false,
    originalLanguage: 'en',
    originalTitle: 'Original Movie 2',
    popularity: 12.0,
    video: false,
  );
}

List<Movie> mockPopularHList(){
  return [

    Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      posterPath: '/test_path.jpg',
      backdropPath: '/test_backdrop.jpg',
      releaseDate: '2024-01-01',
      genreIds: [18, 27],
      adult: false,
      originalLanguage: 'en',
      originalTitle: 'Original Movie 2',
      popularity: 12.0,
      video: false,
      voteAverage: 7.5,

    ),
    Movie(
      id: 2,
      title: 'Test Movie 2',
      overview: 'Test Overview 2',
      posterPath: '/test_path2.jpg',
      backdropPath: '/test_backdrop2.jpg',
      releaseDate: '2024-01-02',
      voteAverage: 7.5,
      genreIds: [18, 27],
      adult: false,
      originalLanguage: 'en',
      originalTitle: 'Original Movie 2',
      popularity: 12.0,
      video: false,
    ),

   ];
}


