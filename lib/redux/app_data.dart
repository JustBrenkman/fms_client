import 'package:fms_client/ui/filter_activity.dart';
import 'package:flutter/material.dart';

import 'fms_models.dart';
import 'server.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class DataCache {
  List<Event> events;
  List<Person> people;
  Map<String, Person> peopleMap = new Map();
  Map<String, List<Event>> personEventMap;
  Map<String, PersonComplex> familyTree = new Map();
  Filter filter;
  bool loading = false;
  VoidCallback onStartSync;
  VoidCallback onFinishedSync;
  VoidCallback onSyncChange;
  String rootId;

  static DataCache _instance;

  DataCache() {
    filter = Filter.getInstance();
    personEventMap = new Map();
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

    personEventMap.clear();
    familyTree = Map();

    events.forEach((event) {
      if (!personEventMap.containsKey(event.personId))
        personEventMap[event.personId] = new List();
      personEventMap[event.personId].add(event);
    });

    _createFamilyTree();

    if (onFinishedSync != null)
      onFinishedSync();
  }

  Person getPersonData(String id) {
    return peopleMap.containsKey(id) ? peopleMap[id] : null;
  }

  List<Event> getEvents() {
    return events ?? null;
  }

  List<Event> getEventsForPerson(String id) {
    return personEventMap[id] ?? List();
  }

  void _createFamilyTree() {
    familyTree[rootId] = PersonComplex(this, peopleMap[rootId]);
    familyTree[familyTree[rootId].person.spouseID] = PersonComplex(this, peopleMap[familyTree[rootId].person.spouseID]);
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

    bool parents = isFatherSide(familyTree[event.personId]);
    bool motherrsSide = (filter.mothersEvents && !parents);
    bool fathersSide = (filter.fathersEvents && parents);

    return birth || baptism || census || christening || death || marriage || travel || male || female || motherrsSide || fathersSide;
  }

  void setPersonRootId(String personId) {
    this.rootId = personId;
  }

  Map<String, PersonComplex> getFamily(String id) {
    Map<String, PersonComplex> family = Map();
    PersonComplex personComplex = familyTree[id] ?? null;

    if (personComplex.mother != null)
      family["mother"] = personComplex.mother;
    if (personComplex.father != null)
      family["father"] = personComplex.father;
    if (personComplex.spouse != null)
      family["spouse"] = personComplex.spouse;
    if (personComplex.child != null)
      family["child"] = personComplex.child;

    return family;
  }

  List<Event> searchEvents(String keyword) {
    List<Event> eventsFound = List();
    events.forEach((event) {
      if (event.country.toLowerCase().contains(keyword.toLowerCase()) || event.city.toLowerCase().contains(keyword.toLowerCase()) ||
          event.eventType.toLowerCase().contains(keyword.toLowerCase()) ||
          event.year.toString().contains(keyword.toLowerCase()))
        eventsFound.add(event);
    });
    return eventsFound;
  }

  List<PersonComplex> searchFamily(String keyword) {
    List<PersonComplex> people = List();
    familyTree.forEach((id, person) {
      if (person.person.firstName.toLowerCase().contains(keyword.toLowerCase()) ||
      person.person.lastName.toLowerCase().contains(keyword.toLowerCase()))
        people.add(person);
    });
    return people;
  }

  bool isFatherSide(PersonComplex person) {
    PersonComplex parent = _dive(person);
    if (parent.child != null)
      return parent.child.father == parent;
    return false;
  }

  PersonComplex _dive(PersonComplex person) {
    if (person.child != null)
      if (person.child.child != null)
        return _dive(person.child);
    return person;
  }

  Event getSpouseEvent(Event selectedEvent) {
    PersonComplex person = familyTree.containsKey(selectedEvent.
personId) ? familyTree[selectedEvent.personId] : null;
    PersonComplex spouse = person.spouse;
    List<Event> events = getEventsForPerson(spouse.person.id);
    Event event;
    events.sort((a, b) => a.year.compareTo(b.year));
    for (final item in events) {
      if (shouldDisplayEventMarker(item)) {
        event = item;
        break;
      }
    }
    return event;
  }

  List<Event> getLifeStoryEvents(Event selected) {
    List<Event> list = getEventsForPerson(selected.personId);
    list.sort((a, b) => a.year.compareTo(b.year));
    list.removeWhere((event) => !shouldDisplayEventMarker(event));
    return list;
  }

  PersonComplex getPersonComplexData(String personId) {
    return familyTree.containsKey(personId) ? familyTree[personId] : null;
  }

  Event getEarliestEvent(PersonComplex person) {
    if (person == null)
      return null;
    if (person.person == null)
      return null;
    List<Event> events = getEventsForPerson(person.person.id);
    Event event;
    events.sort((a, b) => a.year.compareTo(b.year));
    for (final item in events) {
      if (shouldDisplayEventMarker(item)) {
        event = item;
        break;
      }
    }
    return event;
  }
}

class PersonComplex {
  PersonComplex child;
  PersonComplex father;
  PersonComplex mother;
  PersonComplex spouse;
  Person person;

  /// Creates a Complex person that is linked to all its descendants
  PersonComplex(DataCache dataCache, Person person) {
    if (person.fatherID != null) {
      if (!dataCache.familyTree.containsKey(person.fatherID)) {
        this.father = PersonComplex(dataCache, dataCache.getPersonData(person.fatherID));
        dataCache.familyTree[person.fatherID] = this.father;
      } else
        this.father = dataCache.familyTree[person.fatherID];

      dataCache.familyTree[person.fatherID].child = this;
    }

    if (person.motherID != null) {
      if (!dataCache.familyTree.containsKey(person.motherID)) {
        this.mother = PersonComplex(dataCache, dataCache.getPersonData(person.motherID));
        dataCache.familyTree[person.motherID] = this.mother;
      } else
        this.mother = dataCache.familyTree[person.motherID];

      dataCache.familyTree[person.motherID].child = this;
    }

    if (this.mother != null || this.father != null) {
      this.mother.spouse = this.father;
      this.father.spouse = this.mother;
    }

  this.person = person;
  }
}

class PlatformBridge {
  static const _platform = const MethodChannel("basicChannel/test");
  static const _callback_channel = const MethodChannel("fms_client/callbacks");
  static const _platform_server = const BasicMessageChannel("fms_client/serverProxy", JSONMessageCodec());
  static PlatformBridge _instance;

  static PlatformBridge get instance {
    if (_instance == null)
      _instance = PlatformBridge();

    return _instance;
  }

  static init() {
    _callback_channel.setMethodCallHandler((methodCall) async {
      String method = methodCall.method;
      switch (method) {
        case 'hello':
          return;
          break;
      }
      return;
    });
  }

  static Future<void> runTest() async {
    try {
//      final String message = await _platform.invokeMethod("getString");
//      print("Message: " + message);
      final int testInt = await _platform.invokeMethod("getInt");
      print("Int: " + testInt.toString());
//      final List<String> messages = await _platform.invokeMethod("getStringList");
    } on PlatformException catch(e) {
      print("failed");
    }
  }
}