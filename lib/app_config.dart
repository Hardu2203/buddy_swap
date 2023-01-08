import 'package:flutter/material.dart';

//https://sebastien-arbogast.com/2022/05/02/multi-environment-flutter-projects-with-flavors/
enum Environment { dev, prod }

class AppConfig extends InheritedWidget {
  final Environment environment;
  final String appTitle;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  const AppConfig(
      {Key? key,
      required Widget child,
      required this.environment,
      required this.appTitle,
      required this.theme,
      required this.darkTheme,
      required this.themeMode})
      : super(
          key: key,
          child: child,
        );

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
