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
