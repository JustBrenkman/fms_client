import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FilterActivityState();
}

class FilterActivityState extends State<FilterActivity> {
  Filter filter;

  _setup() async {
    filter = Filter.getInstance();
    setState(() {
      filter = filter;
    });
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  void dispose() {
    filter.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
      ),
      body: ListView(
        children: <Widget>[
          _baptismTile(),
          _birthTile(),
          _censusTile(),
          _christeningTile(),
          _deathTile(),
          _marriageTile(),
          _travelTile(),
          _fatherTile(),
          _motherTile(),
          _maleTile(),
          _femaleTile()
        ],
      ),
    );
  }

  Widget _baptismTile() {
    return ListTile(
      title: Text("Baptism Events"),
      trailing: Switch(value: filter.baptismEvents, onChanged: (value) {setState(() {
        filter.baptismEvents = value;
      });}),
    );
  }

  Widget _birthTile() {
    return ListTile(
      title: Text("Birth Events"),
      trailing: Switch(value: filter.birthEvents, onChanged: (value) {setState(() {
        filter.birthEvents = value;
      });}),
    );
  }

  Widget _censusTile() {
    return ListTile(
      title: Text("Census Events"),
      trailing: Switch(value: filter.censusEvents, onChanged: (value) {setState(() {
        filter.censusEvents = value;
      });}),
    );
  }
  Widget _christeningTile() {
    return ListTile(
      title: Text("Christening Events"),
      trailing: Switch(value: filter.christeningEvents, onChanged: (value) {setState(() {
        filter.christeningEvents = value;
      });}),
    );
  }
  Widget _deathTile() {
    return ListTile(
      title: Text("Death Events"),
      trailing: Switch(value: filter.deathEvents, onChanged: (value) {setState(() {
        filter.deathEvents = value;
      });}),
    );
  }
  Widget _marriageTile() {
    return ListTile(
      title: Text("Marriage Events"),
      trailing: Switch(value: filter.marriageEvents, onChanged: (value) {setState(() {
        filter.marriageEvents = value;
      });}),
    );
  }
  Widget _fatherTile() {
    return ListTile(
      title: Text("Father Events"),
      trailing: Switch(value: filter.fathersEvents, onChanged: (value) {setState(() {
        filter.fathersEvents = value;
      });}),
    );
  }
  Widget _motherTile() {
    return ListTile(
      title: Text("Mother Events"),
      trailing: Switch(value: filter.mothersEvents, onChanged: (value) {setState(() {
        filter.mothersEvents = value;
      });}),
    );
  }
  Widget _maleTile() {
    return ListTile(
      title: Text("Male Events"),
      trailing: Switch(value: filter.maleEvents, onChanged: (value) {setState(() {
        filter.maleEvents = value;
      });}),
    );
  }
  Widget _femaleTile() {
    return ListTile(
      title: Text("Female Events"),
      trailing: Switch(value: filter.femaleEvents, onChanged: (value) {setState(() {
        filter.femaleEvents = value;
      });}),
    );
  }

  Widget _travelTile() {
    return ListTile(
      title: Text("Travel Events"),
      trailing: Switch(value: filter.travelEvents, onChanged: (value) {setState(() {
        filter.travelEvents = value;
      });}),
    );
  }
}