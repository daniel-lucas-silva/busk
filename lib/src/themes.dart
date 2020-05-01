import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuskTheme {

  static ThemeData light(MaterialColor primaryColor) => ThemeData(
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    dividerTheme: DividerThemeData(
      thickness: 14,
      space: 14,
      color: Colors.grey[100],
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    typography: Typography(
      platform: TargetPlatform.iOS,
      englishLike: Typography.englishLike2018,
      dense: Typography.dense2018,
      tall: Typography.tall2018,
      black: Typography.blackCupertino,
      white: Typography.whiteCupertino,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: Colors.black54,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black54,
      ),
    ),
    primaryTextTheme: TextTheme(
      title: TextStyle(
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]),
      ),
    ),
    brightness: Brightness.light,
    cupertinoOverrideTheme: CupertinoThemeData(
      barBackgroundColor: Colors.white,
    ),
  );

  static ThemeData dark(MaterialColor primaryColor) => ThemeData(
    primarySwatch: primaryColor,
    accentColor: primaryColor.shade200,
    scaffoldBackgroundColor: Colors.white,
    dividerTheme: DividerThemeData(
      thickness: 14,
      space: 14,
      color: Colors.grey[100],
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    typography: Typography(
      platform: TargetPlatform.iOS,
      englishLike: Typography.englishLike2018,
      dense: Typography.dense2018,
      tall: Typography.tall2018,
      black: Typography.blackCupertino,
      white: Typography.whiteCupertino,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: Colors.black54,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black54,
      ),
    ),
    primaryTextTheme: TextTheme(
      title: TextStyle(
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]),
      ),
    ),
    brightness: Brightness.dark,
    cupertinoOverrideTheme: CupertinoThemeData(
      barBackgroundColor: Colors.white,
    ),
  );
}
