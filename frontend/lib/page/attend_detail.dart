import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../widgets/detail_parts.dart';
import '../widgets/states/empty_state.dart';

class AttendDetailPage extends StatefulWidget {
  const AttendDetailPage({super.key, required this.courseId});

  final int courseId;

  @override
  State<AttendDetailPage> createState() => _AttendDetailPageState();
}

class _AttendDetailPageState extends State<AttendDetailPage> {
  late final Stream<Course?> _course;
  late final Stream<List<AttendanceLog>> _history;

  @override
  void initState() {
    super.initState();
    final repo = context.read<NexaRepository>();
    _course = repo.watchCourse(widget.courseId);
    _history = repo.watchAttendance(widget.courseId);
  }

  String _statusText(AttendanceStatus s) => switch (s) {
        AttendanceStatus.attend => 'Attend',
        AttendanceStatus.permit => 'Permit',
        AttendanceStatus.sick => 'Sick',
        AttendanceStatus.alpha => 'Alpha',
      };

  StatusTone _tone(AttendanceStatus s) => switch (s) {
        AttendanceStatus.attend => StatusTone.success,
        AttendanceStatus.permit => StatusTone.info,
        AttendanceStatus.sick => StatusTone.average,
        AttendanceStatus.alpha => StatusTone.fail,
      };

  List<Widget> _content(Course course, List<AttendanceLog> items) {
    return [
      BigNumberCard(label: 'Attendance', value: '${course.attendPercent}%'),
      const SizedBox(height: 16),
      StatBoxRow(
        children: [
          StatBox(
            label: 'Attend',
            value: '${course.attendCount}',
            color: AppColor.SubjectGreen,
            icon: Icons.check_box_rounded,
            iconColor: AppColor.SuccessBorder,
          ),
          StatBox(
            label: 'Permit',
            value: '${course.permitCount}',
            color: AppColor.SubjectBlue,
            icon: Icons.edit_document,
            iconColor: AppColor.InfoBorder,
          ),
          StatBox(
            label: 'Sick',
            value: '${course.sickCount}',
            color: AppColor.SubjectPeach,
            icon: Icons.edit_calendar_rounded,
            iconColor: AppColor.TextAverage,
          ),
          StatBox(
            label: 'Alpha',
            value: '${course.alphaCount}',
            color: AppColor.SubjectPink,
            icon: Icons.disabled_by_default_rounded,
            iconColor: AppColor.FailBorder,
          ),
        ],
      ),
      const SizedBox(height: 24),
      const DetailSectionTitle('History Attendance'),
      const SizedBox(height: 12),
      if (items.isEmpty)
        const EmptyState(
          icon: Icons.person_outline,
          message: 'There is no attendance available for this course yet.',
        )
      else
        ...items.map(
          (h) => StatusRow(
            label: h.title,
            status: _statusText(h.status),
            tone: _tone(h.status),
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
            return StreamBuilder<List<AttendanceLog>>(
              stream: _history,
              builder: (context, listSnap) {
                final loading =
                    courseSnap.connectionState == ConnectionState.waiting ||
                        listSnap.connectionState == ConnectionState.waiting;
                final items = listSnap.data ?? const <AttendanceLog>[];

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