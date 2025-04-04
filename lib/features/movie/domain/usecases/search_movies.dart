import 'package:fpdart/src/either.dart';
import 'package:stage_assignment/core/errors/failures.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/repository/movie_repository.dart';

class SearchMovies implements UseCase<List<Movie>, String> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(String query) async {
    return await repository.searchMovies(query);
  }
}
