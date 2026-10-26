import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/performance_summary.dart';
import '../widgets/course_list_screen.dart';
import 'grade_detail.dart';

class GradePage extends StatelessWidget {
  const GradePage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<List<Course>>();
    final summary = PerformanceSummary.fromCourses(courses);

    return CourseListScreen(
      title: 'My Grades',
      subtitle: 'Track your learning progress and achievement',
      navIndex: 1,
      courses: courses,
      cardLabel: 'Currently on average',
      cardValue: summary.hasData ? '${summary.averageGrade}' : '-',
      onCourseTap: (course) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GradeDetailPage(courseId: course.id),
        ),
      ),
    );
  }
}
