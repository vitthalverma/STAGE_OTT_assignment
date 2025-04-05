import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stage_assignment/main.dart' as app;
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid_item.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('STAGE OTT App Integration Test', () {
    testWidgets(
        'Test movie list loading, detail navigation, search, and favorites',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the app is loaded
      expect(find.text('Movies'), findsOneWidget);

      // Wait for movies to load
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(GridView), findsOneWidget);

      if (find.byType(GridView).evaluate().isNotEmpty) {
        // Tap on the first movie
        final firstMovieCard = find.byType(MovieCard).first;
        final movieTitleFinder = find.descendant(
          of: firstMovieCard,
          matching: find.byType(Text),
        );
        final movieTitle =
            tester.firstWidget<Text>(movieTitleFinder).data ?? '';

        await tester.tap(firstMovieCard);
        await tester.pumpAndSettle();

        // Verify detail page
        expect(find.text('Overview'), findsOneWidget);

        // Tap favorite button
        await tester.tap(find.byIcon(Icons.favorite_border).last);
        await tester.pumpAndSettle();

        // Verify favorite icon is shown
        expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));

        // Go back to movie list
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Verify back on movie list page
        expect(find.text('Movies'), findsOneWidget);

        // Check favorite status in movie list
        final updatedMovieCard = find.ancestor(
          of: find.text(movieTitle),
          matching: find.byType(MovieCard),
        );
        final favoriteIconInCard = find.descendant(
          of: updatedMovieCard,
          matching: find.byIcon(Icons.favorite),
        );
        expect(favoriteIconInCard, findsOneWidget);
      }

      // Test search functionality
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Avengers');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(MovieCard), findsWidgets);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Test favorites tab
      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieCard), findsWidgets);
    });
  });
}
