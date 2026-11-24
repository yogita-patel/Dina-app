import 'package:flutter/material.dart';

class MobikulTheme {
  static const Color primaryColor = Color(0xFF0D479C);
  static const Color accentColor = Color(0xFFFFD269);

  static const Color iconColor = Colors.white;
}

class AppTheme {
  AppTheme._();
  static Color iconColor = _lightPrimaryColor;
  static const Color _iconColor = _lightPrimaryColor;

  static const Color _lightPrimaryColor = Color(0xFF546E7A);
  static const Color _lightPrimaryVariantColor = MobikulTheme.primaryColor;
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.white12;
  static const Color _darkBackgroundColor = Color(0xFF383838);
  static const Color darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color darkOnPrimaryColor = Colors.white;

  static var darkSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((states) {
      for (var i in states) {
        if (i == WidgetState.selected) {
          return _darkPrimaryColor;
        }
      }
      return darkPrimaryVariantColor;
    }),
    trackColor: WidgetStateColor.resolveWith((states) {
      for (var i in states) {
        if (i == WidgetState.selected) {
          return _darkPrimaryColor.withOpacity(0.7);
        }
      }
      return Colors.grey;
    }),
  );

  static var darkRadioTheme = RadioThemeData(
    fillColor: WidgetStateColor.resolveWith((states) {
      for (var i in states) {
        if (i == WidgetState.selected) {
          return darkOnPrimaryColor;
        }
      }
      return _darkPrimaryColor;
    }),
  );

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      buttonTheme: const ButtonThemeData(buttonColor: _lightPrimaryColor),
      secondaryHeaderColor: Colors.white30,
      indicatorColor: _lightOnPrimaryColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: MobikulTheme.accentColor),
      inputDecorationTheme: const InputDecorationTheme(fillColor: _lightPrimaryColor),
      cardColor: darkOnPrimaryColor,
      hoverColor: _lightPrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: _darkSecondaryColor,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 20),
        // color: _lightPrimaryVariantColor,
        backgroundColor: _lightPrimaryVariantColor,
        iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor,
      ),
      iconTheme: const IconThemeData(
        color: _iconColor,
      ),
      textTheme: _lightTextTheme,
      dividerTheme: const DividerThemeData(color: Colors.black12),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          //  primary: _darkSecondaryColor,
          side: const BorderSide(color: _lightPrimaryColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _lightPrimaryColor,
          // side: const BorderSide(color: lightPrimaryColor),
        ),
      ),
      radioTheme: radioTheme,
      switchTheme: switchTheme);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    buttonTheme: const ButtonThemeData(buttonColor: darkPrimaryVariantColor),
    secondaryHeaderColor: Colors.white12,
    indicatorColor: darkOnPrimaryColor,
    hoverColor: _darkPrimaryColor,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.black),
    inputDecorationTheme: const InputDecorationTheme(fillColor: Colors.black),
    cardColor: _darkBackgroundColor,
    scaffoldBackgroundColor: _darkPrimaryColor,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: _darkSecondaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      color: darkPrimaryVariantColor,
      iconTheme: IconThemeData(color: darkOnPrimaryColor),
    ),
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkSecondaryColor,
      onPrimary: darkOnPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: darkOnPrimaryColor,
    ),
    primaryIconTheme: const IconThemeData(
      color: darkOnPrimaryColor,
    ),
    textTheme: _darkTextTheme,
    dividerTheme: const DividerThemeData(color: Colors.white38),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: darkPrimaryVariantColor,
        // primary: _darkSecondaryColor,
        side: const BorderSide(color: _darkPrimaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // primary: darkOnPrimaryColor,
        //  iconColor: darkOnPrimaryColor,
        surfaceTintColor: darkOnPrimaryColor,
        foregroundColor: darkOnPrimaryColor,
        backgroundColor: Colors.transparent,
        // side: const BorderSide(color: lightPrimaryColor),
      ),
    ),
    radioTheme: darkRadioTheme,
    switchTheme: darkSwitchTheme,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateColor.resolveWith(
        (states) => darkPrimaryVariantColor,
      ),
    ),
  );

  static var switchTheme = SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((states) {
      for (var i in states) {
        if (i == WidgetState.selected) {
          return _lightPrimaryColor;
        }
      }
      return Colors.white;
    }),
    trackColor: WidgetStateColor.resolveWith((states) {
      for (var i in states) {
        if (i == WidgetState.selected) {
          return _lightPrimaryColor.withOpacity(0.7);
        }
      }
      return Colors.grey;
    }),
  );

  static var radioTheme = RadioThemeData(
    fillColor: WidgetStateColor.resolveWith((states) {
      for (var i in states) {
        if (i == WidgetState.selected) {
          return _lightPrimaryColor;
        }
      }
      return _lightPrimaryColor;
    }),
  );


  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: _lightScreenHeading1TextStyle,
    displayMedium: _lightScreenHeading2TextStyle,
    displaySmall: _lightScreenHeading3TextStyle,
    headlineMedium: _lightScreenHeading4TextStyle,
    headlineSmall: _lightScreenHeading5TextStyle,
    titleLarge: _lightScreenHeading6TextStyle,
    titleMedium: _lightScreenSubTile1TextStyle,
    titleSmall: _lightScreenSubTile2TextStyle,
    bodyLarge: _lightScreenTaskNameTextStyle,
    bodyMedium: _lightScreenTaskDurationTextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: _darkScreenHeading1TextStyle,
    displayMedium: _darkScreenHeading2TextStyle,
    displaySmall: _darkScreenHeading3TextStyle,
    headlineMedium: _darkScreenHeading4TextStyle,
    headlineSmall: _darkScreenHeading5TextStyle,
    titleLarge: _darkScreenHeading6TextStyle,
    titleMedium: _darkScreenSubTile1TextStyle,
    titleSmall: _darkScreenSubTile2TextStyle,
    bodyLarge: _darkScreenTaskNameTextStyle,
    bodyMedium: _darkScreenTaskDurationTextStyle,
  );

  static const TextStyle _lightScreenHeading1TextStyle = TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Inter");

  static const TextStyle _lightScreenHeading2TextStyle = TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Inter");

  static const TextStyle _lightScreenHeading3TextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Inter");

  static const TextStyle _lightScreenHeading4TextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Inter");

  static const TextStyle _lightScreenHeading5TextStyle = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Inter");

  static const TextStyle _lightScreenHeading6TextStyle = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Inter");

  static const TextStyle _lightScreenTaskNameTextStyle = TextStyle(
      fontSize: 17.0, color: _lightOnPrimaryColor, fontFamily: "Inter");

  static const TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: "Inter");

  static const TextStyle _lightScreenSubTile1TextStyle =
      TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: "Inter");

  static const TextStyle _lightScreenSubTile2TextStyle =
      TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "Inter");

  static final TextStyle _darkScreenHeading1TextStyle =
      _lightScreenHeading1TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenHeading2TextStyle =
      _lightScreenHeading2TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenHeading3TextStyle =
      _lightScreenHeading3TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenHeading4TextStyle =
      _lightScreenHeading4TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenHeading5TextStyle =
      _lightScreenHeading5TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenHeading6TextStyle =
      _lightScreenHeading6TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenTaskNameTextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenTaskDurationTextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenSubTile1TextStyle =
      _lightScreenSubTile1TextStyle.copyWith(color: darkOnPrimaryColor);

  static final TextStyle _darkScreenSubTile2TextStyle =
      _lightScreenSubTile2TextStyle.copyWith(color: darkOnPrimaryColor);
}
