import 'package:flutter/material.dart';

import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_data.dart';

class FeedbackDetailPage extends StatelessWidget {
  final Subject subject;
  const FeedbackDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final notes = [
      {
        'title': 'Feedback Mid-Term Task',
        'body':
            'Overall your mid-term work shows a solid understanding of the core concepts. '
            'Keep an eye on submission timing and double-check edge cases before turning work in.',
      },
      {
        'title': 'Feedback Final-Term Task',
        'body':
            'Great improvement compared to the mid-term. Your final submission was well structured '
            'and on time. Keep up this consistency for the next semester.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    subject.name,
                    style: AppTextStyles.subheading.copyWith(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Assignment Assessment',
                style: AppTextStyles.subheading.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ...notes.map(
                (n) => Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.secondary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.rate_review_outlined,
                            color: AppColor.fail,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            n['title']!,
                            style: AppTextStyles.subheading.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        n['body']!,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
