import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';

/// Back arrow + course name, shared by the three detail pages.
class DetailTopBar extends StatelessWidget {
  const DetailTopBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColor.Primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subheading.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

/// Big blue card with a label and one large value (Grade 90 / Attendance 99%).
class BigNumberCard extends StatelessWidget {
  const BigNumberCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColor.Secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontSize: 14)),
          Text(value, style: AppTextStyles.heading.copyWith(fontSize: 40)),
        ],
      ),
    );
  }
}

/// Small colored box with a label and a number (Task / Attend / UTS / UAS).
class StatBox extends StatelessWidget {
  const StatBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
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

/// Colored list row: label on the left, status text on the right.
class StatusRow extends StatelessWidget {
  const StatusRow({
    super.key,
    required this.label,
    required this.status,
    required this.color,
  });

  final String label;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontSize: 13)),
          Text(
            status,
            style: AppTextStyles.body
                .copyWith(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
