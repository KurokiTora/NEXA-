# NEXA Mobile — Context Bundle: Redesign Halaman Grade & Attend

> **Cara pakai:** paste seluruh isi file ini ke Claude, lalu isi bagian **§7 Arah Desain**
> sebelum mengirim. Semua source code yang dibutuhkan sudah ada di **§8**.

---

## §1. Prompt untuk Claude

```
Kamu seorang Flutter engineer + UI designer. Tugasmu: REDESIGN TOTAL tampilan
2 halaman detail aplikasi mobile NEXA (Grade & Attend), tanpa mengubah data layer.

Baca seluruh dokumen ini. Source code lengkap ada di §8, data yang tersedia di §4,
token desain di §5, masalah yang ada sekarang di §6, dan arah desain saya di §7.

ATURAN KERAS (jangan dilanggar):
1. UI only. Jangan ubah cara ambil data: tetap StreamBuilder + NexaRepository
   (watchCourse, watchAssessments, watchAttendance).
2. Pertahankan nama class + constructor:
   - GradeDetailPage({super.key, required int courseId})
   - AttendDetailPage({super.key, required int courseId})
   Karena navigasi memanggil: GradeDetailPage(courseId: course.id) dan
   AttendDetailPage(courseId: course.id).
3. Jangan tambah package baru. Font = Poppins via google_fonts.
   Flutter 3.47 / Dart 3.13, Material 3 (useMaterial3: true).
4. Warna: pakai AppColor.* yang ada. Kalau butuh warna baru, tambahkan sebagai
   konstanta di lib/style/color_style.dart (jangan hardcode hex di widget).
   Tipografi: pakai/ganti AppTextStyles di lib/style/text_style.dart.
5. lib/widgets/detail_parts.dart dipakai bareng lib/page/feedback_detail.dart
   (halaman Feedback memakai DetailTopBar). Kalau mengubah DetailTopBar,
   pastikan Feedback tetap kompatibel. Kalau mengubah StatusRow/StatBox/
   BigNumberCard, cek semua pemakainya.
6. Responsif: wajib aman di lebar 360dp, TIDAK BOLEH overflow (RenderFlex
   overflow). 4 kotak statistik sejajar saat ini rawan overflow -> perbaiki.
7. Perbaiki bug state: saat ini `empty = course == null || items.isEmpty`
   sehingga kalau daftar kosong tapi course ada, nilai tampil "00"/"0".
   Pisahkan: (a) course belum termuat, (b) list kosong, (c) data normal.
8. Sertakan 3 state: loading, empty, data normal. Loading jangan cuma spinner
   kosong kalau bisa pakai skeleton.
9. Jangan hapus fitur yang sudah ada: status warna (onTime/late/missing,
   attend/permit/sick/alpha), tombol back, nama mata kuliah.
10. Jangan mengubah file di luar 2 halaman + komponen style/widget yang
    memang dipakai keduanya.

OUTPUT YANG SAYA MAU:
- Isi file LENGKAP hasil rewrite (bukan potongan diff), dengan path jelas.
- Daftar komponen/widget baru yang dibuat beserta tujuannya.
- Catatan file lain yang ikut berubah (mis. detail_parts.dart) dan dampaknya.
- Tidak perlu penjelasan teori panjang; langsung kode.
```

---

## §2. Ringkasan proyek

- Aplikasi: **NEXA** — aplikasi mobile mahasiswa (Flutter).
- Package name: `mobile`
- Flutter 3.47.1 / Dart 3.13.1, Material 3.
- Arsitektur offline-first: **UI ← Stream ← Drift (SQLite) ← API**
- Halaman detail **tidak** memanggil API langsung. Semua data reaktif dari repository.
- Desain saat ini: light theme, dominan biru navy `#00245D`, kartu pastel,
  font Poppins.

---

## §3. Arsitektur & alur navigasi

```
GradePage / AttendPage (list)
  └─ onCourseTap -> Navigator.push(MaterialPageRoute(
        GradeDetailPage(courseId: course.id) / AttendDetailPage(courseId: course.id)))

Detail page
  ├─ repo.watchCourse(id)               -> Stream<Course?>
  ├─ repo.watchAssessments(id)          -> Stream<List<Assessment>>      (Grade)
  └─ repo.watchAttendance(id)           -> Stream<List<AttendanceLog>>   (Attend)

Drift DB (SQLite) -> Stream -> UI rebuild otomatis saat sync menulis data.
```

Konsekuensi desain: **tidak ada pull-to-refresh manual** di halaman detail.
Jangan menambahkan tombol refresh yang memanggil API langsung.

---

## §4. Data yang tersedia (jangan mengarang field baru)

### Halaman Grade
| Field | Tipe | Contoh |
|---|---|---|
| `course.name` | String | Pemrograman Mobile |
| `course.code` | String | IT301 |
| `course.grade` | int | 88 |
| `course.letter` | String | A / B+ |
| `course.taskScore` | int | 80 |
| `course.attendScore` | int | 99 |
| `course.utsScore` | int | 100 |
| `course.uasScore` | int | 99 |
| `assessments[].title` | String | Meeting 1 Assignment |
| `assessments[].status` | enum | `onTime` / `late` / `missing` |
| `assessments[].score` | int? | 80 / null (tidak submit) |

### Halaman Attend
| Field | Tipe | Contoh |
|---|---|---|
| `course.name` | String | Pemrograman Mobile |
| `course.code` | String | IT301 |
| `course.attendPercent` | int (%) | 99 |
| `course.attendCount` | int | 16 |
| `course.permitCount` | int | 2 |
| `course.sickCount` | int | 1 |
| `course.alphaCount` | int | 0 |
| `attendance[].title` | String | Class Meeting 1 |
| `attendance[].status` | enum | `attend` / `permit` / `sick` / `alpha` |

Catatan: jumlah item per halaman hanya 6 baris (Meeting 1–6). Desain tidak perlu
mengasumsikan list sangat panjang, tapi tetap harus scrollable.

---

## §5. Token desain yang ada

### Warna (`lib/style/color_style.dart`)
| Token | Hex | Fungsi |
|---|---|---|
| `AppColor.Primary` | `#00245D` | navy utama, teks judul, ikon |
| `AppColor.Secondary` | `#CAE5FD` | biru muda kartu besar |
| `AppColor.Background` | `#FFFFFF` | background halaman |
| `AppColor.TextBody` | `#000000` | teks isi |
| `AppColor.TextSucces` | `#2B8B3C` | teks sukses |
| `AppColor.TextFail` | `#FF0207` | teks gagal |
| `AppColor.TextAverage` | `#FF7C09` | teks warning |
| `AppColor.Success` | `#ABF3BB` | background status baik (onTime/attend) |
| `AppColor.Average` | `#FDF3B8` | background status warning (late/permit) |
| `AppColor.Fail` | `#FF9E9E` | background status buruk (missing/alpha) |
| `AppColor.Border` | `#D1D6DB` | border kartu |
| `AppColor.SubjectPurple` | `#E4D6FF` | pastel mapel |
| `AppColor.SubjectBlue` | `#DDEAFF` | pastel mapel |
| `AppColor.SubjectPink` | `#FCE8EF` | pastel mapel |
| `AppColor.SubjectPeach` | `#FFF0EA` | pastel mapel |
| `AppColor.SubjectGreen` | `#DDF8EA` | pastel mapel |
| `AppColor.SubjectYellow` | `#FFF4D9` | pastel mapel |

### Tipografi (`lib/style/text_style.dart`)
Semua Poppins: `heading` 24 bold, `subheading` 18 w600, `body` 16 normal,
`report` 16 w400, `button` 16 w600.

### Aset yang tersedia
- `asset/image/Nexa_Logo.png`, `asset/image/Nexa_Mark.png`
- `asset/image/subject/{Pemmob,JK,AI,BasDat,OS,Pemweb,Statistika}.png`
- `asset/image/bg_login.png`

---

## §6. Tampilan saat ini & masalahnya

Layout sekarang di kedua halaman (identik, hanya beda data):

1. `DetailTopBar` — panah back + nama mata kuliah (tanpa AppBar).
2. `BigNumberCard` — kartu biru muda besar: label + angka raksasa
   (`Grade` / `00`, `Attendance` / `0%`).
3. `Row` berisi 4 `StatBox` — kotak pastel berisi label + angka.
   **Rawan overflow di 360dp** karena tiap box `Expanded` dengan teks 11–18.
4. Judul section ("Assignment Assessment" / "History Attendance").
5. Deretan `StatusRow` — bar warna pastel (alpha 0.5), label kiri, status kanan.
6. `EmptyState` kalau data kosong.

Masalah yang diketahui:
- `empty` menggabungkan "course belum ada" + "list kosong" -> nilai tampil `00`/`0`.
- Visual datar: belum ada hierarki, belum ada grafik, kartu besar terlalu polos.
- `StatusRow` hanya teks kiri-kanan; status tidak terlihat seperti badge/chip.
- `StatBox` tidak punya ikon; 4 kotak terasa sempit.
- Belum ada indikator loading (StreamBuilder mengirim null -> tampil kosong).

---

## §7. Arah Desain  ← ISI SEBELUM KIRIM KE CLAUDE

> Ganti bagian dalam kurung siku dengan keinginanmu.

- **Mood/gaya:** [contoh: modern-clean, banyak white space, kartu rounded 20,
  soft shadow, aksen biru navy; BUKAN neumorphism]
- **Header:** [contoh: gradient navy -> biru, nama MK + kode MK + thumbnail
  subject di kiri, tombol back melayang]
- **Grade:** [contoh: circular progress besar untuk nilai akhir + letter badge,
  lalu 4 komponen nilai sebagai bar horizontal, bukan kotak]
- **Attend:** [contoh: donut chart persentase kehadiran + legend
  Attend/Permit/Sick/Alpha, lalu timeline history vertikal]
- **List status:** [contoh: chip/badge berwarna + ikon, baris putih dengan border,
  bukan bar pastel penuh]
- **Dark mode:** [tidak / ya]
- **Referensi visual:** [tempel screenshot mockup/Dribbble/Mobbin di sini]
- **Yang TIDAK saya mau:** [contoh: jangan pakai gradient ungu, jangan animasi
  berlebihan, jangan ubah font]

---

## §8. Source code

---

### `frontend/lib/page/grade_detail.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/detail_parts.dart';
import '../widgets/states/empty_state.dart';

class GradeDetailPage extends StatefulWidget {
  const GradeDetailPage({super.key, required this.courseId});

  final int courseId;

  @override
  State<GradeDetailPage> createState() => _GradeDetailPageState();
}

class _GradeDetailPageState extends State<GradeDetailPage> {
  // Streams are created once; creating them inside build() would resubscribe
  // to the database on every rebuild.
  late final Stream<Course?> _course;
  late final Stream<List<Assessment>> _assessments;

  @override
  void initState() {
    super.initState();
    final repo = context.read<NexaRepository>();
    _course = repo.watchCourse(widget.courseId);
    _assessments = repo.watchAssessments(widget.courseId);
  }

  String _statusText(Assessment a) => switch (a.status) {
        AssessmentStatus.onTime => 'On-Time, ${a.score ?? 0}',
        AssessmentStatus.late => 'Late, ${a.score ?? 0}',
        AssessmentStatus.missing => "Didn't Submit",
      };

  Color _statusColor(Assessment a) => switch (a.status) {
        AssessmentStatus.onTime => AppColor.Success,
        AssessmentStatus.late => AppColor.Average,
        AssessmentStatus.missing => AppColor.Fail,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: StreamBuilder<Course?>(
          stream: _course,
          builder: (context, courseSnap) {
            final course = courseSnap.data;
            return StreamBuilder<List<Assessment>>(
              stream: _assessments,
              builder: (context, listSnap) {
                final items = listSnap.data ?? const <Assessment>[];
                final empty = course == null || items.isEmpty;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      BigNumberCard(
                        label: 'Grade',
                        value: empty ? '00' : '${course.grade}',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          StatBox(label: 'Task', value: empty ? '0' : '${course.taskScore}', color: AppColor.SubjectGreen),
                          StatBox(label: 'Attend', value: empty ? '0' : '${course.attendScore}', color: AppColor.SubjectBlue),
                          StatBox(label: 'UTS', value: empty ? '0' : '${course.utsScore}', color: AppColor.SubjectPurple),
                          StatBox(label: 'UAS', value: empty ? '0' : '${course.uasScore}', color: AppColor.SubjectYellow),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Assignment Assessment',
                        style: AppTextStyles.subheading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (items.isEmpty)
                        const EmptyState(
                          icon: Icons.emoji_events_outlined,
                          message: 'There is no grade available for this course yet.',
                        )
                      else
                        ...items.map(
                          (a) => StatusRow(
                            label: a.title,
                            status: _statusText(a),
                            color: _statusColor(a),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

---

### `frontend/lib/page/attend_detail.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/detail_parts.dart';
import '../widgets/states/empty_state.dart';

class AttendDetailPage extends StatefulWidget {
  const AttendDetailPage({super.key, required this.courseId});

  final int courseId;

  @override
  State<AttendDetailPage> createState() => _AttendDetailPageState();
}

class _AttendDetailPageState extends State<AttendDetailPage> {
  late final Stream<Course?> _course;
  late final Stream<List<AttendanceLog>> _history;

  @override
  void initState() {
    super.initState();
    final repo = context.read<NexaRepository>();
    _course = repo.watchCourse(widget.courseId);
    _history = repo.watchAttendance(widget.courseId);
  }

  String _statusText(AttendanceStatus s) => switch (s) {
        AttendanceStatus.attend => 'Attend',
        AttendanceStatus.permit => 'Permit',
        AttendanceStatus.sick => 'Sick',
        AttendanceStatus.alpha => 'Alpha',
      };

  Color _statusColor(AttendanceStatus s) => switch (s) {
        AttendanceStatus.attend => AppColor.Success,
        AttendanceStatus.permit => AppColor.Average,
        AttendanceStatus.sick => AppColor.SubjectPurple,
        AttendanceStatus.alpha => AppColor.Fail,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: StreamBuilder<Course?>(
          stream: _course,
          builder: (context, courseSnap) {
            final course = courseSnap.data;
            return StreamBuilder<List<AttendanceLog>>(
              stream: _history,
              builder: (context, listSnap) {
                final items = listSnap.data ?? const <AttendanceLog>[];
                final empty = course == null || items.isEmpty;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      BigNumberCard(
                        label: 'Attendance',
                        value: empty ? '0%' : '${course.attendPercent}%',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          StatBox(label: 'Attend', value: empty ? '0' : '${course.attendCount}', color: AppColor.SubjectGreen),
                          StatBox(label: 'Permit', value: empty ? '0' : '${course.permitCount}', color: AppColor.Average),
                          StatBox(label: 'Sick', value: empty ? '0' : '${course.sickCount}', color: AppColor.SubjectPurple),
                          StatBox(label: 'Alpha', value: empty ? '0' : '${course.alphaCount}', color: AppColor.Fail),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'History Attendance',
                        style: AppTextStyles.subheading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (items.isEmpty)
                        const EmptyState(
                          icon: Icons.person_outline,
                          message: 'There is no attendance available for this course yet.',
                        )
                      else
                        ...items.map(
                          (h) => StatusRow(
                            label: h.title,
                            status: _statusText(h.status),
                            color: _statusColor(h.status),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

---

### `frontend/lib/widgets/detail_parts.dart`

```dart
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

```

---

### `frontend/lib/widgets/course_avatar.dart`

```dart
import 'package:flutter/material.dart';

import 'course_palette.dart';

/// Subject artwork, ported from Mayla's `asset/image/subject/`.
///
/// Course names come from the backend/database, so the image is matched by
/// name. Unknown courses fall back to the pastel swatch from [courseColor].
const Map<String, String> _courseImages = {
  'Pemrograman Mobile': 'asset/image/subject/Pemmob.png',
  'Jaringan Komputer': 'asset/image/subject/JK.png',
  'Kecerdasan Buatan': 'asset/image/subject/AI.png',
  'Basis Data': 'asset/image/subject/BasDat.png',
  'Sistem Operasi': 'asset/image/subject/OS.png',
  'Pemrograman Web': 'asset/image/subject/Pemweb.png',
  'Statistika': 'asset/image/subject/Statistika.png',
};

String? courseImageAsset(String courseName) => _courseImages[courseName];

/// Small rounded subject thumbnail with a colored fallback.
class CourseAvatar extends StatelessWidget {
  const CourseAvatar({
    super.key,
    required this.courseName,
    required this.colorIndex,
    this.size = 26,
    this.radius = 6,
  });

  final String courseName;
  final int colorIndex;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: courseColor(colorIndex),
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    final asset = courseImageAsset(courseName);
    if (asset == null) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}

```

---

### `frontend/lib/widgets/course_palette.dart`

```dart
import 'package:flutter/material.dart';
import '../style/color_style.dart';

const _palette = <Color>[
  AppColor.SubjectPurple,
  AppColor.SubjectBlue,
  AppColor.SubjectPink,
  AppColor.SubjectPeach,
  AppColor.SubjectGreen,
  AppColor.SubjectYellow,
];

/// Pastel color for a course, from the `colorIndex` stored with it.
Color courseColor(int colorIndex) => _palette[colorIndex.abs() % _palette.length];

```

---

### `frontend/lib/widgets/states/empty_state.dart`

```dart
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
            style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColor.TextBody.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}

```

---

### `frontend/lib/style/color_style.dart`

```dart
import 'package:flutter/material.dart';

// Palette constants intentionally use PascalCase (AppColor.Primary, ...).
// ignore_for_file: constant_identifier_names

class AppColor{
  static const Color Primary = Color(0xFF00245D);
  static const Color Secondary = Color(0xFFCAE5FD);
  static const Color Background = Color(0xFFFFFFFF);

  static const Color TextPrimary =Color(0xFF00245D);
  static const Color TextSecondary =Color(0xFFFFFFFF);
  static const Color TextBody =Color(0xFF000000);
  static const Color TextSucces =Color(0xFF2B8B3C);
  static const Color TextFail =Color(0xFFFF0207);
  static const Color TextAverage = Color(0xFFFF7C09);

  static const Color Success =Color(0xFFABF3BB);
  static const Color Fail =Color(0xFFFF9E9E);
  static const Color Average =Color(0xFFFDF3B8);

  static const Color Border =Color(0xFFD1D6DB);

  static const Color SubjectPurple = Color(0xFFE4D6FF);
  static const Color SubjectBlue = Color(0xFFDDEAFF);
  static const Color SubjectPink = Color(0xFFFCE8EF);
  static const Color SubjectPeach = Color(0xFFFFF0EA);
  static const Color SubjectGreen = Color(0xFFDDF8EA);
  static const Color SubjectYellow = Color(0xFFFFF4D9);

}
```

---

### `frontend/lib/style/text_style.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subheading = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle report = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}

```

---

### `frontend/lib/data/models/course.dart`

```dart
import 'course_details.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.colorIndex,
    required this.grade,
    required this.letter,
    required this.taskScore,
    required this.attendScore,
    required this.utsScore,
    required this.uasScore,
    required this.attendPercent,
    required this.attendCount,
    required this.permitCount,
    required this.sickCount,
    required this.alphaCount,
    this.lastFetched,
  });

  final int id;
  final String name;
  final String code;

  /// Index into the pastel palette (see widgets/course_palette.dart).
  final int colorIndex;
  final int grade;
  final String letter;
  final int taskScore;
  final int attendScore;
  final int utsScore;
  final int uasScore;
  final int attendPercent;
  final int attendCount;
  final int permitCount;
  final int sickCount;
  final int alphaCount;
  final DateTime? lastFetched;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        code: json['code'] as String,
        colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
        grade: (json['grade'] as num).toInt(),
        letter: json['letter'] as String,
        taskScore: (json['taskScore'] as num?)?.toInt() ?? 0,
        attendScore: (json['attendScore'] as num?)?.toInt() ?? 0,
        utsScore: (json['utsScore'] as num?)?.toInt() ?? 0,
        uasScore: (json['uasScore'] as num?)?.toInt() ?? 0,
        attendPercent: (json['attendPercent'] as num?)?.toInt() ?? 0,
        attendCount: (json['attendCount'] as num?)?.toInt() ?? 0,
        permitCount: (json['permitCount'] as num?)?.toInt() ?? 0,
        sickCount: (json['sickCount'] as num?)?.toInt() ?? 0,
        alphaCount: (json['alphaCount'] as num?)?.toInt() ?? 0,
      );
}

/// One course plus its detail lists, exactly as the API returns it.
/// The repository stores these together in a single DB transaction.
class CourseBundle {
  const CourseBundle({
    required this.course,
    required this.assessments,
    required this.attendance,
    required this.feedback,
  });

  final Course course;
  final List<Assessment> assessments;
  final List<AttendanceLog> attendance;
  final List<FeedbackNote> feedback;

  factory CourseBundle.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) parse) =>
        ((json[key] as List?) ?? const [])
            .map((e) => parse(e as Map<String, dynamic>))
            .toList();

    return CourseBundle(
      course: Course.fromJson(json),
      assessments: list('assessments', Assessment.fromJson),
      attendance: list('attendance', AttendanceLog.fromJson),
      feedback: list('feedback', FeedbackNote.fromJson),
    );
  }
}

```

---

### `frontend/lib/data/models/course_details.dart`

```dart
/// Safely turn a stored/JSON string back into an enum value.
T enumFromName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

enum AssessmentStatus { onTime, late, missing }

enum AttendanceStatus { attend, permit, sick, alpha }

class Assessment {
  const Assessment({required this.title, required this.status, this.score});

  final String title;
  final AssessmentStatus status;

  /// Null when the student didn't submit.
  final int? score;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        title: json['title'] as String,
        status: enumFromName(
            AssessmentStatus.values, json['status'], AssessmentStatus.onTime),
        score: (json['score'] as num?)?.toInt(),
      );
}

class AttendanceLog {
  const AttendanceLog({required this.title, required this.status});

  final String title;
  final AttendanceStatus status;

  factory AttendanceLog.fromJson(Map<String, dynamic> json) => AttendanceLog(
        title: json['title'] as String,
        status: enumFromName(
            AttendanceStatus.values, json['status'], AttendanceStatus.attend),
      );
}

class FeedbackNote {
  const FeedbackNote({required this.title, required this.body});

  final String title;
  final String body;

  factory FeedbackNote.fromJson(Map<String, dynamic> json) => FeedbackNote(
        title: json['title'] as String,
        body: json['body'] as String,
      );
}

```

---

### `frontend/lib/page/feedback_detail.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/course.dart';
import '../data/models/course_details.dart';
import '../data/repositories/nexa_repository.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/detail_parts.dart';
import '../widgets/states/empty_state.dart';

class FeedbackDetailPage extends StatefulWidget {
  const FeedbackDetailPage({super.key, required this.courseId});

  final int courseId;

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  late final Stream<Course?> _course;
  late final Stream<List<FeedbackNote>> _notes;

  @override
  void initState() {
    super.initState();
    final repo = context.read<NexaRepository>();
    _course = repo.watchCourse(widget.courseId);
    _notes = repo.watchFeedback(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: StreamBuilder<Course?>(
          stream: _course,
          builder: (context, courseSnap) {
            final course = courseSnap.data;
            return StreamBuilder<List<FeedbackNote>>(
              stream: _notes,
              builder: (context, listSnap) {
                final notes = listSnap.data ?? const <FeedbackNote>[];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailTopBar(title: course?.name ?? ''),
                      const SizedBox(height: 16),
                      Text(
                        'Assignment Assessment',
                        style: AppTextStyles.subheading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      if (notes.isEmpty)
                        const EmptyState(
                          icon: Icons.chat_bubble_outline,
                          message: 'There is no feedback available for this course yet.',
                        )
                      else
                        ...notes.map(
                          (n) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.Secondary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.rate_review_outlined,
                                        color: AppColor.Fail, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        style: AppTextStyles.subheading
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  n.body,
                                  style: AppTextStyles.body
                                      .copyWith(fontSize: 12.5, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

```

---

### `frontend/lib/widgets/course_score_row.dart`

```dart
import 'package:flutter/material.dart';
import '../data/models/course.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'course_avatar.dart';

/// Row used by the Grade, Attend and Feedback lists: swatch, name/code,
/// score, letter badge and a chevron.
class CourseScoreRow extends StatelessWidget {
  const CourseScoreRow({super.key, required this.course, required this.onTap});

  final Course course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isA = course.letter.toUpperCase().startsWith('A');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.Border, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CourseAvatar(
              courseName: course.name,
              colorIndex: course.colorIndex,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subheading
                        .copyWith(color: AppColor.Primary, fontSize: 15),
                  ),
                  Text(
                    course.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body
                        .copyWith(color: AppColor.Primary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text('${course.grade}',
                style: AppTextStyles.subheading.copyWith(fontSize: 16)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isA ? AppColor.Success : AppColor.SubjectPeach,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course.letter,
                style: AppTextStyles.subheading.copyWith(
                  fontSize: 13,
                  color: isA ? AppColor.TextBody : const Color(0xFF8B4A2B),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: AppColor.Primary),
          ],
        ),
      ),
    );
  }
}

```

---

### `frontend/lib/widgets/subject_row.dart`

```dart
import 'package:flutter/material.dart';
import '../data/models/course.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'course_avatar.dart';

/// Compact course row with 3 quick actions (attend / grade / feedback),
/// used on the Dashboard. Fixed-width parts are kept small on purpose so the
/// Expanded name/code column always keeps room on narrow screens.
class SubjectActionRow extends StatelessWidget {
  const SubjectActionRow({
    super.key,
    required this.course,
    this.onAttend,
    this.onGrade,
    this.onFeedback,
  });

  final Course course;
  final VoidCallback? onAttend;
  final VoidCallback? onGrade;
  final VoidCallback? onFeedback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.Border, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CourseAvatar(
            courseName: course.name,
            colorIndex: course.colorIndex,
            size: 30,
            radius: 8,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subheading
                      .copyWith(color: AppColor.Primary, fontSize: 14),
                ),
                Text(
                  course.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body
                      .copyWith(color: AppColor.Primary, fontSize: 11),
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
        child: Icon(icon, color: AppColor.Primary, size: 22),
      ),
    );
  }
}

```

---

### `frontend/pubspec.yaml`

```yaml
name: mobile
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.13.1

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  google_fonts: ^8.2.1
  provider: ^6.1.5+1
  http: ^1.6.0
  shared_preferences: ^2.5.6
  flutter_secure_storage: ^11.2.0
  drift: ^2.35.2
  drift_flutter: ^0.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0
  drift_dev: ^2.35.1
  build_runner: ^2.16.2

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - asset/image/
    - asset/image/subject/

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package

```

---

## §9. Checklist hasil (minta Claude memenuhi ini)

- [ ] `GradeDetailPage` & `AttendDetailPage` bisa di-compile tanpa error.
- [ ] Constructor dan `courseId` tidak berubah.
- [ ] Data tetap dari `NexaRepository` (tidak ada API call langsung).
- [ ] Tidak ada `RenderFlex overflow` di lebar 360dp (uji juga 320dp).
- [ ] State loading, empty, dan normal semuanya ada dan benar.
- [ ] Tidak ada `00`/`0` palsu saat course ada tapi list kosong.
- [ ] Warna memakai `AppColor` (atau token baru di `color_style.dart`).
- [ ] Font tetap Poppins.
- [ ] Tidak ada package baru di `pubspec.yaml`.
- [ ] `feedback_detail.dart` tetap bisa di-compile (kalau `DetailTopBar` berubah).
- [ ] Tidak ada widget yang dihapus tanpa alasan (fitur tetap lengkap).
- [ ] Output berupa file utuh, bukan diff.

---

## §10. Jangan dilakukan

- Jangan mengubah `lib/main.dart`, data layer, Drift, repository, atau API client.
- Jangan membuat mock data baru di dalam halaman detail.
- Jangan mengganti provider/state management.
- Jangan menambahkan routing baru; navigasi tetap `Navigator.push`.
- Jangan memakai package chart eksternal (kalau butuh grafik, gambar manual
  dengan `CustomPainter` atau widget bawaan).
- Jangan hardcode hex warna di widget.

---

> File ini adalah konteks bantu. Setelah redesign selesai, jalankan:
> `flutter analyze` dan `flutter test` di folder `frontend/`.
