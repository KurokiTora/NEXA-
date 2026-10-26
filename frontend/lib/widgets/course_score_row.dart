import 'package:flutter/material.dart';
import '../data/models/course.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'course_palette.dart';

/// Row used by the Grade, Attend and Feedback lists: swatch, name/code,
/// score, letter badge and a chevron.
class CourseScoreRow extends StatelessWidget {
  const CourseScoreRow({super.key, required this.course, required this.onTap});

  final Course course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isA = course.letter.toUpperCase().startsWith('A');

    return GestureDetector(
      onTap: onTap,
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
              decoration: BoxDecoration(
                color: courseColor(course.colorIndex),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subheading
                        .copyWith(color: AppColor.Primary, fontSize: 15),
                  ),
                  Text(
                    course.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body
                        .copyWith(color: AppColor.Primary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text('${course.grade}',
                style: AppTextStyles.subheading.copyWith(fontSize: 16)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isA ? AppColor.Success : AppColor.SubjectPeach,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course.letter,
                style: AppTextStyles.subheading.copyWith(
                  fontSize: 13,
                  color: isA ? AppColor.TextBody : const Color(0xFF8B4A2B),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: AppColor.Primary),
          ],
        ),
      ),
    );
  }
}
