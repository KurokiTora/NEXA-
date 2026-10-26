import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/widgets/states/empty_state.dart';

void main() {
  testWidgets('EmptyState shows its icon and message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.inbox_outlined,
            message: 'No grade available yet.',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.text('No grade available yet.'), findsOneWidget);
  });
}
