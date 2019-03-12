import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  Map<String, Marker> markers = <String, Marker>{};
  String selectedMarker;
  int _markerIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    this._controller = controller;
    _addMarker();
    _addPolyLine();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.257212, -111.667706),
    zoom: 14.4746,
  );

  static final CameraPosition _provo = CameraPosition(
      target: LatLng(40.257212, -111.667706),
      zoom: 19.151926040649414);

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Family Map"), actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {
          Navigator.pushNamed(context, "/search");
        }),
        IconButton(icon: Icon(Icons.filter_list), onPressed: () {
          Navigator.pushNamed(context, "/filter");
        }),
        IconButton(icon: Icon(Icons.settings), onPressed: () {
          Navigator.pushNamed(context, "/settings");
        }),
      ],),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
//            markers: Set<Marker>.of(markers.values),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: Icon(Icons.layers, color: Colors.blue,),
                  onPressed: () {_viewCurrentLocation();},
                  backgroundColor: Color.fromRGBO(255, 255, 255, .9),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.android, size: 100, color: Colors.green,),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Click on a marker to see event details", style: Theme.of(context).textTheme.title,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, .9),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    )
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _addMarker() {
    final int markerCount = markers.length;
    final String markerVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;

    _controller.addMarker(MarkerOptions(
      position: LatLng(40.257212, -111.667706),
      infoWindowText: InfoWindowText(markerVal, '*'),
    ));
  }
  _addPolyLine() {
    final List<LatLng> points = <LatLng>[
      LatLng(40.257212, -111.667706),
      LatLng(41.257212, -110.667706),
//      LatLng(42.257212, -112.667706),
//      LatLng(40.257212, -110.667706),
    ];
    _controller.addPolyline(PolylineOptions(
        points: points, color: Colors.blue.value, visible: true, width: 10
    ));
  }


  _viewCurrentLocation() async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(_provo));
  }
}