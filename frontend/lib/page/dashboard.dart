import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/errors.dart';
import '../data/models/course.dart';
import '../data/models/student.dart';
import '../state/auth_state.dart';
import '../state/sync_state.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_row.dart';
import '../widgets/states/empty_state.dart';
import '../widgets/states/refresh_helper.dart';
import '../widgets/states/status_popup.dart';
import 'attend_detail.dart';
import 'bottom_navidation.dart';
import 'feedback_detail.dart';
import 'grade_detail.dart';
import 'login.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncIfStale());
  }

  /// Offline-first: the screen already shows whatever is cached. We only go
  /// to the network when the cache is empty or older than the TTL.
  Future<void> _syncIfStale() async {
    final error = await context.read<SyncState>().refreshIfStale();
    if (error == null || !mounted) return;

    // Failing while offline with cached data on screen is normal -> stay
    // quiet. Only speak up if the session expired or there is nothing to show.
    final hasCache = context.read<List<Course>>().isNotEmpty;
    if (error is UnauthorizedFailure || !hasCache) {
      handleSyncFailure(context, error);
    }
  }

  Future<void> _logout() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = context.watch<Student?>();
    final courses = context.watch<List<Course>>();
    final isSyncing = context.select<SyncState, bool>((s) => s.isRefreshing);

    String sks(int? v) => v == null ? '/-' : '/$v';
    String ip(double? v) => v == null ? '/-' : '/${v.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => refreshWithFeedback(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('asset/image/Nexa_Logo.png', width: 120),
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColor.Average,
                      child: Icon(Icons.person, size: 28, color: AppColor.Primary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // BRIEF PROFILE (avatar, name, NIM, SKS + IP summary)
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColor.Average,
                        child: Icon(Icons.person, size: 60, color: AppColor.Primary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        student?.name ?? '-',
                        style: AppTextStyles.heading.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColor.Secondary,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          student?.nim ?? '-',
                          style: AppTextStyles.body.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // AKADEMIK SUMMARY — 4 rounded cards in a 2x2 grid
                Row(
                  children: [
                    Expanded(child: _buildAcademicCard(icon: Icons.menu_book_outlined, value: sks(student?.sksSemester), label1: 'Beban/Lulus', label2: 'SKS Semester')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildAcademicCard(icon: Icons.menu_book_outlined, value: sks(student?.sksTotal), label1: 'Beban/Lulus', label2: 'SKS Kumulatif')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildAcademicCard(icon: Icons.workspace_premium_outlined, value: ip(student?.ipSemester), label1: 'Beban/Lulus', label2: 'IP Semester')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildAcademicCard(icon: Icons.workspace_premium_outlined, value: ip(student?.ipCumulative), label1: 'Beban/Lulus', label2: 'IP Kumulatif')),
                  ],
                ),
                const SizedBox(height: 16),

                // PERFORMANCE TITLE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColor.Primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Performance By Subject',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subheading
                        .copyWith(color: AppColor.TextSecondary, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 6),

                // COURSE LIST (from the local database)
                if (courses.isEmpty)
                  isSyncing
                      ? const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const EmptyState(
                          icon: Icons.menu_book_outlined,
                          message: 'No courses yet.\nPull down to refresh.',
                        )
                else
                  ...courses.map(
                    (c) => SubjectActionRow(
                      course: c,
                      onAttend: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendDetailPage(courseId: c.id))),
                      onGrade: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GradeDetailPage(courseId: c.id))),
                      onFeedback: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackDetailPage(courseId: c.id))),
                    ),
                  ),

                const SizedBox(height: 20),

                // LOGOUT
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => showLogoutConfirmDialog(
                        context,
                        onLogout: _logout,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.Fail,
                        foregroundColor: AppColor.TextBody,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'LOGOUT',
                        style: AppTextStyles.button.copyWith(
                          color: AppColor.TextBody,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildAcademicCard({
    required IconData icon,
    required String value,
    required String label1,
    required String label2,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.Success.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: AppColor.TextBody),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subheading
                      .copyWith(fontSize: 16, color: AppColor.TextBody),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label1,
            textAlign: TextAlign.center,
            style: AppTextStyles.report.copyWith(
              fontSize: 11,
              color: AppColor.TextBody.withValues(alpha: 0.6),
            ),
          ),
          Text(
            label2,
            textAlign: TextAlign.center,
            style: AppTextStyles.report.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.TextBody,
            ),
          ),
        ],
      ),
    );
  }
}
