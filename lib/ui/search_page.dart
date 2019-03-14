import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _searchBar = TextEditingController();

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
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              autocorrect: true,
              controller: _searchBar,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70,),
                suffixIcon: _searchBar.text.isNotEmpty ? GestureDetector(child: Icon(Icons.clear, color: Colors.white70,), onTap: () => _searchBar.clear(),) : SizedBox()
              ),
              autofocus: true,
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}