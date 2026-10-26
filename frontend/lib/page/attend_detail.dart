import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
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

  Color _statusColor(AttendanceStatus s) => switch (s) {
        AttendanceStatus.attend => AppColor.Success,
        AttendanceStatus.permit => AppColor.Average,
        AttendanceStatus.sick => AppColor.SubjectPurple,
        AttendanceStatus.alpha => AppColor.Fail,
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
            return StreamBuilder<List<AttendanceLog>>(
              stream: _history,
              builder: (context, listSnap) {
                final items = listSnap.data ?? const <AttendanceLog>[];
                final empty = course == null || items.isEmpty;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      BigNumberCard(
                        label: 'Attendance',
                        value: empty ? '0%' : '${course.attendPercent}%',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          StatBox(label: 'Attend', value: empty ? '0' : '${course.attendCount}', color: AppColor.SubjectGreen),
                          StatBox(label: 'Permit', value: empty ? '0' : '${course.permitCount}', color: AppColor.Average),
                          StatBox(label: 'Sick', value: empty ? '0' : '${course.sickCount}', color: AppColor.SubjectPurple),
                          StatBox(label: 'Alpha', value: empty ? '0' : '${course.alphaCount}', color: AppColor.Fail),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'History Attendance',
                        style: AppTextStyles.subheading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
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
                            color: _statusColor(h.status),
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