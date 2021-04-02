import 'package:Outfitter/constants/styles.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:preferences/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchURL() async {
    final params = Uri(
      scheme: 'mailto',
      path: 'tariqsaiyad98@gmail.com',
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void updateTheme() {
    DynamicTheme.of(context).setThemeData(
      ThemeData(
        brightness: PrefService.getBool("app_theme_bool")
            ? Brightness.dark
            : Brightness.light,
        primaryColor: Color(PrefService.getInt("primary_col")),
        accentColor: Color(PrefService.getInt("accent_col")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: Styles.title,
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
              SwitchPreference(
                'Dark Mode',
                'app_theme_bool',
                defaultVal: PrefService.getBool('app_theme_bool'),
                onChange: () => updateTheme(),
                switchActiveColor: Color(PrefService.getInt('primary_col')),
              ),
              MaterialButton(
                padding: const EdgeInsets.all(8),
                onPressed: _showAboutDialog,
                child: const Text(
                  "ABOUT APP",
                  style: Styles.spaced2,
                ),
              )
            ]))
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
        context: context,
        applicationName: 'Outfitter',
        applicationVersion: "1.00",
        applicationLegalese: "Developed by Tariq Saiyad",
        children: <Widget>[
          Divider(
            color: Theme.of(context).primaryColor,
            endIndent: 8,
            indent: 8,
            thickness: 1,
          ),
          Text(
            'Flick me an email if you have any feedback or questions',
            textAlign: TextAlign.center,
            style: Styles.subtitle2,
          ),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: _launchURL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'tariqsaiyad98@gmail.com',
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(decoration: TextDecoration.underline),
                  ),
                  const Icon(
                    Icons.launch,
                    size: 18,
                  )
                ],
              )),
        ],
        applicationIcon: Image.asset(
          "assets/logo.png",
          width: 80,
        ));
  }

  ListTile _colorTile(BuildContext context, String key) {
    var title = key == "primary_col" ? "Primary Colour" : "Accent Colour";
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
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => _setColor(key),
              child: const Text('SELECT'),
            ),
          ],
        );
      },
    );
  }
}
