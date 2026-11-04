import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/page/bottom_navidation.dart';

class _NavHarness extends StatefulWidget {
  const _NavHarness();

  @override
  State<_NavHarness> createState() => _NavHarnessState();
}

class _NavHarnessState extends State<_NavHarness> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('tab $_index')),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _index,
          onSelected: (index) => setState(() => _index = index),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('ball jump switches tabs without errors', (tester) async {
    await tester.pumpWidget(const _NavHarness());
    expect(find.text('tab 0'), findsOneWidget);

    await tester.tap(find.text('Grade'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    expect(find.text('tab 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('jump can be interrupted by another tap', (tester) async {
    await tester.pumpWidget(const _NavHarness());

    await tester.tap(find.text('Grade'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Attend'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    expect(find.text('tab 4'), findsOneWidget);
  });
}
