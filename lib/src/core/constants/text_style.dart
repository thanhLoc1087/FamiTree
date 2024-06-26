import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTextStyles {
  static TextStyle header = GoogleFonts.inter(
    color: AppColor.backgroundComplementary,
    fontWeight: FontWeight.bold,
    fontSize: 20
  );
  static TextStyle header2 = GoogleFonts.inter(
    color: AppColor.accent,
    fontWeight: FontWeight.bold,
    fontSize: 20
  );
  static TextStyle body = const TextStyle(
    color: AppColor.text,
    fontSize: 16
  );
}