import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fms_client/redux/utils.dart';

class SettingActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingActivityState();
}

class SettingActivityState extends State<SettingActivity> with SingleTickerProviderStateMixin {
  String dropDown = 'Red';
  String userName = "";
  Settings settings;
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _setup();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller)
    ..addListener(() {
      setState(() {

      });
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed && DataCache.getInstance().loading) {
        controller.reset();
        controller.forward();
      }
    });
  }


  @override
  void dispose() {
    settings.save();
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
        DataCache.getInstance().setTempFinish(() => Navigator.of(context).pop());
        DataCache.getInstance().load();
        controller.reset();
        controller.forward();
      },
      trailing: Transform.rotate(child: Icon(Icons.sync), angle: -animation.value,),
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
    userName = await getuserName();
    settings = Settings.getInstance();
    setState(() {
      userName = userName;
    });
    setState(() {
      settings = settings;
    });
  }

  Widget _logout() {
    return ListTile(
      onTap: () => Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false),
      title: Text("Logout: " + userName),
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
