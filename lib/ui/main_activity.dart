import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:fms_client/ui/filter_activity.dart';
import 'package:fms_client/ui/settings_activity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_fragment.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainActivityState();
}

class MainActivityState extends State<MainActivity> {
  Map<String, Marker> markers = <String, Marker>{};
  String selectedMarker;
  DataCache dataCache;
  Map<Marker, Event> eventMarkers = new Map();
  Settings settings;
  Filter filterSettings;
  MapType type;
  bool dataCacheSync = false;

  MapFragmentController _mapFragmentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("My Family Map"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: dataCacheSync ? null : () {
                Navigator.pushNamed(context, "/search");
              }
          ),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: dataCacheSync ? null : () async {
                await Navigator.pushNamed(context, "/filter");
                _mapFragmentController.triggerReset();
                _mapFragmentController.triggerMarkerUpload();
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: dataCacheSync ? null : () async {
                await Navigator.pushNamed(context, "/settings");
//                setState(() {
                _mapFragmentController.updateMapType();
//                });
                _mapFragmentController.triggerMarkerUpload();
              }),
        ],
      ),
      body: MapFragment(onFragmentCreated: _onMapFragmentCreated,)
    );
  }

  @override
  void initState() {
    settings = Settings.getInstance();
    filterSettings = Filter.getInstance();
    dataCache = DataCache.getInstance();
    dataCache.setOnStartSync(() {
      setState(() {
        dataCacheSync = true;
      });
      if (_mapFragmentController != null)
        _mapFragmentController.triggerReset();
    });
    dataCache.setOnFinishedSync(() {
      setState(() {
        dataCacheSync = false;
        _showToast("Finished syncing");
        if (_mapFragmentController != null)
          _mapFragmentController.triggerMarkerUpload();
      });
    });
    dataCache.load();
    super.initState();
  }

  void _onMapFragmentCreated(MapFragmentController fragmentController) {
    _mapFragmentController = fragmentController;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
