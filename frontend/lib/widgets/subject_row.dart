import 'package:flutter/material.dart';
import '../data/models/course.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'course_avatar.dart';

/// Compact course row with 3 quick actions (attend / grade / feedback),
/// used on the Dashboard. Fixed-width parts are kept small on purpose so the
/// Expanded name/code column always keeps room on narrow screens.
class SubjectActionRow extends StatelessWidget {
  const SubjectActionRow({
    super.key,
    required this.course,
    this.onAttend,
    this.onGrade,
    this.onFeedback,
  });

  final Course course;
  final VoidCallback? onAttend;
  final VoidCallback? onGrade;
  final VoidCallback? onFeedback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.Border, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CourseAvatar(
            courseName: course.name,
            colorIndex: course.colorIndex,
            size: 30,
            radius: 8,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subheading
                      .copyWith(color: AppColor.Primary, fontSize: 14),
                ),
                Text(
                  course.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body
                      .copyWith(color: AppColor.Primary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _actionIcon(Icons.account_box_outlined, onAttend),
          _actionIcon(Icons.workspace_premium_outlined, onGrade),
          _actionIcon(Icons.chat_outlined, onFeedback),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Icon(icon, color: AppColor.Primary, size: 22),
      ),
    );
  }
}
