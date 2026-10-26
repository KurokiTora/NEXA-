import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
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

  Color _statusColor(Assessment a) => switch (a.status) {
        AssessmentStatus.onTime => AppColor.Success,
        AssessmentStatus.late => AppColor.Average,
        AssessmentStatus.missing => AppColor.Fail,
      };

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
                final items = listSnap.data ?? const <Assessment>[];
                final empty = course == null || items.isEmpty;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      BigNumberCard(
                        label: 'Grade',
                        value: empty ? '00' : '${course.grade}',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          StatBox(label: 'Task', value: empty ? '0' : '${course.taskScore}', color: AppColor.SubjectGreen),
                          StatBox(label: 'Attend', value: empty ? '0' : '${course.attendScore}', color: AppColor.SubjectBlue),
                          StatBox(label: 'UTS', value: empty ? '0' : '${course.utsScore}', color: AppColor.SubjectPurple),
                          StatBox(label: 'UAS', value: empty ? '0' : '${course.uasScore}', color: AppColor.SubjectYellow),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Assignment Assessment',
                        style: AppTextStyles.subheading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
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
                            color: _statusColor(a),
                          ),
                        ),
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