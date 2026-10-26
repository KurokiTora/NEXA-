import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/performance_summary.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/course_list_screen.dart';
import 'attend_detail.dart';

class AttendPage extends StatelessWidget {
  const AttendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<List<Course>>();
    final summary = PerformanceSummary.fromCourses(courses);

    return CourseListScreen(
      title: 'My Attendance',
      subtitle: 'Track your class attendance and stay consistent',
      navIndex: 4,
      courses: courses,
      cardLabel: 'Overall Attendance',
      cardValue: summary.hasData ? '${summary.averageAttendance}%' : '-',
      extra: Row(
        children: [
          _countBox(Icons.check_circle, '${summary.totalAttend}', 'Attend', AppColor.Success),
          _countBox(Icons.assignment_outlined, '${summary.totalPermit}', 'Permit', AppColor.SubjectBlue),
          _countBox(Icons.event_busy, '${summary.totalSick}', 'Sick', AppColor.Average),
          _countBox(Icons.cancel, '${summary.totalAlpha}', 'Alpha', AppColor.Fail),
        ],
      ),
      onCourseTap: (course) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendDetailPage(courseId: course.id),
        ),
      ),
    );
  }

  Widget _countBox(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColor.TextBody),
            Text(value, style: AppTextStyles.subheading.copyWith(fontSize: 18)),
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
