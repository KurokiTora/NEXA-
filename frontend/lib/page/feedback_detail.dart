import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/detail_parts.dart';
import '../widgets/states/empty_state.dart';

class FeedbackDetailPage extends StatefulWidget {
  const FeedbackDetailPage({super.key, required this.courseId});

  final int courseId;

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  late final Stream<Course?> _course;
  late final Stream<List<FeedbackNote>> _notes;

  @override
  void initState() {
    super.initState();
    final repo = context.read<NexaRepository>();
    _course = repo.watchCourse(widget.courseId);
    _notes = repo.watchFeedback(widget.courseId);
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
            return StreamBuilder<List<FeedbackNote>>(
              stream: _notes,
              builder: (context, listSnap) {
                final notes = listSnap.data ?? const <FeedbackNote>[];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      Text(
                        'Assignment Assessment',
                        style: AppTextStyles.subheading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      if (notes.isEmpty)
                        const EmptyState(
                          icon: Icons.chat_bubble_outline,
                          message: 'There is no feedback available for this course yet.',
                        )
                      else
                        ...notes.map(
                          (n) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.Secondary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.rate_review_outlined,
                                        color: AppColor.Fail, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        style: AppTextStyles.subheading
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  n.body,
                                  style: AppTextStyles.body
                                      .copyWith(fontSize: 12.5, height: 1.5),
                                ),
                              ],
                            ),
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
