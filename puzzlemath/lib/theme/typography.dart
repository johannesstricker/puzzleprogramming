import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './colors.dart';

final TextRegularS = GoogleFonts.rubik(
  textStyle: const TextStyle(
    color: ColorNeutral100,
    fontSize: 14,
    height: 1.43,
  ),
);

final TextMediumS = TextRegularS.copyWith(
  fontWeight: FontWeight.w600,
);

final TextRegularM = TextRegularS.copyWith(
  fontSize: 16,
  height: 1.5,
);

final TextMediumM = TextRegularM.copyWith(
  fontWeight: FontWeight.w600,
);

final TextHeading1 = GoogleFonts.bangers(
  textStyle: const TextStyle(
    color: ColorNeutral100,
    fontSize: 30,
  ),
);

final TextHeading2 = TextHeading1.copyWith(
  fontSize: 24,
);
