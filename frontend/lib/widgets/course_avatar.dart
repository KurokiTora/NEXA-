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
