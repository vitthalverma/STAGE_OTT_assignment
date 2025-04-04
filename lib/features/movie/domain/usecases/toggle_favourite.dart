import 'package:fpdart/fpdart.dart';
import 'package:stage_assignment/core/errors/failures.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/repository/movie_repository.dart';

class ToggleFavorite implements UseCase<bool, Movie> {
  final MovieRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, bool>> call(Movie params) async {
    return await repository.toggleFavorite(params);
  }
}
