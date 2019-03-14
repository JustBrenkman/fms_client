import 'package:flutter/material.dart';
import 'package:fms_client/app_data.dart';
import 'package:fms_client/fms_models.dart';
import 'package:fms_client/ui/filter_page.dart';
import 'package:fms_client/ui/settings_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fms_client/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  Map<String, Marker> markers = <String, Marker>{};
  String selectedMarker;
  int _markerIdCounter = 1;
  DataCache dataCache;
  Marker _selectedMarker;
  Person _selectedPerson;
  Event _selectedEvent;
  Map<Marker, Event> eventMarkers = new Map();
  Settings settings;
  Filter filterSettings;
  MapType type;
  bool dataCacheSync = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.257212, -111.667706),
    zoom: 14.4746,
  );

  static final CameraPosition _provo = CameraPosition(
      target: LatLng(40.257212, -111.667706), zoom: 19.151926040649414);

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

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
                _triggerMarkerUpload();
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: dataCacheSync ? null : () async {
                await Navigator.pushNamed(context, "/settings");
                setState(() {
                  type = settings.mapType;
                });
                _triggerMarkerUpload();
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: type,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _bottomSheet(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    settings = Settings.getInstance();
    filterSettings = Filter.getInstance();
    dataCache = DataCache.getInstance();
    type = settings.mapType;
    dataCache.setOnStartSync(() {
      _selectedPerson = null;
      _selectedEvent = null;
      _selectedMarker = null;
      setState(() {
        dataCacheSync = true;
      });
    });
    dataCache.setOnFinishedSync(() {
      _triggerMarkerUpload();
      setState(() {
        dataCacheSync = false;
      });
    });
    dataCache.load();
    super.initState();
  }

  void _selectMarker(Marker marker) {
    setState(() {
      _selectedMarker = marker;
      _selectedEvent = eventMarkers[marker];
      _selectedPerson = dataCache.getPersonData(_selectedEvent.personId);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    this._controller = controller;
    this._controller.onMarkerTapped.add(_selectMarker);
    _addMarkerHouse();
    _addPolyLine();
  }

  void _clearMarkers() {
    if (_controller != null) this._controller.clearMarkers();
  }

  void _clearAllPolyLines() {
    if (this._controller != null) this._controller.clearPolylines();
  }

  _addMarkerHouse() {
    final String markerVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;

    _controller.addMarker(MarkerOptions(
        position: LatLng(40.257212, -111.667706),
        infoWindowText: InfoWindowText(markerVal, '*'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
  }

  Widget _getIcon() {
    return dataCacheSync ? CircularProgressIndicator() : Icon(
      _selectedPerson == null
          ? Icons.person
          : _selectedPerson.gender == 'm'
              ? FontAwesomeIcons.male
              : FontAwesomeIcons.female,
      size: 100,
      color: _selectedPerson == null
          ? Colors.green
          : _selectedPerson.gender == 'm'
              ? Colors.lightBlueAccent
              : Colors.pinkAccent,
    );
  }

  Widget _bottomSheet() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                _getIcon(),
                Expanded(
                  child: _info(),
                )
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, .9),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            )),
      ),
    );
  }

  _addEventMarker(Event event) async {
    _markerIdCounter++;

    Marker marker = await _controller.addMarker(MarkerOptions(
      position: LatLng(event.latitude, event.longitude),
//        infoWindowText: InfoWindowText(event.eventType, event.id),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          _hueFromEventType(event.eventType)),
      visible: dataCache.shouldDisplayEventMarker(event),
    ));

    eventMarkers[marker] = event;
  }

  _addPolyLine() {
    final List<LatLng> points = <LatLng>[
      LatLng(40.257212, -111.667706),
      LatLng(41.257212, -110.667706),
//      LatLng(42.257212, -112.667706),
//      LatLng(40.257212, -110.667706),
    ];
    _controller.addPolyline(PolylineOptions(
        points: points, color: Colors.blue.value, visible: true, width: 10));
  }

  _viewCurrentLocation() async {
//    _controller.animateCamera(CameraUpdate.newCameraPosition(_provo));
  }

  void _triggerMarkerUpload() {
    if (!dataCache.loading) {
      _controller.clearMarkers();
      if (_controller != null && dataCache.getEvents() != null) {
        dataCache.getEvents().forEach((event) {
          print("Position: " +
              event.latitude.toString() +
              ", " +
              event.longitude.toString());
          _addEventMarker(event);
        });
      }
    }
  }

  double _hueFromEventType(String eventType) {
    double hue;

    switch (eventType) {
      case 'baptism':
        hue = colorToHue(settings.baptismEvent);
        break;
      case 'birth':
        hue = colorToHue(settings.birthEvent);
        break;
      case 'marriage':
        hue = colorToHue(settings.marriageEvent);
        break;
      case 'death':
        hue = colorToHue(settings.deathEvent);
        break;
      case 'travel':
        hue = colorToHue(settings.travelEvent);
        break;
      case 'census':
        hue = colorToHue(settings.censusEvent);
        break;
      default:
        hue = colorToHue(settings.deathEvent);
        break;
    }

    return hue;
  }

  Widget _info() {
    return dataCacheSync ? Center(
      child: Text("Loading data", style: Theme.of(context).textTheme.display1,),
    ):
    Column(
      children: <Widget>[
        _selectedPerson == null
            ? Text(
                "Click on a marker to see event details",
                style: Theme.of(context).textTheme.title,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _selectedPerson.firstName +
                        " " +
                        _selectedPerson.lastName,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    _selectedEvent.eventType +
                        ": " +
                        _selectedEvent.city +
                        ", " +
                        _selectedEvent.country +
                        " (" +
                        _selectedEvent.year.toString() +
                        ")",
                    style: Theme.of(context).textTheme.subhead,
                  )
                ],
              )
      ],
    );
  }
}
