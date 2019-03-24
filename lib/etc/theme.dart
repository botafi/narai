import 'package:flutter/material.dart';

const primaryColor = Color(0xff2196f3);
const primaryColorBrightness = Brightness.dark;
const primaryColorLight = Color(0xff6ec6ff);
const primaryColorDark = Color(0xff0069c0);
const secondaryColor = Color(0xffd32f2f);
const secondaryColorBrightness = Brightness.dark;
const secondaryGreen = Color(0xff00C853);
const secondaryGreenBrightness = Brightness.dark;
const secondaryOrange = Color(0xffFF9800);
const secondaryOrangeBrightness = Brightness.dark;
const secondaryColorLight = Color(0xffff6659);
const secondaryColorDark = Color(0xff9a0007);

const cardMainTitleFontSize = 27.0;
const cardTitleFontSize = 20.0;

final ThemeData theme = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    primaryColorBrightness: primaryColorBrightness,
    accentColor: secondaryColor,
    accentColorBrightness: secondaryColorBrightness,
    errorColor: secondaryColorDark,
    buttonTheme: base.buttonTheme.copyWith(),
    iconTheme: base.iconTheme.copyWith()
  );
}