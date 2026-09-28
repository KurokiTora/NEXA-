import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_data.dart';
import 'bottom_navidation.dart';
import 'grade_detail.dart';

class GradePage extends StatelessWidget {
  const GradePage({super.key});

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
              Text('My Grades', style: AppTextStyles.heading.copyWith(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                'Track your learning progress and achievement',
                style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColor.Primary),
              ),
              const SizedBox(height: 16),

              // Average card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColor.Secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColor.Primary,
                      child: const Icon(Icons.school, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Currently on average', style: AppTextStyles.body.copyWith(fontSize: 12)),
                          Text('98', style: AppTextStyles.heading.copyWith(fontSize: 32)),
                          Text(
                            'Great Progress! Keep it up!',
                            style: AppTextStyles.body.copyWith(fontSize: 11, color: AppColor.Primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColor.Primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.menu_book_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'By Subject',
                      style: AppTextStyles.subheading.copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              ...subjects.map((s) => _gradeRow(context, s)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _gradeRow(BuildContext context, Subject s) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GradeDetailPage(subject: s)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.Border, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.subheading.copyWith(color: AppColor.Primary, fontSize: 15)),
                  Text(s.code, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.body.copyWith(color: AppColor.Primary, fontSize: 12)),
                ],
              ),
            ),
            Text('${s.grade}', style: AppTextStyles.subheading.copyWith(fontSize: 16)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColor.Success, borderRadius: BorderRadius.circular(8)),
              child: Text(s.letter, style: AppTextStyles.subheading.copyWith(fontSize: 13)),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: AppColor.Primary),
          ],
        ),
      ),
    );
  }
}
