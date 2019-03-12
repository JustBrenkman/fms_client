import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fms_client/server.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings {
  Color lifeStoryLines = Color.fromRGBO(0, 255, 0, 1);
  Color familyTreeLines = Color.fromRGBO(0, 0, 255, 1);
  Color spouseLines = Color.fromRGBO(255, 0, 0, 1);
  bool lifeStoryLinesView = true;
  bool familyTreeLinesView = true;
  bool spouseLinesView = true;

  void _load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lifeStoryLinesView = preferences.getBool("lifeStoryLinesView") ?? true;
    familyTreeLinesView = preferences.getBool("familyTreeLinesView") ?? true;
    spouseLinesView = preferences.getBool("spouseLinesView") ?? true;
  }

  void _save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("lifeStoryLinesView", lifeStoryLinesView);
    preferences.setBool("familyTreeLinesView", familyTreeLinesView);
    preferences.setBool("spouseLinesView", spouseLinesView);
  }

  static Settings _instance;

  static Settings getInstance() {
    if (_instance == null) {
      _instance = Settings();
      _instance._load();
    }
    return _instance;
  }
}



class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  String dropDown = 'Red';
  String username = "";
  Settings settings;

  @override
  void initState() {
    _setup();
    super.initState();
  }


  @override
  void dispose() {
    settings._save();
    super.dispose();
  }

  void changeColorAndPopout(Color color) => setState(() {
    settings.lifeStoryLines = color;
    Timer(const Duration(milliseconds: 500),
            () => Navigator.of(context).pop());
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          _lifeStoryTile(),
          _familyTreeLinesTile(),
          _spouseLinesTile(),
          _logout(),
        ],
      ),
    );
  }

  Widget _lifeStoryTile() {
    return ListTile(
      title: Text("Life Story Line Color"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 16
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                      color: settings.lifeStoryLines,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: settings.lifeStoryLines,
                        onColorChanged: (Color color) => setState(() => settings.lifeStoryLines = color),
                        enableLabel: true,
                        enableAlpha: false,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Switch(
              value: settings.lifeStoryLinesView,
              onChanged: (value) {
                setState(() {
                  settings.lifeStoryLinesView = value;
                });
              })
        ],
      ),
    );
  }

  Widget _familyTreeLinesTile() {
    return ListTile(
      title: Text("Family Tree Line Color"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 16
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                      color: settings.familyTreeLines,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: settings.familyTreeLines,
                        onColorChanged: (Color color) => setState(() => settings.familyTreeLines = color),
                        enableLabel: true,
                        enableAlpha: false,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Switch(
              value: settings.familyTreeLinesView,
              onChanged: (value) {
                setState(() {
                  settings.familyTreeLinesView = value;
                });
              })
        ],
      ),
    );
  }

  Widget _spouseLinesTile() {    return ListTile(
      title: Text("Spouse Line Color"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 16
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                      color: settings.spouseLines,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: settings.spouseLines,
                        onColorChanged: (Color color) => setState(() => settings.spouseLines = color),
                        enableLabel: true,
                        enableAlpha: false,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Switch(
              value: settings.spouseLinesView,
              onChanged: (value) {
                setState(() {
                  settings.spouseLinesView = value;
                });
              })
        ],
      ),
    );
  }

  _setup() async {
    username = await getUserName();
    settings = Settings.getInstance();
    setState(() {
      username = username;
    });
    setState(() {
      settings = settings;
    });
  }

  Widget _logout() {
    return ListTile(
      onTap: () => Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false),
      title: Text("Logout: " + username),
    );
  }
}
