import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:fms_client/ui/filter_activity.dart';
import 'package:fms_client/ui/settings_activity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_fragment.dart';

class MainActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainActivityState();
}

class MainActivityState extends State<MainActivity> {
  GoogleMapController _controller;
  Map<String, Marker> markers = <String, Marker>{};
  String selectedMarker;
  DataCache dataCache;
  Marker _selectedMarker;
  Person _selectedPerson;
  Event _selectedEvent;
  Map<Marker, Event> eventMarkers = new Map();
  Settings settings;
  Filter filterSettings;
  MapType type;
  bool dataCacheSync = false;

  MapFragmentController _mapFragmentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _mapFragmentController.triggerMarkerUpload();
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: dataCacheSync ? null : () async {
                await Navigator.pushNamed(context, "/settings");
                setState(() {
                  type = settings.mapType;
                });
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
      _selectedPerson = null;
      _selectedEvent = null;
      _selectedMarker = null;
      setState(() {
        dataCacheSync = true;
      });
    });
    dataCache.setOnFinishedSync(() {
      setState(() {
        dataCacheSync = false;
      });
    });
    dataCache.load();
    super.initState();
  }

  _addPolyLine() {
    final List<LatLng> points = <LatLng>[
      LatLng(40.257212, -111.667706),
      LatLng(41.257212, -110.667706),
    ];
    _controller.addPolyline(PolylineOptions(
        points: points, color: Colors.blue.value, visible: true, width: 10));
  }

  void _onMapFragmentCreated(MapFragmentController fragmentController) {
    _mapFragmentController = fragmentController;
  }
}
