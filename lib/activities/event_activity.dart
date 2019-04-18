import 'package:flutter/material.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:fms_client/fragments/map_fragment.dart';

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
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Family map"),
        ),
        body: MapFragment(shouldFilter: true, onFragmentCreated: _onMapFragmentCreated, event: widget.event,),
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