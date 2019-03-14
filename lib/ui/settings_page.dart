import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fms_client/app_data.dart';
import 'package:fms_client/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fms_client/utils.dart';


class Settings {
  Color lifeStoryLines = Color.fromRGBO(0, 255, 0, 1);
  Color familyTreeLines = Color.fromRGBO(0, 0, 255, 1);
  Color spouseLines = Color.fromRGBO(255, 0, 0, 1);

  Color baptismEvent = hslToColor(BitmapDescriptor.hueCyan, 1, 0.5);
  Color birthEvent = hslToColor(BitmapDescriptor.hueOrange, 1, 0.5);
  Color censusEvent = hslToColor(BitmapDescriptor.hueRose, 1, 0.5);
  Color christeningEvent = hslToColor(BitmapDescriptor.hueYellow, 1, 0.5);
  Color marriageEvent = hslToColor(BitmapDescriptor.hueAzure, 1, 0.5);
  Color travelEvent =  hslToColor(BitmapDescriptor.hueMagenta, 1, 0.5);
  Color deathEvent =hslToColor(BitmapDescriptor.hueViolet, 1, 0.5);

  bool lifeStoryLinesView = true;
  bool familyTreeLinesView = true;
  bool spouseLinesView = true;

  MapType mapType = MapType.normal;

  void setDefault() {
    lifeStoryLines = Color.fromRGBO(0, 255, 0, 1);
    familyTreeLines = Color.fromRGBO(0, 0, 255, 1);
    spouseLines = Color.fromRGBO(255, 0, 0, 1);

    baptismEvent = hslToColor(BitmapDescriptor.hueCyan, 1, 0.5);
    birthEvent = hslToColor(BitmapDescriptor.hueOrange, 1, 0.5);
    censusEvent = hslToColor(BitmapDescriptor.hueRose, 1, 0.5);
    christeningEvent = hslToColor(BitmapDescriptor.hueYellow, 1, 0.5);
    marriageEvent = hslToColor(BitmapDescriptor.hueAzure, 1, 0.5);
    travelEvent =  hslToColor(BitmapDescriptor.hueMagenta, 1, 0.5);
    deathEvent =hslToColor(BitmapDescriptor.hueViolet, 1, 0.5);

    lifeStoryLinesView = true;
    familyTreeLinesView = true;
    spouseLinesView = true;
  }

  void _load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lifeStoryLinesView = preferences.getBool("lifeStoryLinesView") ?? true;
    familyTreeLinesView = preferences.getBool("familyTreeLinesView") ?? true;
    spouseLinesView = preferences.getBool("spouseLinesView") ?? true;

    lifeStoryLines = Color(preferences.getInt("lifeStoryLines") ?? Color.fromRGBO(0, 255, 0, 1).value);
    familyTreeLines = Color(preferences.getInt("familyTreeLines") ?? Color.fromRGBO(0, 0, 255, 1).value);
    spouseLines = Color(preferences.getInt("spouseLines") ?? Color.fromRGBO(255, 0, 0, 1).value);

    birthEvent = Color(preferences.getInt("birthEvent")) ?? hslToColor(BitmapDescriptor.hueBlue, 1, 0.5);
    baptismEvent = Color(preferences.getInt("baptismEvent")) ?? hslToColor(BitmapDescriptor.hueCyan, 1, 0.5);
    censusEvent = Color(preferences.getInt("censusEvent")) ?? hslToColor(BitmapDescriptor.hueRose, 1, 0.5);
    christeningEvent = Color(preferences.getInt("christeningEvent")) ?? hslToColor(BitmapDescriptor.hueYellow, 1, 0.5);
    marriageEvent = Color(preferences.getInt("marriageEvent")) ?? hslToColor(BitmapDescriptor.hueAzure, 1, 0.5);
    travelEvent = Color(preferences.getInt("travelEvent")) ?? hslToColor(BitmapDescriptor.hueMagenta, 1, 0.5);
    deathEvent = Color(preferences.getInt("deathEvent")) ?? hslToColor(BitmapDescriptor.hueViolet, 1, 0.5);

    mapType = MapType.values[preferences.getInt("mapType") ?? MapType.normal.index];
  }

  void _save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("lifeStoryLinesView", lifeStoryLinesView);
    preferences.setBool("familyTreeLinesView", familyTreeLinesView);
    preferences.setBool("spouseLinesView", spouseLinesView);

    preferences.setInt("lifeStoryLines", lifeStoryLines.value);
    preferences.setInt("familyTreeLines", familyTreeLines.value);
    preferences.setInt("spouseLines", spouseLines.value);

    preferences.setInt("baptismEvent", baptismEvent.value);
    preferences.setInt("birthEvent", birthEvent.value);
    preferences.setInt("censusEvent", censusEvent.value);
    preferences.setInt("christeningEvent", christeningEvent.value);
    preferences.setInt("marriageEvent", marriageEvent.value);
    preferences.setInt("travelEvent", travelEvent.value);
    preferences.setInt("deathEvent", deathEvent.value);
    preferences.setInt("mapType", mapType.index);
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                settings.setDefault();
              });
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          _sectionTitle("Line colors"),
          _lifeStoryTile(),
          _familyTreeLinesTile(),
          _spouseLinesTile(),
          _sectionTitle("Event colors"),
          _baptismEventTile(),
          _birthEventTile(),
          _censusEventTile(),
          _christeningEventTile(),
          _travelEventTile(),
          _marriageEventTile(),
          _deathEventTile(),
          _sectionTitle("Map"),
          _mapTypeTile(),
          _syncDataTile(),
          _logout(),
        ],
      ),
    );
  }

  Widget _syncDataTile() {
    return ListTile(
      title: Text("Sync Data"),
      onTap: () {
        DataCache.getInstance().load();
      },
    );
  }

  Widget _lifeStoryTile() {
    return _settingTileSwitch(
      title: "Life Story Line Color",
      color: settings.lifeStoryLines,
      colorChanged: (color) {
        setState(() {
          settings.lifeStoryLines = color;
        });
      },
      initialState: settings.lifeStoryLinesView,
      switchValueChange: (value) {
        setState(() {
          settings.lifeStoryLinesView = value;
        });
      },
    );
  }

  Widget _familyTreeLinesTile() {
    return _settingTileSwitch(
      title: "Family Tree Line Color",
      color: settings.familyTreeLines,
      colorChanged: (color) {
        setState(() {
          settings.familyTreeLines = color;
        });
      },
      initialState: settings.familyTreeLinesView,
      switchValueChange: (value) {
        setState(() {
          settings.familyTreeLinesView = value;
        });
      },
    );
  }

  Widget _spouseLinesTile() {
    return _settingTileSwitch(
      title: "Spouse Line Color",
      color: settings.spouseLines,
      colorChanged: (color) {
        setState(() {
          settings.spouseLines = color;
        });
      },
      initialState: settings.spouseLinesView,
      switchValueChange: (value) {
        setState(() {
          settings.spouseLinesView = value;
        });
      },
    );
  }

  Widget _baptismEventTile() {
    return _settingTile(
      title: "Baptism Event Color",
      color: settings.baptismEvent,
      colorChanged: (color) {
        setState(() {
          settings.baptismEvent = color;
        });
      },
    );
  }

  Widget _birthEventTile() {
    return _settingTile(
      title: "Birth Event Color",
      color: settings.birthEvent,
      colorChanged: (color) {
        setState(() {
          settings.birthEvent = color;
        });
      },
    );
  }

  Widget _censusEventTile() {
    return _settingTile(
      title: "Census Event Color",
      color: settings.censusEvent,
      colorChanged: (color) {
        setState(() {
          settings.censusEvent = color;
        });
      },
    );
  }

  Widget _christeningEventTile() {
    return _settingTile(
      title: "Christening Event Color",
      color: settings.christeningEvent,
      colorChanged: (color) {
        setState(() {
          settings.christeningEvent = color;
        });
      },
    );
  }

  Widget _deathEventTile() {
    return _settingTile(
      title: "Death Event Color",
      color: settings.deathEvent,
      colorChanged: (color) {
        setState(() {
          settings.deathEvent = color;
        });
      },
    );
  }

  Widget _marriageEventTile() {
    return _settingTile(
      title: "Marriage Event Color",
      color: settings.marriageEvent,
      colorChanged: (color) {
        setState(() {
          settings.marriageEvent = color;
        });
      },
    );
  }

  Widget _travelEventTile() {
    return _settingTile(
      title: "Travel Event Color",
      color: settings.travelEvent,
      colorChanged: (color) {
        setState(() {
          settings.travelEvent = color;
        });
      },
    );
  }

  void _showColorPicker(Color color, ValueChanged<Color> colorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: colorChanged,
              enableLabel: true,
              enableAlpha: false,
            ),
          ),
        );
      },
    );
  }

  Widget _settingTileSwitch({String title, Color color, ValueChanged<Color> colorChanged, bool initialState, ValueChanged<bool> switchValueChange}) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.subhead,),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _colorRect(color, colorChanged),
          Switch(
              value: initialState,
              onChanged: switchValueChange
          )
        ],
      ),
    );
  }

  Widget _settingTile({String title, Color color, ValueChanged<Color> colorChanged}) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.subhead),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _colorRect(color, colorChanged)
        ],
      ),
    );
  }

  Widget _colorRect(Color color, ValueChanged<Color> colorChanged) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
            right: 16
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
          ),
        ),
      ),
      onTap: () {
        _showColorPicker(color, colorChanged);
      },
    );
  }

  Widget settingTile() {
    return null;
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: Theme.of(context).textTheme.display1,),
    );
  }

  Widget _toggleButton(String title, MapType type) {
    return Expanded(
      child: FlatButton(
        child: Text(title),
        color: settings.mapType == type ? Theme.of(context).accentColor : Colors.transparent,
        onPressed: () {
          setState(() {
            settings.mapType = type;
          });
        },
      ),
    );
  }

  Widget _mapTypeTile() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _toggleButton("Normal", MapType.normal),
        _toggleButton("Satellite", MapType.satellite),
        _toggleButton("Terrian", MapType.terrain),
        _toggleButton("Hybrid", MapType.hybrid),
      ],
    );
  }

}
