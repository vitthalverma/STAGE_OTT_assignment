import 'package:stage_assignment/core/errors/exceptions.dart';
import 'package:stage_assignment/features/movie/data/models/movie_model.dart';
import 'package:dio/dio.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies();
  Future<MovieModel> getMovieDetails(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<MovieModel> getMovieDetails(int id) async {
    try {
      final response = await dio.get('/movie/$id');
      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to load movie details');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<List<MovieModel>> getMovies() async {
    try {
      final response = await dio.get('/movie/popular');
      if (response.statusCode == 200) {
        final movies = response.data['results'] as List;
        return movies.map((movie) => MovieModel.fromJson(movie)).toList();
      }
      throw ServerException('Failed to load popular movies');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((movie) => MovieModel.fromJson(movie)).toList();
      } else {
        throw ServerException('Failed to search movies');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error occurred');
    }
  }
}
