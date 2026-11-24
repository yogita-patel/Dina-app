import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/splash/bloc/splash_screen_bloc.dart';

import '../../config/theme.dart';
import '../../helper/app_shared_pref.dart';
import '../../helper/extension.dart';
import '../../models/ApiLoginResponse/api_login_response.dart';
import '../../models/splash/splash_screen_model.dart';
import '../../theme_bloc/theme_bloc.dart';
import 'bloc/splash_screen_state.dart';

class DynamicTheme {
  static const Color _lightOnPrimaryColor = Colors.black;
  static const Color darkOnPrimaryColor = Colors.white;

  Future<void> restoreSavedTheme() async {
    try {
      final lightThemeJson = await AppSharedPref.getLightTheme();
      final darkThemeJson = await AppSharedPref.getDarkTheme();

      if (lightThemeJson.isEmpty || darkThemeJson.isEmpty) {
        return;
      }

      final lightTheme =
          ThemeConfig.fromJson(jsonDecode(lightThemeJson) as Map<String, dynamic>);
      final darkTheme =
          ThemeConfig.fromJson(jsonDecode(darkThemeJson) as Map<String, dynamic>);

      _applyLightThemeConfig(
        LightThemeConfigure(
          appThemeColor: lightTheme.navigationColor,
          themeTextColor: lightTheme.navigationTitleColor,
          buttonColor: lightTheme.buttonBackgroundColor,
          buttonTextColor: lightTheme.buttonTextColor,
          backgroundColor: lightTheme.screenBackgroundColor,
          mobikulThemeBrightLogo: lightTheme.appLogo,
          lightSplashScreen: lightTheme.splashImage,
        ),
      );

      _applyDarkThemeConfig(
        DarkThemeConfigure(
          appThemeColorDark: darkTheme.navigationColor,
          themeTextColorDark: darkTheme.navigationTitleColor,
          buttonColorDark: darkTheme.buttonBackgroundColor,
          buttonTextColorDark: darkTheme.buttonTextColor,
          backgroundColor: darkTheme.screenBackgroundColor,
          mobikulThemeDarkLogo: darkTheme.appLogo,
          darkSplashScreen: darkTheme.splashImage,
        ),
      );
    } catch (e) {
      // Ignore cache restore issues and allow splash API flow to continue.
    }
  }

  void manageThemeData(
      SplashScreenModel? model,
      SplashScreenBloc? splashScreenBloc,
      ThemeBloc? bloc,
      BuildContext context) async {
    splashScreenBloc?.emit(const EmptyState());
    if (await updateLightTheme(model) || await updateDarkTheme(model)) {
      await _updateLightTheme(model?.light_theme_config, context);
      await _updateDarkTheme(model?.dark_theme_config, context);
      // print("font_family ${AppTheme.lightTheme.}");
      bloc?.add(ThemeChangeEvent(
        lightTheme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ));
    }
  }

  Future<bool> updateLightTheme(SplashScreenModel? model) async {
    var update = false;
    try {
      var theme =
          ThemeConfig.fromJson(jsonDecode(await AppSharedPref.getLightTheme()));
      if (model?.light_theme_config?.appThemeColor != theme.navigationColor) {
        update = true;
      }
      if (model?.light_theme_config?.themeTextColor !=
          theme.navigationTitleColor) {
        update = true;
      }
      if (model?.light_theme_config?.appThemeColor !=
          theme.screenBackgroundColor) {
        update = true;
      }
      if (model?.light_theme_config?.buttonColor !=
          theme.buttonBackgroundColor) {
        update = true;
      }
      if (model?.light_theme_config?.appThemeColor != theme.navigationColor) {
        update = true;
      }
      // if (model?.light_theme_config?.fontStyle != theme.fontStyle) {
      //   update = true;
      // }
      return update;
    } catch (e) {
      return true;
    }
  }

  Future<bool> updateDarkTheme(SplashScreenModel? model) async {
    var update = false;

    try {
      var theme =
          ThemeConfig.fromJson(jsonDecode(await AppSharedPref.getDarkTheme()));
      if (model?.dark_theme_config?.appThemeColorDark !=
          theme.navigationColor) {
        update = true;
      }
      if (model?.dark_theme_config?.themeTextColorDark !=
          theme.navigationTitleColor) {
        update = true;
      }
      if (model?.dark_theme_config?.appThemeColorDark !=
          theme.screenBackgroundColor) {
        update = true;
      }
      if (model?.dark_theme_config?.buttonColorDark !=
          theme.buttonBackgroundColor) {
        update = true;
      }
      if (model?.dark_theme_config?.appThemeColorDark !=
          theme.navigationColor) {
        update = true;
      }
      // if (model?.dark_theme_config?.fontStyle != theme.fontStyle) {
      //   update = true;
      // }
      return update;
    } catch (e) {
      return true;
    }
  }

  Future<void> _updateDarkTheme(
      DarkThemeConfigure? config, BuildContext context) async {
    await AppSharedPref.updateDarkTheme(jsonEncode(config));
    await AppSharedPref.themeUpdated(true);
    _applyDarkThemeConfig(config);
  }

  void _applyDarkThemeConfig(DarkThemeConfigure? config) {
    AppTheme.darkTheme = ThemeData(
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white, circularTrackColor: Colors.white),
      dialogTheme: DialogThemeData(backgroundColor: Colors.grey.shade700),
      inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          focusColor: Colors.white),
      indicatorColor: Colors.white,
      navigationBarTheme:
          NavigationBarThemeData(backgroundColor: Colors.grey.shade700),
      useMaterial3: true,
      fontFamily: GoogleFonts.getFont("Roboto").fontFamily,
      scaffoldBackgroundColor:
          HexColor.fromHex(config?.backgroundColor ?? "#0000000"),
      appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
        backgroundColor: HexColor.fromHex(
          config?.appThemeColorDark ?? "",
        ),
        titleTextStyle:
            AppTheme.lightTheme.appBarTheme.titleTextStyle?.copyWith(
          fontFamily: GoogleFonts.getFont("Roboto").fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: HexColor.fromHex(
            config?.themeTextColorDark ?? "",
          ),
        ),
      ),
      cardColor: Colors.grey.shade800,
      textTheme: _darkTextTheme,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            // primary: HexColor.fromHex(
            //   config?.buttonColorDark ?? "",
            // ),
            textStyle: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                  color: HexColor.fromHex(
                    config?.buttonColorDark ?? "",
                  ),
                )),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              // padding: MaterialStateProperty.all<EdgeInsets>(
              //     EdgeInsets.all(AppSizes.size12)),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((s) {
                if (s.contains(WidgetState.disabled)) {
                  return Colors.white; // Disabled button color
                }
                return HexColor.fromHex(
                  config?.buttonColorDark ?? "",
                ); // Enabled button color
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((s) {
                if (s.contains(WidgetState.disabled)) {
                  return Colors.white; // Disabled text color
                }
                return HexColor.fromHex(
                  config?.buttonTextColorDark ?? "",
                ); // Enabled text color
              }),
              textStyle: WidgetStateProperty.all(
                  AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                          color: HexColor.fromHex(
                        config?.buttonTextColorDark ?? "",
                      ))))),
      buttonTheme: ButtonThemeData(
          buttonColor: HexColor.fromHex(
            config?.buttonColorDark ?? "",
          ),
          textTheme: ButtonTextTheme.normal),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: HexColor.fromHex(
            config?.buttonColorDark ?? "",
          ),
          // primary: HexColor.fromHex(
          //   config?.buttonTextColorDark ?? "",
          // ),
          side: BorderSide(
            color: HexColor.fromHex(
              config?.buttonColorDark ?? "",
            ),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateColor.resolveWith((states) {
          for (var i in states) {
            if (i == WidgetState.selected) {
              return HexColor.fromHex(
                config?.buttonColorDark ?? "",
              );
            }
          }
          return Colors.white;
        }),
        trackColor: WidgetStateColor.resolveWith((states) {
          for (var i in states) {
            if (i == WidgetState.selected) {
              return HexColor.fromHex(
                config?.buttonColorDark ?? "",
              ).withOpacity(0.7);
            }
          }
          return Colors.grey;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          for (var i in states) {
            if (i == WidgetState.selected) {
              return HexColor.fromHex(
                config?.buttonColorDark ?? "",
              );
            }
          }
          return Colors.grey;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateColor.resolveWith(
          (states) {
            for (var i in states) {
              if (i == WidgetState.selected) {
                return HexColor.fromHex(
                  config?.buttonColorDark ?? "",
                );
              }
            }
            return Colors.grey;
          },
        ),
      ),
      colorScheme: AppTheme.lightTheme.colorScheme,
      dividerTheme: AppTheme.lightTheme.dividerTheme,
    );
  }

  Future<void> _updateLightTheme(
      LightThemeConfigure? config, BuildContext context) async {
    await AppSharedPref.updateLightTheme(jsonEncode(config));
    await AppSharedPref.themeUpdated(true);
    _applyLightThemeConfig(config);
  }

  void _applyLightThemeConfig(LightThemeConfigure? config) {
    AppTheme.iconColor = HexColor.fromHex(config?.appThemeColor ?? "");
    AppTheme.lightTheme = ThemeData(
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Colors.grey.shade700),
      useMaterial3: true,
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor:
              HexColor.fromHex(config?.backgroundColor ?? "#FFFFFF")),
      indicatorColor: Colors.black,
      fontFamily: GoogleFonts.getFont("Roboto").fontFamily,
      scaffoldBackgroundColor:
          HexColor.fromHex(config?.backgroundColor ?? "#FFFFFF"),
      appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
        backgroundColor: HexColor.fromHex(
          config?.appThemeColor ?? "",
        ),
        titleTextStyle:
            AppTheme.lightTheme.appBarTheme.titleTextStyle?.copyWith(
          fontFamily: GoogleFonts.getFont("Roboto").fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: HexColor.fromHex(
            config?.themeTextColor ?? "",
          ),
        ),
      ),
      textTheme: _lightTextTheme,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            // primary: HexColor.fromHex(
            //   config?.buttonColor ?? "",
            // ),
            textStyle: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: HexColor.fromHex(
                    config?.buttonColor ?? "",
                  ),
                )),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              // padding: MaterialStateProperty.all<EdgeInsets>(
              //     EdgeInsets.all(AppSizes.size12)),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((s) {
                if (s.contains(WidgetState.disabled)) {
                  return Colors.brown; // Disabled button color
                }
                return HexColor.fromHex(
                  config?.buttonColor ?? "",
                ); // Enabled button color
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((s) {
                if (s.contains(WidgetState.disabled)) {
                  return Colors.white30; // Disabled text color
                }
                return HexColor.fromHex(
                  config?.buttonTextColor ?? "",
                ); // Enabled text color
              }),
              textStyle: WidgetStateProperty.all(
                  AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: HexColor.fromHex(
                        config?.buttonTextColor ?? "",
                      ),
                      fontSize: AppSizes.size16)))),
      buttonTheme: ButtonThemeData(
          buttonColor: HexColor.fromHex(
            config?.buttonColor ?? "",
          ),
          textTheme: ButtonTextTheme.normal),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: HexColor.fromHex(
            config?.buttonColor ?? "",
          ),
          // primary: HexColor.fromHex(
          //   config?.buttonTextColor ?? "",
          // ),
          side: BorderSide(
            color: HexColor.fromHex(
              config?.buttonColor ?? "",
            ),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateColor.resolveWith((states) {
          for (var i in states) {
            if (i == WidgetState.selected) {
              return HexColor.fromHex(
                config?.buttonColor ?? "",
              );
            }
          }
          return Colors.white;
        }),
        trackColor: WidgetStateColor.resolveWith((states) {
          for (var i in states) {
            if (i == WidgetState.selected) {
              return HexColor.fromHex(
                config?.buttonColor ?? "",
              ).withOpacity(0.7);
            }
          }
          return Colors.grey;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          for (var i in states) {
            if (i == WidgetState.selected) {
              return HexColor.fromHex(
                config?.buttonColor ?? "",
              );
            }
          }
          return Colors.grey;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateColor.resolveWith(
          (states) {
            for (var i in states) {
              if (i == WidgetState.selected) {
                return HexColor.fromHex(
                  config?.buttonColor ?? "",
                );
              }
            }
            return Colors.grey;
          },
        ),
      ),
      colorScheme: AppTheme.lightTheme.colorScheme,
      iconTheme: const IconThemeData(color: Colors.black),
      dividerTheme: AppTheme.lightTheme.dividerTheme,
    );
  }

  /* void checkAndUpdateTheme() async {
    if ((await AppSharedPref.getLightTheme()).isNotEmpty && (await AppSharedPref.getDarkTheme()).isNotEmpty) {
      try {
        var lightTheme = ThemeConfig.fromJson(jsonDecode(await AppSharedPref.getLightTheme()));
        var darkTheme = ThemeConfig.fromJson(jsonDecode(await AppSharedPref.getDarkTheme()));
        await _updateLightTheme(lightTheme);
        // await _updateDarkTheme(darkTheme);
        // bloc?.add(ThemeChangeEvent(lightTheme: AppTheme.lightTheme, darkTheme: AppTheme.darkTheme,
        // ));
      } catch (e) {
        // ignore
      }
    }
  }*/

  /// **** Theme text constant valus ************
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
    // You can also add:
    // bodySmall: someStyle,
    // labelLarge: someStyle,
    // labelMedium: someStyle,
    // labelSmall: someStyle,
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
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
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
