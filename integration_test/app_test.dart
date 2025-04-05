import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/favourite_button.dart';
import 'package:stage_assignment/main.dart' as app;
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid_item.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('STAGE OTT ASSIGNMENT COMPLETE TEST', () {
    testWidgets('full movie app flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Movie list screen
      expect(find.text('Movies'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify at least one movie item
      expect(find.byType(MovieGridItem), findsWidgets);

      // Navigate to details
      await tester.tap(find.byType(MovieGridItem).first);
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      // Go back to movie list
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Movies'), findsOneWidget);

      //favorite a movie
      await tester.tap(find.byType(FavoriteButton).first);
      await tester.pumpAndSettle();

      // Switch to favorites tab
      await tester.tap(find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.favorite_border),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(MovieGridItem), findsWidgets);

      // Switch back to all movies
      await tester.tap(find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.favorite),
      ));

      await tester.pumpAndSettle();
      expect(find.byType(MovieGridItem), findsWidgets);

      // Search functionality
      await tester.enterText(find.byType(TextField), 'Star');
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(MovieGridItem), findsWidgets);

      // Clear the search
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(MovieGridItem), findsWidgets);
    });
  });
}
