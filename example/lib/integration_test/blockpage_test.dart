import 'package:checkapp_plugin_example/features/create_block/presentation/pages/create_block_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  // ···
  group('end-to-end test for create block page', () {
    testWidgets(
        'verify search icon exists at app screen, but disappears at other screen',
        (tester) async {
      // Load app widget.
      await tester.pumpWidget(const CreateBlockPage(
        extra: {},
      ));
//  verify search icon exists  at app screen
      expect(find.byIcon(Icons.search) as Function(dynamic p1), findsOneWidget);
      // Click on the search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      // Verify the search icon disappears
      expect(find.byIcon(Icons.search) as Function(dynamic p1), findsNothing);
      //  click website tab
      await tester.tap(find.byKey(const ValueKey('Websites')));
      expect(find.byIcon(Icons.search) as Function(dynamic p1), findsNothing);
    });
  });
}
