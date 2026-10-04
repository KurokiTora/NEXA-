import 'package:flutter/material.dart';
import '../../style/color_style.dart';
import '../../style/text_style.dart';

/// Inline alert banner used above form fields, e.g. "Login Failed" on the
/// Login page or "Email Not Found" on the Forgot Password page.
class ErrorBanner extends StatelessWidget {
  final String title;
  final String message;

  const ErrorBanner({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.Fail.withOpacity(0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.TextFail.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColor.TextFail, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subheading.copyWith(color: AppColor.TextFail, fontSize: 12),
                ),
                Text(
                  message,
                  style: AppTextStyles.body.copyWith(color: AppColor.TextFail, fontSize: 10.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
