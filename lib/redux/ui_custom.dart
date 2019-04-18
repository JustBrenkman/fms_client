import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:fms_client/activities/event_activity.dart';
import 'package:fms_client/activities/person_activity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonList extends StatelessWidget {
  const PersonList({Key key, this.type, this.person}) : super(key: key);
  final PersonComplex person;
  final String type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => PersonActivity(person: person,)));
      },
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 0,
                right: 8,
                top: 4,
                bottom: 4
            ),
            child: Icon(_getGenderIcon(person.person.gender), color: _getGenderColor(person.person.gender), size: 40,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(person.person.firstName + " " + person.person.lastName),
              Text(type == null ? "" : type)
            ],
          ),
        ],
      ),
    );
  }

  IconData _getGenderIcon(String gender) {
    return gender == 'm' ? FontAwesomeIcons.male : FontAwesomeIcons.female;
  }

  Color _getGenderColor(String gender) {
    return gender == 'm' ? Colors.lightBlueAccent : Colors.pinkAccent;
  }
}

class EventList extends StatelessWidget {
  const EventList({Key key, this.event, this.person}) : super(key: key);

  final Event event;
  final PersonComplex person;

  Widget _getPeronsDisplayInfo() {
    return person == null ? Text("") : Text(person.person.firstName + " " + person.person.lastName);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => EventActivity(event: event,)));
      },
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(event.eventType +
              ":" +
              event.country +
              ", " +
              event.city +
              " (" +
              event.year.toString() +
              ")"),
          _getPeronsDisplayInfo()
        ],
      ),
      leading: Icon(
        Icons.person_pin_circle,
        size: 32,
      ),
    );
  }
}

class HeaderWithHint extends StatelessWidget {
  HeaderWithHint({Key key, this.title, this.hint}) : super(key: key);

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title + "   ",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Text(hint)
      ],
    );
  }
}

class Descriptor extends StatelessWidget {

  const Descriptor({Key key, this.borderColor = Colors.blue, this.backgroundColor = Colors.transparent, @required this.title, @required this.description}) : super(key: key);

  final Color borderColor;
  final Color backgroundColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: backgroundColor,
            border: Border(
              top: BorderSide(color: Colors.blue),
              bottom: BorderSide(color: Colors.blue),
              left: BorderSide(color: Colors.blue),
              right: BorderSide(color: Colors.blue),
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 4,
                right: 4,
                top: 4,
//              bottom: 2
              ),
              child: Text(description),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
              ),
              child: Text(title, style: Theme.of(context).textTheme.headline,),
            ),
          ],
        ),
      ),
    );
  }
}