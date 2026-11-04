import 'package:flutter/material.dart';

import 'attend.dart';
import 'bottom_navidation.dart';
import 'chatbot.dart';
import 'dashboard.dart';
import 'feedback.dart';
import 'grade.dart';
import 'tab_navigation.dart';

/// Persistent frame for the five main tabs.
///
/// The tabs live in an [IndexedStack], so switching is instant: no route is
/// pushed, no page transition is played, and each tab keeps its scroll
/// position, chat history and in-flight work instead of being rebuilt from
/// scratch on every tap.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _pages = <Widget>[
    DashboardPage(),
    GradePage(),
    ChatbotPage(),
    FeedbackPage(),
    AttendPage(),
  ];

  late int _index = widget.initialIndex;

  void _selectTab(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    // Typing in the chatbot closes the keyboard area, so hide the bar instead
    // of letting it float on top of the keyboard.
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return MainTabScope(
      selectTab: _selectTab,
      child: Scaffold(
        // Every tab has its own Scaffold; letting them handle the keyboard
        // avoids the body being resized twice when a text field is focused.
        resizeToAvoidBottomInset: false,
        body: MediaQuery.removePadding(
          context: context,
          // The bar below already covers the system bottom inset; without this
          // each tab's SafeArea would also pad for it, leaving a dead gap.
          removeBottom: true,
          child: IndexedStack(
            index: _index,
            children: [
              for (var i = 0; i < _pages.length; i++)
                // Pause animations in hidden tabs while keeping their state.
                TickerMode(enabled: i == _index, child: _pages[i]),
            ],
          ),
        ),
        bottomNavigationBar: keyboardOpen
            ? null
            : AppBottomNav(currentIndex: _index, onSelected: _selectTab),
      ),
    );
  }
}
