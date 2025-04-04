import 'package:fpdart/fpdart.dart';
import 'package:stage_assignment/core/errors/failures.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/repository/movie_repository.dart';

class GetMovieDetails implements UseCase<Movie, int> {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, Movie>> call(int params) async {
    return await repository.getMovieDetails(params);
  }
}
