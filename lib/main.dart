import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_detail/movie_details_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/movie_list_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/screens/movie_list_screen.dart';
import 'package:stage_assignment/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<MovieListBloc>()..add(LoadMoviesEvent())),
        BlocProvider(create: (context) => sl<MovieDetailsBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MovieListScreen(),
      ),
    );
  }
}
