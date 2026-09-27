import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final List<Map<String, dynamic>> subjects = const [
    {
      'name': 'Pemrograman Mobile',
      'code': 'IT301',
      'color': AppColor.Average,
    },
    {
      'name': 'Jaringan Komputer',
      'code': 'IT302',
      'color': AppColor.Secondary,
    },
    {
      'name': 'Kecerdasan Buatan',
      'code': 'IT301',
      'color': AppColor.Fail,
    },
    {
      'name': 'Basis Data',
      'code': 'IT301',
      'color': AppColor.Background,
    },
    {
      'name': 'Sistem Operasi',
      'code': 'IT301',
      'color': AppColor.Success,
    },
    {
      'name': 'Pemrograman Web',
      'code': 'IT306',
      'color': AppColor.Secondary,
    },
    {
      'name': 'Statistika',
      'code': 'IT301',
      'color': AppColor.Average,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'asset/image/Nexa_Logo.png',
                    width: 135,
                  ),

                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColor.Average,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: AppColor.Primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =========================
              // PROFILE
              // =========================
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColor.Average,
                      child: Icon(
                        Icons.person,
                        size: 65,
                        color: AppColor.Primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Nexa User',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 30,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.Secondary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '253100000000',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // AKADEMIK SUMMARY
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColor.Success,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAcademicInfo(
                      icon: Icons.menu_book_outlined,
                      value: '/24',
                      label1: 'Beban/Lulus',
                      label2: 'SKS Semester',
                    ),

                    _buildAcademicInfo(
                      icon: Icons.menu_book_outlined,
                      value: '/500',
                      label1: 'Beban/Lulus',
                      label2: 'SKS Kumulatif',
                    ),

                    _buildAcademicInfo(
                      icon: Icons.workspace_premium_outlined,
                      value: '/3.89',
                      label1: 'Beban/Lulus',
                      label2: 'IP Semester',
                    ),

                    _buildAcademicInfo(
                      icon: Icons.workspace_premium_outlined,
                      value: '/3.89',
                      label1: 'Beban/Lulus',
                      label2: 'IP Kumulatif',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // PERFORMANCE TITLE
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColor.Primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Performance By Subject',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subheading.copyWith(
                    color: AppColor.TextSecondary,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // =========================
              // SUBJECT LIST
              // =========================
              ...subjects.map(
                (subject) => _buildSubjectCard(
                  name: subject['name'],
                  code: subject['code'],
                  color: subject['color'],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // LOGOUT
              // =========================
              Center(
                child: SizedBox(
                  width: 250,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan fungsi logout di sini
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.Fail,
                      foregroundColor: AppColor.TextBody,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'LOGOUT',
                      style: AppTextStyles.button.copyWith(
                        color: AppColor.TextBody,
                        fontSize: 18,
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

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==========================================================
  // ACADEMIC INFO
  // ==========================================================

  Widget _buildAcademicInfo({
    required IconData icon,
    required String value,
    required String label1,
    required String label2,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppColor.TextBody,
              ),
              const SizedBox(width: 5),
              Text(
                value,
                style: AppTextStyles.subheading.copyWith(
                  fontSize: 17,
                  color: AppColor.TextBody,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            label1,
            style: AppTextStyles.report.copyWith(
              fontSize: 10,
              color: AppColor.TextBody,
            ),
          ),

          Text(
            label2,
            style: AppTextStyles.report.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColor.TextBody,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SUBJECT CARD
  // ==========================================================

  Widget _buildSubjectCard({
    required String name,
    required String code,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColor.Background,
        border: Border.all(
          color: AppColor.Border,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 102,
            height: 84,
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              border: Border.all(
                color: AppColor.Border,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),

          const SizedBox(width: 20),

          // Subject name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.subheading.copyWith(
                    color: AppColor.Primary,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  code,
                  style: AppTextStyles.body.copyWith(
                    color: AppColor.Primary,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),

          // Profile icon
          Icon(
            Icons.account_box_outlined,
            color: AppColor.Primary,
            size: 36,
          ),

          const SizedBox(width: 20),

          // Achievement icon
          Icon(
            Icons.workspace_premium_outlined,
            color: AppColor.Primary,
            size: 38,
          ),

          const SizedBox(width: 20),

          // Chat icon
          Icon(
            Icons.chat_outlined,
            color: AppColor.Primary,
            size: 36,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      height: 105,
      decoration: BoxDecoration(
        color: AppColor.Primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomItem(
            icon: Icons.home_outlined,
            label: 'HOME',
            active: true,
          ),

          _buildBottomItem(
            icon: Icons.pie_chart_outline,
            label: '',
          ),

          _buildBottomItem(
            icon: Icons.workspace_premium_outlined,
            label: '',
          ),

          _buildBottomItem(
            icon: Icons.chat_outlined,
            label: '',
          ),

          _buildBottomItem(
            icon: Icons.account_box_outlined,
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return SizedBox(
      width: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (active)
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: AppColor.Background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: AppColor.TextBody,
              ),
            )
          else
            Icon(
              icon,
              size: 40,
              color: AppColor.TextSecondary,
            ),

          if (label.isNotEmpty)
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: AppColor.TextSecondary,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}