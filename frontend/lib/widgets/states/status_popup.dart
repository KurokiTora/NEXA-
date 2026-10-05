import 'package:flutter/material.dart';
import '../../style/color_style.dart';
import '../../style/text_style.dart';

/// Rounded popup card used for system-level states: server busy, a request
/// that needs a refresh, or a confirmation like "Are You Sure To Logout?".
/// Matches the small white card with a red "!" icon from the design.
class StatusPopup extends StatelessWidget {
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const StatusPopup({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.Background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: AppColor.TextFail, shape: BoxShape.circle),
              child: const Icon(Icons.priority_high_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.subheading.copyWith(color: AppColor.TextFail, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(fontSize: 11, color: AppColor.TextBody.withOpacity(0.7)),
            ),
            const SizedBox(height: 14),
            if (secondaryLabel == null)
              SizedBox(
                width: double.infinity,
                height: 34,
                child: ElevatedButton(
                  onPressed: onPrimary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.Primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(primaryLabel, style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: 12)),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: onPrimary,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.TextFail,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(primaryLabel, style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: OutlinedButton(
                        onPressed: onSecondary,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColor.Border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(secondaryLabel!, style: AppTextStyles.button.copyWith(color: AppColor.TextBody, fontSize: 12)),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows "Please wait a little longer" — server busy / experiencing issues.
void showServerBusyDialog(BuildContext context, {VoidCallback? onRefresh}) {
  showDialog(
    context: context,
    builder: (ctx) => StatusPopup(
      title: 'Please wait a little longer',
      message: 'Server is busy / experiencing issues.',
      primaryLabel: 'Refresh',
      onPrimary: () {
        Navigator.pop(ctx);
        onRefresh?.call();
      },
    ),
  );
}

/// Shows "Please refresh the page" — generic request/page error.
void showRefreshPageDialog(BuildContext context, {VoidCallback? onRefresh}) {
  showDialog(
    context: context,
    builder: (ctx) => StatusPopup(
      title: 'Please refresh the page',
      message: 'There is a problem / error.',
      primaryLabel: 'Refresh',
      onPrimary: () {
        Navigator.pop(ctx);
        onRefresh?.call();
      },
    ),
  );
}

/// Shows "Are You Sure To Logout?" confirmation.
void showLogoutConfirmDialog(BuildContext context, {required VoidCallback onLogout}) {
  showDialog(
    context: context,
    builder: (ctx) => StatusPopup(
      title: 'Are You Sure To Logout?',
      message: '',
      primaryLabel: 'Logout',
      onPrimary: () {
        Navigator.pop(ctx);
        onLogout();
      },
      secondaryLabel: 'Cancel',
      onSecondary: () => Navigator.pop(ctx),
    ),
  );
}
