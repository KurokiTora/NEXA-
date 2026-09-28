import 'package:flutter/material.dart';

import '../style/color_style.dart';

class Subject {
  final String name;
  final String code;
  final Color color;
  final int grade;
  final String letter;

  const Subject({
    required this.name,
    required this.code,
    required this.color,
    required this.grade,
    required this.letter,
  });
}

const List<Subject> subjects = [
  Subject(
    name: 'Pemrograman Mobile',
    code: 'IT301',
    color: AppColor.subjectPurple,
    grade: 88,
    letter: 'A',
  ),
  Subject(
    name: 'Jaringan Komputer',
    code: 'IT302',
    color: AppColor.subjectBlue,
    grade: 88,
    letter: 'A',
  ),
  Subject(
    name: 'Kecerdasan Buatan',
    code: 'IT301',
    color: AppColor.subjectPink,
    grade: 88,
    letter: 'A',
  ),
  Subject(
    name: 'Basis Data',
    code: 'IT301',
    color: AppColor.subjectPeach,
    grade: 86,
    letter: 'B+',
  ),
  Subject(
    name: 'Sistem Operasi',
    code: 'IT301',
    color: AppColor.subjectGreen,
    grade: 78,
    letter: 'B+',
  ),
  Subject(
    name: 'Pemrograman Web',
    code: 'IT306',
    color: AppColor.subjectBlue,
    grade: 88,
    letter: 'A',
  ),
  Subject(
    name: 'Statistika',
    code: 'IT301',
    color: AppColor.subjectYellow,
    grade: 88,
    letter: 'A',
  ),
];
