import 'package:flutter/material.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'map_fragment.dart';

class EventActivity extends StatefulWidget {
  final Event event;

  EventActivity({this.event, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventActivityState();
}

class EventActivityState extends State<EventActivity> {
  MapFragmentController _mapFragmentController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Family map"),
        ),
        body: MapFragment(shouldFilter: false, onFragmentCreated: _onMapFragmentCreated, event: widget.event,),
      ),
    );
  }

  void _onMapFragmentCreated(MapFragmentController fragmentController) {
    _mapFragmentController = fragmentController;
  }

  Future<bool> _backPressed() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    return false;
  }
}