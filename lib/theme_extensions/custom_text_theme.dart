import 'package:ai_image_annotator/lite_state/long_living_controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kNormalFontSize = 16.0;

double get bigTextSize => 32.0 * customFontScale;
double get normalTextSize => kNormalFontSize * customFontScale;
double get tinyTextSize => 12.0 * customFontScale;
double get mediumTextSize => 22.0 * customFontScale;

double get customFontScale {
  return settingsController.fontScale;
}


@immutable
class CustomTextTheme extends ThemeExtension<CustomTextTheme> {
  const CustomTextTheme({
    required this.defaultStyle,
    required this.captionStyle,
    required this.descriptionStyle,
    required this.headerStyle,
    this.boldStyle,
    this.labelStyle,
  });


  final TextStyle descriptionStyle;
  final TextStyle captionStyle;
  final TextStyle headerStyle;
  final TextStyle defaultStyle; 
  final TextStyle? boldStyle; 
  final TextStyle? labelStyle; 

  factory CustomTextTheme.dark() {
    return CustomTextTheme(
      captionStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: tinyTextSize,
        color: const Color.fromARGB(255, 132, 132, 132),
      ),
      descriptionStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: normalTextSize,
      ),
      headerStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: mediumTextSize,
      ),
      defaultStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: normalTextSize,
      ),
      labelStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        // fontStyle: FontStyle.italic,
        color: Colors.grey,
        fontSize: normalTextSize,
      ),
      boldStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontWeight: FontWeight.bold,
        fontSize: normalTextSize,
      ),
    );
  }

  factory CustomTextTheme.light() {
    return CustomTextTheme(

      captionStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: tinyTextSize,
        color: const Color.fromARGB(255, 139, 139, 139),
      ),
      descriptionStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: normalTextSize,
      ),
      headerStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: mediumTextSize,
      ),
      defaultStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontSize: normalTextSize,
      ),
      labelStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        // fontStyle: FontStyle.italic,
        color: Colors.grey,
        fontSize: normalTextSize,
      ),
      boldStyle: GoogleFonts.lato().copyWith(
        inherit: true,
        fontWeight: FontWeight.bold,
        fontSize: normalTextSize,
      ),
    );
  }
  @override
  ThemeExtension<CustomTextTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<CustomTextTheme> lerp(
    covariant ThemeExtension<CustomTextTheme>? other,
    double t,
  ) {
    return this;
  }

  static CustomTextTheme of(BuildContext context) {
    return Theme.of(context).extension<CustomTextTheme>()!;
  }
}
