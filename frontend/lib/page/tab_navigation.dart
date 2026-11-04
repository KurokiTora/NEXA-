import 'package:flutter/widgets.dart';

/// Gives widgets inside the main tabs a way to switch tabs without pushing a
/// new route. Pushing would rebuild the whole page (and play a page
/// transition) even though the bottom bar is already on screen.
class MainTabScope extends InheritedWidget {
  const MainTabScope({
    super.key,
    required this.selectTab,
    required super.child,
  });

  final ValueChanged<int> selectTab;

  /// Switches to [index]. Does nothing when not inside the main shell.
  static void select(BuildContext context, int index) {
    context.getInheritedWidgetOfExactType<MainTabScope>()?.selectTab(index);
  }

  @override
  bool updateShouldNotify(MainTabScope oldWidget) =>
      selectTab != oldWidget.selectTab;
}
