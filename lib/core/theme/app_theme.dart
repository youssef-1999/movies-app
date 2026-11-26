import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark);

    return base.copyWith(
      // Inter becomes the default font for the whole app
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        // Figma: Inter / Medium / 36
        headlineLarge: GoogleFonts.inter(
          fontSize: 26.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        // Inter / SemiBold / 20
        titleLarge: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
      ),
    );
  }
}
