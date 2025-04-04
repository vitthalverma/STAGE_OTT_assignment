import 'package:fpdart/fpdart.dart';
import 'package:stage_assignment/core/errors/failures.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/repository/movie_repository.dart';

class GetFavouriteMovies implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  GetFavouriteMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
