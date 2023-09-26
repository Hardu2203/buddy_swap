import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';
import 'constants.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await kEnv.contractAddress.initialize();
  var prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey(kProdThemeMode)) {
    prefs.setString(kProdThemeMode, ThemeMode.system.name.toString());
  }

  var configuredApp = AppConfig(
    environment: Environment.prod,
    appTitle: '[PROD]',
    // This theme was made for FlexColorScheme version 6.1.1. Make sure
// you use same or higher version, but still same major version. If
// you use a lower version, some properties may not be supported. In
// that case you can also remove them after copying the theme to your app.
    theme: FlexThemeData.light(
      scheme: FlexScheme.deepPurple,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 23,
      subThemesData: const FlexSubThemesData(),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
        keepPrimary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.permanentMarker().fontFamily,
    ),
    darkTheme: FlexThemeData.dark(
      scheme: FlexScheme.deepPurple,
      surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
      blendLevel: 20,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
        keepPrimary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the Playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.permanentMarker().fontFamily,
    ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
    themeMode: ThemeMode.values.firstWhere((element) => element.name == prefs.getString(kProdThemeMode)),
    child: MyApp(),
  );
  runApp(configuredApp);
}
