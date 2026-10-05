import 'package:flutter/material.dart';
import '../../style/color_style.dart';
import '../../style/text_style.dart';

/// Shown instead of a list/detail body when there is no data yet, e.g.
/// "There is no grade available for this course yet."
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(icon, size: 56, color: AppColor.Border),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColor.TextBody.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
