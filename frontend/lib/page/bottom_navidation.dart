import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'dashboard.dart';
import 'analytic.dart';
import 'grade.dart';
import 'feedback.dart';
import 'attend.dart';

/// Shared bottom navigation bar for the 5 main tabs.
/// index: 0 = Home, 1 = Analytic, 2 = Grade, 3 = Feedback, 4 = Attend
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;

    late final Widget page;
    switch (index) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = const AnalyticPage();
        break;
      case 2:
        page = const GradePage();
        break;
      case 3:
        page = const FeedbackPage();
        break;
      case 4:
      default:
        page = const AttendPage();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(icon: Icons.home_outlined, label: 'HOME'),
      _NavItemData(icon: Icons.pie_chart_outline, label: 'ANALYTIC'),
      _NavItemData(icon: Icons.workspace_premium_outlined, label: 'GRADE'),
      _NavItemData(icon: Icons.chat_outlined, label: 'FEEDBACK'),
      _NavItemData(icon: Icons.account_box_outlined, label: 'ATTEND'),
    ];

    return Container(
  margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
  height: 78,
  decoration: BoxDecoration(
    color: AppColor.Primary,
    borderRadius: BorderRadius.circular(24),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: List.generate(items.length, (i) {
      final active = i == currentIndex;

      return GestureDetector(
        onTap: () => _go(context, i),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (active)
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColor.Background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    items[i].icon,
                    size: 27,
                    color: AppColor.TextBody,
                  ),
                )
              else
                Icon(
                  items[i].icon,
                  size: 28,
                  color: AppColor.TextSecondary,
                ),

              if (active)
                Text(
                  items[i].label,
                  style: AppTextStyles.button.copyWith(
                    color: AppColor.TextSecondary,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ),
      );
    }),
  ),
);
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData({required this.icon, required this.label});
}
