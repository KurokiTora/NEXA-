import 'package:flutter/material.dart';

import '../style/color_style.dart';
import '../style/text_style.dart';
import 'subject_data.dart';

/// Compact subject list row shared by Dashboard & Analytic pages.
/// Fixed-width elements (swatch + 3 icons) are kept small on purpose so the
/// Expanded name/code column always keeps enough room on narrow screens.
class SubjectActionRow extends StatelessWidget {
  final Subject subject;
  final VoidCallback? onAttend;
  final VoidCallback? onGrade;
  final VoidCallback? onFeedback;

  const SubjectActionRow({
    super.key,
    required this.subject,
    this.onAttend,
    this.onGrade,
    this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.border, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              subject.image,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 30,
                  height: 30,
                  color: subject.color,
                );
              },
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subheading.copyWith(
                    color: AppColor.primary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subject.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColor.primary,
                    fontSize: 11,
                  ),
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
        child: Icon(
          icon,
          color: AppColor.primary,
          size: 22,
        ),
      ),
    );
  }
}


/// Mapping icon mata kuliah
String getSubjectImage(String name) {
  switch (name) {
    case "Pemrograman Mobile":
      return "asset/image/subject/mobile.png";

    case "Jaringan Komputer":
      return "asset/image/subject/jaringan.png";

    case "Kecerdasan Buatan":
      return "asset/image/subject/ai.png";

    case "Basis Data":
      return "asset/image/subject/database.png";

    case "Sistem Operasi":
      return "asset/image/subject/sistem.png";

    case "Pemrograman Web":
      return "asset/image/subject/web.png";

    case "Statistika":
      return "asset/image/subject/statistik.png";

    default:
      return "asset/image/subject/default.png";
  }
}