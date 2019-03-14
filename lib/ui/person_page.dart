import 'package:flutter/material.dart';

class PersonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PersonPageState();
}

class PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Person"),),
      body: Text("Yeah"),
    );
  }
}