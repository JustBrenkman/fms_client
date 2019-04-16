import 'package:flutter/material.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:fms_client/redux/ui_custom.dart';
import 'person_activity.dart';

class SearchActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchActivityState();
}

class SearchActivityState extends State<SearchActivity> {
  TextEditingController _searchBar = TextEditingController();
  List<Event> events = List();
  List<PersonComplex> persons = List();

  void _search(String keyword) async {
    setState(() {
      events = DataCache.getInstance().searchEvents(keyword);
      persons = DataCache.getInstance().searchFamily(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              onChanged: (keyword) {
                _search(keyword);
              },
              autocorrect: true,
              controller: _searchBar,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),
                  suffixIcon: _searchBar.text.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.clear,
                            color: Colors.white70,
                          ),
                          onTap: () => _searchBar.clear(),
                        )
                      : SizedBox()),
              autofocus: true,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          persons.map((person) {
            return PersonList(
              person: person,
            );
          }).toList(),
          events.map((event) {
            return EventList(
              event: event,
              person: DataCache.getInstance().familyTree[event.personID],
            );
          }).toList()
        ].expand((x) => x).toList(),
      ),
    );
  }
}
