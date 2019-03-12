import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fms_client/ui/filter.dart';
import 'package:fms_client/ui/map.dart';
import 'package:fms_client/ui/search.dart';
import 'package:fms_client/ui/settings.dart';
import 'package:fms_client/ui/sign_in.dart';
import 'package:fms_client/ui/register.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MyHomePage(title: "Family Map",),
        "/mymap": (context) => MapPage(),
        "/settings": (context) => SettingPage(),
        "/search": (context) => SearchPage(),
        "/filter": (context) => FilterPage(),
      },
      title: 'My Family Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

/// This is the homepage widget
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// This is the state for the homepage
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _greeting(),
            _buttons(),
          ],
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }

  Widget _signInButton() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Sign in".toUpperCase(), style: TextStyle(fontSize: 16, color: Colors.blueGrey),),
          ),
          onPressed: () => {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => SignInPage()))
          },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      color: Colors.white,
    ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Register".toUpperCase(), style: TextStyle(fontSize: 16, color: Colors.blueGrey),),
          ),
          onPressed: () => {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => RegisterPage()))
          },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      color: Colors.white,
    ),
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          _signInButton(),
          _registerButton()
        ],
      ),
    );
  }

  Widget _greeting() {
    return Column(
      children: <Widget>[
        Text("Welcome", style: TextStyle(fontSize: 64, color: Colors.white),),
        Text("to your", style: TextStyle(fontSize: 28, color: Colors.white),),
        Text("Family Map", style: TextStyle(fontSize: 48, color: Colors.white),),
      ],
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }
}