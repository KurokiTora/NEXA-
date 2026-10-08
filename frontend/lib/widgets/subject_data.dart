import 'package:flutter/material.dart';

import '../style/color_style.dart';

class Subject {
  final String name;
  final String code;
  final Color color;
  final int grade;
  final String letter;
  final String image;

  const Subject({
    required this.name,
    required this.code,
    required this.color,
    required this.grade,
    required this.letter,
    required this.image,
  });
}

const List<Subject> subjects = [
  Subject(
    name: 'Pemrograman Mobile',
    code: 'Arfan Karunia Setia Putra',
    color: AppColor.subjectPurple,
    grade: 88,
    letter: 'A',
    image: 'asset/image/subject/Pemmob.png',
  ),
  Subject(
    name: 'Jaringan Komputer',
    code: 'Firman Pratama Dewantara, S.ST., M.T.',
    color: AppColor.subjectBlue,
    grade: 88,
    letter: 'A',
    image: 'asset/image/subject/JK.png',
  ),
  Subject(
    name: 'Kecerdasan Buatan',
    code: 'Dr. Harnan Malik Abdullah, ST., M.Sc.',
    color: AppColor.subjectPink,
    grade: 88,
    letter: 'A',
    image: 'asset/image/subject/AI.png',
  ),
  Subject(
    name: 'Basis Data',
    code: 'Citra Dewi M, S.Sn.,MT.',
    color: AppColor.subjectPeach,
    grade: 86,
    letter: 'B+',
    image: 'asset/image/subject/BasDat.png',
  ),
  Subject(
    name: 'Sistem Operasi',
    code: 'Didik H. S.Kom.,MT',
    color: AppColor.subjectGreen,
    grade: 78,
    letter: 'B+',
    image: 'asset/image/subject/OS.png',
  ),
  Subject(
    name: 'Pemrograman Web',
    code: 'Myro Boyke Persijn, S. Sos. , MM',
    color: AppColor.subjectBlue,
    grade: 88,
    letter: 'A',
    image: 'asset/image/subject/Pemweb.png',
  ),
  Subject(
    name: 'Statistika',
    code: 'Hafrida Rahmah, S.T., M.MT.',
    color: AppColor.subjectYellow,
    grade: 88,
    letter: 'A',
    image: 'asset/image/subject/Statistika.png',
  ),
];
