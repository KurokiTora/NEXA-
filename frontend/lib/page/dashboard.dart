import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/subject_data.dart';
import '../widgets/subject_row.dart';
import 'bottom_navidation.dart';
import 'grade_detail.dart';
import 'attend_detail.dart';
import 'feedback_detail.dart';
import 'login.dart';
import '../widgets/states/status_popup.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('asset/image/Nexa_Logo.png', width: 120),
                  CircleAvatar(
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
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColor.Average,
                      child: Icon(Icons.person, size: 60, color: AppColor.Primary),
                    ),
                    const SizedBox(height: 10),
                    Text('Nexa User', style: AppTextStyles.heading.copyWith(fontSize: 26)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColor.Secondary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text('253100000000', style: AppTextStyles.body.copyWith(fontSize: 14)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // AKADEMIK SUMMARY (still part of Brief Profile) — 4 separate
              // rounded cards in a 2x2 grid, each sized to be easy to read.
              Row(
                children: [
                  Expanded(child: _buildAcademicCard(icon: Icons.menu_book_outlined, value: '/24', label1: 'Beban/Lulus', label2: 'SKS Semester')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildAcademicCard(icon: Icons.menu_book_outlined, value: '/500', label1: 'Beban/Lulus', label2: 'SKS Kumulatif')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildAcademicCard(icon: Icons.workspace_premium_outlined, value: '/3.89', label1: 'Beban/Lulus', label2: 'IP Semester')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildAcademicCard(icon: Icons.workspace_premium_outlined, value: '/3.90', label1: 'Beban/Lulus', label2: 'IP Kumulatif')),
                ],
              ),
              const SizedBox(height: 16),

              // PERFORMANCE TITLE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: AppColor.Primary, borderRadius: BorderRadius.circular(25)),
                child: Text(
                  'Performance By Subject',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subheading.copyWith(color: AppColor.TextSecondary, fontSize: 16),
                ),
              ),
              const SizedBox(height: 6),

              // SUBJECT LIST — same compact style as Analytic page
              ...subjects.map(
                (s) => SubjectActionRow(
                  subject: s,
                  onAttend: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendDetailPage(subject: s))),
                  onGrade: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GradeDetailPage(subject: s))),
                  onFeedback: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackDetailPage(subject: s))),
                ),
              ),

              const SizedBox(height: 20),

              // LOGOUT
              Center(
                child: SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showLogoutConfirmDialog(
                        context,
                        onLogout: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.Fail,
                      foregroundColor: AppColor.TextBody,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'LOGOUT',
                      style: AppTextStyles.button.copyWith(color: AppColor.TextBody, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
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
        color: AppColor.Success.withOpacity(0.35),
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
                  style: AppTextStyles.subheading.copyWith(fontSize: 16, color: AppColor.TextBody),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label1,
            textAlign: TextAlign.center,
            style: AppTextStyles.report.copyWith(fontSize: 11, color: AppColor.TextBody.withOpacity(0.6)),
          ),
          Text(
            label2,
            textAlign: TextAlign.center,
            style: AppTextStyles.report.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.TextBody),
          ),
        ],
      ),
    );
  }
}
