import 'package:buddy_swap/auth/auth_provider.dart';
import 'package:buddy_swap/constants.dart';
import 'package:buddy_swap/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppConfig config = AppConfig.of(context)!;
  SharedPreferences? _prefs;
  ThemeMode? _selectedThemeMode;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initializePrefs();
      setSelectedThemeMode();
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  void setSelectedThemeMode() {
    setState(() {
      if (config.environment == Environment.prod) {
        _selectedThemeMode = getThemeMode(kProdThemeMode);
      } else {
        _selectedThemeMode = getThemeMode(kDevThemeMode);
      }
    });
  }

  ThemeMode getThemeMode(String themeKey) => ThemeMode.values.firstWhereOrNull((element) => element.name == _prefs?.getString(themeKey)) ?? ThemeMode.system;

  initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setSelectedThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings",
              style: GoogleFonts.permanentMarker(
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .titleLarge)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              ListTile(
                title: const Text("Theme mode"),
                subtitle: const Text("Switch between dark and light theme"),
                trailing: SizedBox(
                  height: 150,
                  width: 70,
                  child: DropdownButton(
                    items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>(
                          (ThemeMode tm) {
                        return DropdownMenuItem<ThemeMode>(
                          value: tm,
                          child: Text(tm.name),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedThemeMode = value!;
                      });
                      if (config.environment == Environment.prod) {
                       _prefs?.setString(kProdThemeMode, value!.name);
                      } else {
                        _prefs?.setString(kDevThemeMode, value!.name);
                      }
                    },
                    value: _selectedThemeMode,
                    isExpanded: true,
                  ),
                ),
              ),
              ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  _authProvider?.logout();
                  context.go('/login');
                },
              ),
              ListTile(
                title: const Text("Bank details"),
                trailing: const Icon(Icons.details),
                onTap: () {
                  context.go("/settings/bank");
                },
              )
            ],
          ),
        ));
  }
}
