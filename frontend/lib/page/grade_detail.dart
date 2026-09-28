import 'package:flutter/material.dart';

import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_data.dart';

class GradeDetailPage extends StatelessWidget {
  final Subject subject;
  const GradeDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final assessments = [
      {
        'label': 'Meeting 1 Assignment',
        'status': 'On-Time, 80',
        'color': AppColor.success,
      },
      {
        'label': 'Meeting 2 Assignment',
        'status': 'On-Time, 90',
        'color': AppColor.success,
      },
      {
        'label': 'Meeting 3 Assignment',
        'status': 'Late, 40',
        'color': AppColor.average,
      },
      {
        'label': 'Meeting 4 Assignment',
        'status': "Didn't Submit",
        'color': AppColor.fail,
      },
      {
        'label': 'Meeting 5 Assignment',
        'status': 'On-Time, 60',
        'color': AppColor.success,
      },
      {
        'label': 'Meeting 6 Assignment',
        'status': 'On-Time, 55',
        'color': AppColor.success,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColor.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Grade',
                      style: AppTextStyles.body.copyWith(fontSize: 14),
                    ),
                    Text(
                      '${subject.grade}',
                      style: AppTextStyles.heading.copyWith(fontSize: 40),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statBox('Task', '80', AppColor.subjectGreen),
                  _statBox('Attend', '99', AppColor.subjectBlue),
                  _statBox('UTS', '100', AppColor.subjectPurple),
                  _statBox('UAS', '99', AppColor.subjectYellow),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Assignment Assessment',
                style: AppTextStyles.subheading.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...assessments.map(
                (a) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: (a['color'] as Color).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        a['label'] as String,
                        style: AppTextStyles.body.copyWith(fontSize: 13),
                      ),
                      Text(
                        a['status'] as String,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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

  Widget _statBox(String label, String value, Color color) {
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
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 11)),
            Text(value, style: AppTextStyles.subheading.copyWith(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
