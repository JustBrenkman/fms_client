import 'package:fms_client/ui/filter_page.dart';
import 'package:flutter/material.dart';

import 'fms_models.dart';
import 'server.dart';

class DataCache {
  List<Event> events;
  List<Person> people;
  Map<String, Person> peopleMap = new Map();
  Filter filter;
  bool loading = false;
  VoidCallback onStartSync;
  VoidCallback onFinishedSync;
  VoidCallback onSyncChange;

  static DataCache _instance;

  DataCache() {
    filter = Filter.getInstance();
  }

  static DataCache getInstance() {
    if (_instance == null)
      _instance = DataCache();

    return _instance;
  }

  void setOnStartSync(VoidCallback onStartSync) {
    this.onStartSync = onStartSync;
  }

  void setOnFinishedSync(VoidCallback callback) {
    onFinishedSync = callback;
  }

  void setOnSyncChange(VoidCallback onChange) {
    onSyncChange = onChange;
  }

  void load() async {
    loading = true;
    if (onStartSync != null)
      onStartSync();

    ServerProxy server = await ServerProxy.getInstance();
    var result = await server.sendGetAuth("/event");
    EventsResponse response = EventsResponse.fromJson(result);
    if (response.success)
      events = response.data;
    result = await server.sendGetAuth("/person");
    PersonsResponse personsResponse = PersonsResponse.fromJson(result);
    if (personsResponse.success)
      people = personsResponse.data;

    people.forEach((person) => peopleMap[person.id] = person);
    loading = false;

    if (onFinishedSync != null)
      onFinishedSync();
  }

  Person getPersonData(String id) {
    return peopleMap.containsKey(id) ? peopleMap[id] : null;
  }

  List<Event> getEvents() {
    return events ?? null;
  }

  bool shouldDisplayEventMarker(Event event) {
    Person person = getPersonData(event.personId);

    bool birth = (event.eventType == "birth" && filter.birthEvents);
    bool baptism = (event.eventType == "baptism" && filter.baptismEvents);
    bool census = (event.eventType == "census" && filter.censusEvents);
    bool christening = (event.eventType == "christening" && filter.christeningEvents);
    bool death = (event.eventType == "death" && filter.deathEvents);
    bool marriage = (event.eventType == "marriage" && filter.marriageEvents);
    bool travel = (event.eventType == "travel" && filter.travelEvents);
    bool male = (person.gender == 'm' && filter.maleEvents);
    bool female = (person.gender == 'f' && filter.femaleEvents);

    return birth || baptism || census || christening || death || marriage || travel || male || female;
    ;
  }

}