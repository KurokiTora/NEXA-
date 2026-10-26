import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/errors.dart';
import '../../page/login.dart';
import '../../state/auth_state.dart';
import '../../state/sync_state.dart';
import 'status_popup.dart';

/// Pull-to-refresh handler shared by every list screen.
/// Shows the "server busy" / "refresh the page" popups from the design when
/// the sync fails; cached data stays on screen either way.
Future<void> refreshWithFeedback(BuildContext context) async {
  final error = await context.read<SyncState>().refresh();
  if (error == null || !context.mounted) return;
  await handleSyncFailure(context, error);
}

Future<void> handleSyncFailure(BuildContext context, NexaException error) async {
  if (error is UnauthorizedFailure) {
    // Session is gone for good -> back to login.
    await context.read<AuthState>().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
    return;
  }

  if (error is NetworkFailure) {
    showServerBusyDialog(context, onRefresh: () => refreshWithFeedback(context));
  } else {
    showRefreshPageDialog(context, onRefresh: () => refreshWithFeedback(context));
  }
}
