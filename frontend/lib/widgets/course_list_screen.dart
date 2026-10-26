import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../page/bottom_navidation.dart';
import '../state/sync_state.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'course_score_row.dart';
import 'states/empty_state.dart';
import 'states/refresh_helper.dart';

/// Layout shared by the Grade, Attend and Feedback tabs:
/// title, blue summary card, optional extra block, "By Subject" bar and the
/// course list (pull down to sync with the backend).
class CourseListScreen extends StatelessWidget {
  const CourseListScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.navIndex,
    required this.courses,
    required this.cardLabel,
    required this.cardValue,
    required this.onCourseTap,
    this.cardValueSize = 32,
    this.extra,
  });

  final String title;
  final String subtitle;
  final int navIndex;
  final List<Course> courses;
  final String cardLabel;
  final String cardValue;
  final double cardValueSize;
  final Widget? extra;
  final void Function(Course course) onCourseTap;

  @override
  Widget build(BuildContext context) {
    final isSyncing = context.select<SyncState, bool>((s) => s.isRefreshing);

    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => refreshWithFeedback(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading.copyWith(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body
                      .copyWith(fontSize: 13, color: AppColor.Primary),
                ),
                const SizedBox(height: 16),
                _summaryCard(),
                if (extra != null) ...[const SizedBox(height: 16), extra!],
                const SizedBox(height: 16),
                _bySubjectBar(),
                const SizedBox(height: 8),
                if (courses.isEmpty)
                  isSyncing
                      ? const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const EmptyState(
                          icon: Icons.menu_book_outlined,
                          message: 'No courses yet.\nPull down to refresh.',
                        )
                else
                  ...courses.map(
                    (c) => CourseScoreRow(course: c, onTap: () => onCourseTap(c)),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: navIndex),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.Secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColor.Primary,
            child: Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cardLabel, style: AppTextStyles.body.copyWith(fontSize: 12)),
                Text(
                  cardValue,
                  style: AppTextStyles.heading.copyWith(fontSize: cardValueSize),
                ),
                Text(
                  'Great Progress! Keep it up!',
                  style: AppTextStyles.body
                      .copyWith(fontSize: 11, color: AppColor.Primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bySubjectBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.Primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_outlined, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'By Subject',
            style: AppTextStyles.subheading
                .copyWith(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
