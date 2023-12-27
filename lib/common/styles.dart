import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color white = Color(0xFFFFFFFF);
const Color whiteShadow = Color(0xFFE6EAEE);
const Color whiteBackground = Color(0xFFF5F5F7);
const Color black = Color(0xFF181A20);
const Color grey = Color(0xFF373737);
const Color darkGrey = Color(0xFF252525);
const Color blackDarker = Color(0xFF0D0D0D);
const Color customBlue = Color(0xFF497BEA);
const Color customYellow = Color(0xFFFBBC05);

final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(
    fontSize: 92,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  ),
  displayMedium: GoogleFonts.poppins(
    fontSize: 57,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  ),
  displaySmall: GoogleFonts.poppins(
    fontSize: 46,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  headlineSmall: GoogleFonts.poppins(
    fontSize: 23,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  titleMedium: GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  ),
  titleSmall: GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  bodyLarge: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyMedium: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  labelLarge: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  bodySmall: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  labelSmall: GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);

class TextStyles {
  static var kHeading1 = GoogleFonts.poppins(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
  );

  static var kHeading2 = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
  );

  static var kRegularTitle = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
  );

  static var kMediumTitle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static var kRegularBody = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );

  static var kSmallBody = GoogleFonts.poppins(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
  );
}

ThemeData lightTheme = ThemeData(
  primaryColor: white,
  brightness: Brightness.light,
  scaffoldBackgroundColor: whiteBackground,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: textTheme.apply(bodyColor: black, displayColor: black),
  colorScheme: const ColorScheme.light().copyWith(
    primary: white,
    secondary: customBlue,
  ),
  shadowColor: whiteShadow,
  iconTheme: const IconThemeData(color: black),
  appBarTheme: AppBarTheme(
    backgroundColor: white,
    shadowColor: Colors.transparent,
    toolbarTextStyle: textTheme.titleLarge!.copyWith(color: black),
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: white,
    selectedItemColor: customBlue,
    unselectedItemColor: Colors.grey[200],
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: darkGrey,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: blackDarker,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: textTheme.apply(bodyColor: white, displayColor: white),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: darkGrey,
    secondary: customBlue,
  ),
  shadowColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(
    backgroundColor: darkGrey,
    toolbarTextStyle: textTheme.titleLarge!.copyWith(color: Colors.white),
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkGrey,
    selectedItemColor: customBlue,
    unselectedItemColor: grey,
  ),
);
