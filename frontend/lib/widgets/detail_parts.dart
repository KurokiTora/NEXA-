import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';

/// Back arrow on the left, course name centered.
/// Shared by the Grade, Attend and Feedback detail pages.
class DetailTopBar extends StatelessWidget {
  const DetailTopBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.body
                  .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back, color: AppColor.Primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Large light-blue card: label + one huge value (Grade 90 / Attendance 99%).
class BigNumberCard extends StatelessWidget {
  const BigNumberCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.Secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontSize: 20)),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.heading
                  .copyWith(fontSize: 64, height: 1.1, color: AppColor.Primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small tinted box: optional icon, big number, small label underneath.
/// Place inside a [StatBoxRow].
class StatBox extends StatelessWidget {
  const StatBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.icon,
    this.iconColor,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColor.Border.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 24, color: iconColor ?? AppColor.Primary),
            const SizedBox(height: 4),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.subheading
                  .copyWith(fontSize: 26, color: AppColor.Primary),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: AppTextStyles.body.copyWith(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

/// Lays out [StatBox]es evenly with a fixed gap. Safe down to 320dp
/// because every box shrinks its text instead of overflowing.
class StatBoxRow extends StatelessWidget {
  const StatBoxRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

/// Section heading ("Assignment Assessment", "History Attendance").
class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.subheading.copyWith(fontSize: 17),
    );
  }
}

/// Fill / outline / text colors for one status.
class StatusTone {
  const StatusTone({
    required this.fill,
    required this.border,
    required this.text,
  });

  final Color fill;
  final Color border;
  final Color text;

  static const success = StatusTone(
    fill: AppColor.Success,
    border: AppColor.SuccessBorder,
    text: AppColor.TextSucces,
  );
  static const average = StatusTone(
    fill: AppColor.Average,
    border: AppColor.AverageBorder,
    text: AppColor.TextAverage,
  );
  static const fail = StatusTone(
    fill: AppColor.Fail,
    border: AppColor.FailBorder,
    text: AppColor.TextFail,
  );
  static const info = StatusTone(
    fill: AppColor.Info,
    border: AppColor.InfoBorder,
    text: AppColor.TextInfo,
  );
}

/// List row: label on the left, colored status on the right, tinted fill
/// with a stronger outline.
class StatusRow extends StatelessWidget {
  const StatusRow({
    super.key,
    required this.label,
    required this.status,
    required this.tone,
  });

  final String label;
  final String status;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tone.fill.withValues(alpha: 0.4),
        border: Border.all(color: tone.border, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: tone.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulsing placeholder block used while the first DB event is pending.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 12,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 1.0)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColor.Border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Loading layout that mirrors the real detail body.
class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonBox(width: double.infinity, height: 170, radius: 24),
        const SizedBox(height: 16),
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              const Expanded(child: SkeletonBox(height: 84)),
            ],
          ],
        ),
        const SizedBox(height: 24),
        const SkeletonBox(width: 180, height: 18, radius: 6),
        const SizedBox(height: 14),
        for (var i = 0; i < 5; i++) ...[
          const SkeletonBox(width: double.infinity, height: 46, radius: 10),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
