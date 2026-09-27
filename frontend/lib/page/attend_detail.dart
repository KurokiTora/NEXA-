import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_data.dart';

class AttendDetailPage extends StatelessWidget {
  final Subject subject;
  const AttendDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final history = [
      {'label': 'Class Meeting 1', 'status': 'Attend', 'color': AppColor.Success},
      {'label': 'Class Meeting 2', 'status': 'Attend', 'color': AppColor.Success},
      {'label': 'Class Meeting 3', 'status': 'Permit', 'color': AppColor.Average},
      {'label': 'Class Meeting 4', 'status': 'Alpha', 'color': AppColor.Fail},
      {'label': 'Class Meeting 5', 'status': 'Attend', 'color': AppColor.Success},
      {'label': 'Class Meeting 6', 'status': 'Attend', 'color': AppColor.Success},
    ];

    return Scaffold(
      backgroundColor: AppColor.Background,
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
                    child: const Icon(Icons.arrow_back, color: AppColor.Primary),
                  ),
                  const SizedBox(width: 16),
                  Text(subject.name, style: AppTextStyles.subheading.copyWith(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(color: AppColor.Secondary, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text('Attendance', style: AppTextStyles.body.copyWith(fontSize: 14)),
                    Text('99%', style: AppTextStyles.heading.copyWith(fontSize: 40)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statBox('Attend', '40', AppColor.SubjectGreen),
                  _statBox('Permit', '1', AppColor.Average),
                  _statBox('Sick', '0', AppColor.SubjectPurple),
                  _statBox('Alpha', '1', AppColor.Fail),
                ],
              ),
              const SizedBox(height: 20),
              Text('History Attendance', style: AppTextStyles.subheading.copyWith(fontSize: 16)),
              const SizedBox(height: 8),
              ...history.map((h) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: (h['color'] as Color).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(h['label'] as String, style: AppTextStyles.body.copyWith(fontSize: 13)),
                        Text(h['status'] as String, style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )),
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
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
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
