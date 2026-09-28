import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_data.dart';
import '../widgets/subject_row.dart';
import 'bottom_navidation.dart';
import 'grade_detail.dart';
import 'attend_detail.dart';
import 'feedback_detail.dart';

class AnalyticPage extends StatelessWidget {
  const AnalyticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: AppColor.Secondary, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text('Your Performance Is', style: AppTextStyles.body.copyWith(fontSize: 14, color: AppColor.Primary)),
                    Text('EXCELLENT', style: AppTextStyles.heading.copyWith(fontSize: 26)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _metricBox('Percentage Attend', '99', AppColor.Success)),
                  const SizedBox(width: 12),
                  Expanded(child: _metricBox('Average Grade', '98', AppColor.SubjectPurple)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: AppColor.Primary, borderRadius: BorderRadius.circular(25)),
                child: Text(
                  'Performance By Subject',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subheading.copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              ...subjects.map(
                (s) => SubjectActionRow(
                  subject: s,
                  onAttend: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendDetailPage(subject: s))),
                  onGrade: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GradeDetailPage(subject: s))),
                  onFeedback: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackDetailPage(subject: s))),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _metricBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.heading.copyWith(fontSize: 26)),
        ],
      ),
    );
  }
}
