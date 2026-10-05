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
///
/// Visual style: the active tab's icon "pops up" above the bar in a
/// floating white circle (overlapping the bar's top edge), with its
/// label shown underneath — similar to a bubble-nav interaction.
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
      _NavItemData(icon: Icons.home_outlined, label: 'Home'),
      _NavItemData(icon: Icons.pie_chart_outline, label: 'Analytic'),
      _NavItemData(icon: Icons.workspace_premium_outlined, label: 'Grade'),
      _NavItemData(icon: Icons.chat_outlined, label: 'Feedback'),
      _NavItemData(icon: Icons.account_box_outlined, label: 'Attend'),
    ];

    // Extra top padding so the floating bubble has room to overlap the bar
    // without getting clipped by whatever is above it on the page.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 20),
      child: Container(
        height: 70,
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          color: AppColor.Primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColor.Primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => _go(context, i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 60,
                height: 70,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (active) ...[
                      Positioned(
                        top: -24,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColor.Background,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              items[i].icon,
                              size: 28,
                              color: AppColor.Primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 32,
                        left: 0,
                        right: 0,
                        child: Text(
                          items[i].label,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.button.copyWith(
                            color: AppColor.Background,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ] else
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Icon(
                            items[i].icon,
                            size: 26,
                            color: AppColor.TextSecondary.withOpacity(0.55),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData({required this.icon, required this.label});
}