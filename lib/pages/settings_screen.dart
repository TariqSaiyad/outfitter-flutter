import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:preferences/preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function setScreen;

  const SettingsScreen({Key key, this.setScreen}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color _tempShadeColor;

  void _setColor(String key) {
    Navigator.of(context).pop();
    PrefService.setInt(key, _tempShadeColor.value);
    updateTheme();
  }

  void updateTheme() {
    DynamicTheme.of(context).setThemeData(
      ThemeData(
        brightness: PrefService.getInt("app_theme") == 0
            ? Brightness.dark
            : Brightness.light,
        primaryColor: Color(PrefService.getInt("primary_col")),
        accentColor: Color(PrefService.getInt("accent_col")),
      ),
    );
    //TODO: might not need
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Settings. Themes (light,dark, primary, accent), Add new categories...
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(
              letterSpacing: 2, fontWeight: FontWeight.w400, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
                child: PreferencePage([
              PreferenceTitle('Customisation'),
              _colorTile(context, 'primary_col'),
              _colorTile(context, 'accent_col'),
              DropdownPreference<int>(
                'App Theme',
                'app_theme',
                defaultVal: PrefService.getInt('app_theme'),
                displayValues: ['Dark', 'Light'],
                values: [0, 1],
                onChange: (val) => updateTheme(),
              ),
              _aboutDialog(context)
            ]))
          ],
        ),
      ),
    );
  }

  Padding _aboutDialog(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const Text(
            "ABOUT APP",
            style: const TextStyle(letterSpacing: 1),
          ),
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Outfitter',
              applicationVersion: "1.00",
              applicationLegalese: "Developed by Tariq Saiyad",
              children: <Widget>[],
              applicationIcon: Image.asset(
                "assets/logo.png",
                width: 80,
              ))),
    );
  }

  ListTile _colorTile(BuildContext context, String key) {
    String title = key == "primary_col" ? "Primary Color" : "Accent Color";
    return ListTile(
      trailing: PrefService.getInt(key) != null
          ? CircleColor(
              color: Color(PrefService.getInt(key)),
              circleSize: 30,
            )
          : const SizedBox(),
      title: Text(title),
      onTap: () {
        _openDialog(
            context,
            title,
            MaterialColorPicker(
              colors: fullMaterialColors,
              selectedColor: Color(PrefService.getInt(key)),
              onColorChange: (color) => setState(() => _tempShadeColor = color),
              onMainColorChange: (color) =>
                  setState(() => _tempShadeColor = color),
            ),
            key);
        setState(() {});
      },
    );
  }

  void _openDialog(
      BuildContext context, String title, Widget content, String key) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: const Text('SUBMIT'),
              onPressed: () => _setColor(key),
            ),
          ],
        );
      },
    );
  }
}
