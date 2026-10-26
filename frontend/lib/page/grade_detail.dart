import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../widgets/detail_parts.dart';
import '../widgets/states/empty_state.dart';

class GradeDetailPage extends StatefulWidget {
  const GradeDetailPage({super.key, required this.courseId});

  final int courseId;

  @override
  State<GradeDetailPage> createState() => _GradeDetailPageState();
}

class _GradeDetailPageState extends State<GradeDetailPage> {
  // Streams are created once; creating them inside build() would resubscribe
  // to the database on every rebuild.
  late final Stream<Course?> _course;
  late final Stream<List<Assessment>> _assessments;

  @override
  void initState() {
    super.initState();
    final repo = context.read<NexaRepository>();
    _course = repo.watchCourse(widget.courseId);
    _assessments = repo.watchAssessments(widget.courseId);
  }

  String _statusText(Assessment a) => switch (a.status) {
        AssessmentStatus.onTime => 'On-Time, ${a.score ?? 0}',
        AssessmentStatus.late => 'Late, ${a.score ?? 0}',
        AssessmentStatus.missing => "Didn't Submit",
      };

  StatusTone _tone(Assessment a) => switch (a.status) {
        AssessmentStatus.onTime => StatusTone.success,
        AssessmentStatus.late => StatusTone.average,
        AssessmentStatus.missing => StatusTone.fail,
      };

  List<Widget> _content(Course course, List<Assessment> items) {
    return [
      BigNumberCard(label: 'Grade', value: '${course.grade}'),
      const SizedBox(height: 16),
      StatBoxRow(
        children: [
          StatBox(label: 'Task', value: '${course.taskScore}', color: AppColor.SubjectGreen),
          StatBox(label: 'Attend', value: '${course.attendScore}', color: AppColor.SubjectBlue),
          StatBox(label: 'UTS', value: '${course.utsScore}', color: AppColor.SubjectPeach),
          StatBox(label: 'UAS', value: '${course.uasScore}', color: AppColor.SubjectPink),
        ],
      ),
      const SizedBox(height: 24),
      const DetailSectionTitle('Assignment Assessment'),
      const SizedBox(height: 12),
      if (items.isEmpty)
        const EmptyState(
          icon: Icons.emoji_events_outlined,
          message: 'There is no grade available for this course yet.',
        )
      else
        ...items.map(
          (a) => StatusRow(
            label: a.title,
            status: _statusText(a),
            tone: _tone(a),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: StreamBuilder<Course?>(
          stream: _course,
          builder: (context, courseSnap) {
            final course = courseSnap.data;
            return StreamBuilder<List<Assessment>>(
              stream: _assessments,
              builder: (context, listSnap) {
                // Loading = first DB event of either stream not delivered yet.
                final loading =
                    courseSnap.connectionState == ConnectionState.waiting ||
                        listSnap.connectionState == ConnectionState.waiting;
                final items = listSnap.data ?? const <Assessment>[];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      if (loading)
                        const DetailSkeleton()
                      else if (course == null)
                        const EmptyState(
                          icon: Icons.school_outlined,
                          message: 'This course is not available yet.',
                        )
                      else
                        ..._content(course, items),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}