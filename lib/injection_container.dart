import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stage_assignment/core/network/network_info.dart';
import 'package:stage_assignment/features/movie/data/datasources/local/movie_local_data_source.dart';
import 'package:stage_assignment/features/movie/data/datasources/remote/movie_remote_data_source.dart';
import 'package:stage_assignment/features/movie/data/models/movie_model.dart';
import 'package:stage_assignment/features/movie/data/repsitory/movie_repository_imp.dart';
import 'package:stage_assignment/features/movie/domain/repository/movie_repository.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_favourite_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_movie_details.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/search_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/toggle_favourite.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_detail/movie_details_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/movie_list_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Movie
  // Bloc
  sl.registerFactory(() => MovieListBloc(
        getMoviesUseCase: sl(),
        getFavoriteMoviesUseCase: sl(),
        searchMoviesUseCase: sl(),
      ));

  sl.registerFactory(() => MovieDetailsBloc(
        getMovieDetailsUseCase: sl(),
        toggleFavoriteUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetFavouriteMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl(), sl(), sl()),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': '49d45d8d4d4baba62575d744fde85ad0',
    },
  ));
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Initialize Hive
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MovieModelAdapter());
  final movieBox = await Hive.openBox<MovieModel>('movies');
  sl.registerLazySingleton(() => movieBox);
}
