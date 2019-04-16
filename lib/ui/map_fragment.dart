import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:fms_client/ui/filter_activity.dart';
import 'package:fms_client/ui/person_activity.dart';
import 'package:fms_client/ui/settings_activity.dart';
import 'package:fms_client/redux/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFragment extends StatefulWidget {
  final ValueChanged<MapFragmentController> onFragmentCreated;
  final Event event;
  final bool shouldFilter;

  MapFragment({this.onFragmentCreated, this.event, this.shouldFilter = true, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapFragmentState(onFragmentCreated, shouldFilter);
}

class MapFragmentState extends State<MapFragment> {
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

  final bool shouldFilter;

  static final CameraPosition _centerCam = CameraPosition(target: center);
  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  ValueChanged<MapFragmentController> onFragmentCreated;

  MapFragmentState(this.onFragmentCreated, this.shouldFilter);

  @override
  void initState() {
    settings = Settings.getInstance();
    filterSettings = Filter.getInstance();
    dataCache = DataCache.getInstance();
    type = settings.mapType;
    _selectedEvent = widget.event;
    super.initState();
    onFragmentCreated(MapFragmentController(_triggerMarkerUpload, _reset, _updatemapType));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: type,
          initialCameraPosition: _centerCam,
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
    );
  }

  void _reset() {
    setState(() {
      _selectedPerson = null;
      _selectedEvent = null;
      _selectedMarker = null;
    });
  }

  void _updatemapType() {
    setState(() {
      type = settings.mapType;
    });
  }

  Widget _bottomSheet() {
    return GestureDetector(
      onTap: _selectedPerson == null ? null : () {
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => PersonActivity(person: dataCache.familyTree[_selectedPerson.personID],)
        ));
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                _getIcon(),
                Expanded(
                  child: _info(),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, .9),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              )),
        ),
      ),
    );
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

  void _selectMarker(Marker marker) {
    setState(() {
      _selectedMarker = marker;
      _selectedEvent = eventMarkers[marker];
      _selectedPerson = dataCache.getPersonData(_selectedEvent.personID);
    });
    _processPolyLines();
  }

  void _selectEvent(Event event) {
    setState(() {
      _selectedEvent = event;
      _selectedPerson = dataCache.getPersonData(_selectedEvent.personID);
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(event.latitude, event.longitude), zoom: 14)
      ));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    this._controller = controller;
    this._controller.onMarkerTapped.add(_selectMarker);
    _triggerMarkerUpload();
    if (widget.event != null) {
      _selectEvent(widget.event);
    }
    _controller.onMapTapped.add((latlng) {
      _controller.clearPolylines();
      _reset();
    });
  }

  void _triggerMarkerUpload() {
    if (!dataCache.loading && _controller != null) {
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
    _processPolyLines();
  }

  _addEventMarker(Event event) async {
    Marker marker = await _controller.addMarker(MarkerOptions(
      position: LatLng(event.latitude, event.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          hueFromEventType(settings, event.eventType)),
      visible: shouldFilter ? dataCache.shouldDisplayEventMarker(event) : true,
    ));
    eventMarkers[marker] = event;
  }

  void _processPolyLines() {
    if (_controller != null)
      _controller.clearPolylines();
    if (_selectedEvent != null) {
      if (settings.spouseLinesView) {
        Event spouseBirthEvent = dataCache.getSpouseEvent(_selectedEvent);
        if (spouseBirthEvent != null)
          _addPloyLine(_selectedEvent, spouseBirthEvent, settings.spouseLines);
      }
      if (settings.lifeStoryLinesView) {
        List<Event> lifeStory = dataCache.getLifeStoryEvents(_selectedEvent);
        Event previous;
        lifeStory.forEach((item) {
          if (previous != null)
            _addPloyLine(previous, item, settings.lifeStoryLines);
          previous = item;
        });
      }
      if (settings.familyTreeLinesView) {
        addParentLinesR(dataCache.getPersonComplexData(_selectedEvent.personID), 30, event: _selectedEvent);
      }
    }
  }

  void _addPloyLine(Event eventA, Event eventB, Color color) {
    _addPolyLine(eventA, eventB, color, 10);
  }

  void _addPolyLine(Event eventA, Event eventB, Color color, double lineWidth) {
    if (eventA != null && eventB != null) {
      final List<LatLng> points = <LatLng>[
        LatLng(eventA.latitude, eventA.longitude),
        LatLng(eventB.latitude, eventB.longitude),
      ];
      _controller.addPolyline(PolylineOptions(
          points: points, color: color.value, visible: true, width: lineWidth
      ));
    }
  }

  void addParentLinesR(PersonComplex person, double lineWidth, {Event event}) {
    if (person == null)
      return;

    if (lineWidth < 0)
      lineWidth = 1;

    PersonComplex temp = dataCache.getPersonComplexData(person.person.personID);
    if (temp == null)
      return;
    PersonComplex father = temp.father;

    temp = dataCache.getPersonComplexData(person.person.personID);
    if (temp == null)
      return;
    PersonComplex mother = temp.mother;

    Event fatherEvent = dataCache.getEarliestEvent(father);
    Event motherEvent = dataCache.getEarliestEvent(mother);
    Event self;
    if (event != null)
      self = event;
    else
      self = dataCache.getEarliestEvent(person);

    _addPolyLine(fatherEvent, self, settings.familyTreeLines, lineWidth);
    _addPolyLine(motherEvent, self, settings.familyTreeLines, lineWidth);

    if (mother != null)
      addParentLinesR(mother, lineWidth - 10);
    if (father != null)
      addParentLinesR(father, lineWidth - 10);

    return;
  }
}

class MapFragmentController {
  VoidCallback _triggerMarkerUpload;
  VoidCallback _reset;
  VoidCallback _updateType;

  MapFragmentController(this._triggerMarkerUpload, this._reset, this._updateType);

  void triggerMarkerUpload() {
    _triggerMarkerUpload();
  }

  void triggerReset() {
    _reset();
  }

  void updateMapType() {
    _updateType();
  }
}