import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_event.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/pages/create_block_page.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_block/repository/app_repository.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_bloc.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_event.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/home_screen.dart';
import 'package:checkapp_plugin_example/repository/database_repository/database_repository.dart';
import 'package:checkapp_plugin_example/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

Future<void> loadPage(WidgetTester tester,String routeName) async {
  // Load app widget.
  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AppRepository(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: true,
            child: const CreateBlockPage(
              extra: {},
            ),
            create: (context) => AppsBloc(
              RepositoryProvider.of<AppRepository>(context),
            )..add(
                LoadApps(),
              ),
          ),
          BlocProvider(
            lazy: true,
            child: HomeScreen(),
            create: (context) => SchedulesBloc(
              RepositoryProvider.of<DatabaseRepository>(context),
            )..add(LoadSchedules()),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );
  GoRouter.of(tester.element(find.byType(Navigator))).goNamed(routeName);

  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test for create block page, app screen', () {
    testWidgets(
        'verify search icon exists at app screen and filter works correctly',
        (tester) async {
      await loadPage(tester,'create-block');
//  verify search icon exists  at app screen
      expect(find.byIcon(Icons.search), findsOneWidget);
      // Click on the search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      final filterInput = find.byKey(const Key("Filter"));
      expect(filterInput, findsOneWidget);
      final filterTextInput = filterInput.evaluate().single.widget as TextField;
      //  filter
      filterTextInput.controller?.text = "Camera";
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('Camera')), findsOneWidget);
    });
    testWidgets(
        'end-to-end test for create block page, navigating between screens',
        (tester) async {
      await loadPage(tester,'create-block');
      Future<void> navigateScreen(String text, String screenKey) async {
        final websiteTabFinder = find.descendant(
          of: find.byKey(const Key("Tab Bar")),
          matching: find.text(text),
          skipOffstage: false,
        );
        expect(websiteTabFinder, findsOneWidget);
        await tester.tap(websiteTabFinder);
        await tester.pumpAndSettle();
        // Verify the website screen is present
        expect(find.byKey(Key(screenKey)), findsOneWidget);
      }

      // navigate website
      await navigateScreen("Websites", "Website Screen");
      await navigateScreen("Keywords", "Keyword Screen");
      await navigateScreen("Partial Blocking", "Partial Blocking Screen");
    });

    testWidgets('end-to-end test for create block page, submitting block page',
        (tester) async {
      await loadPage(tester,'create-block');

      await tester.tap(find.text("Save Blocklist"));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text("Okay"));
      await tester.pumpAndSettle();
// nothing selected - error modal
      expect(find.byType(AlertDialog), findsNothing);
      // tick checkbox - success case
      final appRow = find
          .descendant(
            of: find.byKey(const Key("App Checkboxes")),
            matching: find.byType(AppRow),
            skipOffstage: false,
          )
          .first;
      await tester.tap(appRow);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Save Blocklist"));
      await tester.pumpAndSettle();
      expect(find.byType(CreateBlockPage), findsNothing);
    });
  });
}
