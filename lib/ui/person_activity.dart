import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/ui_custom.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonActivity extends StatefulWidget {
  final PersonComplex person;

  PersonActivity({Key key, this.person}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PersonActivityState();
}

class PersonActivityState extends State<PersonActivity> {
  bool eventExpanded = false;
  bool personExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person details"),
        backgroundColor: _getColor(),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              widget.person.person.gender == 'm' ? FontAwesomeIcons.male : FontAwesomeIcons.female,
              color: _getColor(),
              size: 100,
            ),
          ),
          Descriptor(title: widget.person.person.firstName, borderColor: _getColor(), description: "First Name",),
          Descriptor(title: widget.person.person.lastName, borderColor: _getColor(), description: "Last Name",),
          Descriptor(title: _getGender(), borderColor: _getColor(), description: "Gender",),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionPanelList(
              expansionCallback: (index, expanded) {
                setState(() {
                  print(expanded);
                  switch (index) {
                    case 0:
                      if (expanded) {
                        eventExpanded = false;
                      } else {
                        personExpanded = false;
                        eventExpanded = true;
                      }
                      break;
                    case 1:
                      if (expanded) {
                        personExpanded = false;
                      } else {
                        personExpanded = true;
                        eventExpanded = false;
                      }
                      break;
                  }
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: eventExpanded,
                  headerBuilder: (context, expanded) {
                    return HeaderWithHint(
                      title: "Events",
                      hint: DataCache.getInstance()
                              .getEventsForPerson(widget.person.person.id)
                              .length
                              .toString() +
                          " items",
                    );
                  },
                  body: Column(
                    children: DataCache.getInstance()
                        .getEventsForPerson(widget.person.person.id)
                        .map((event) {
                      return EventList(
                        event: event,
                        person: widget.person,
                      );
                    }).toList(),
                  ),
                ),
                ExpansionPanel(
                  isExpanded: personExpanded,
                    headerBuilder: (context, expanded) {
                      return HeaderWithHint(
                        title: "Family",
                        hint: DataCache.getInstance().getFamily(widget.person.person.id).length.toString() + " items",
                      );
                    },
                    body: Column(
                      children: DataCache.getInstance().getFamily(widget.person.person.id).entries.map((MapEntry<String, PersonComplex> map) {
                        return PersonList(
                          person: map.value,
                          type: map.key,
                        );
                      }).toList(),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    return (widget.person.person.gender ?? "m") == "m" ? Colors.lightBlueAccent : Colors.pinkAccent;
  }

  String _getGender() {
    return (widget.person.person.gender ?? 'm') == 'm' ? "Male" : "Female";
  }
}
