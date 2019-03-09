import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sign_in.dart';
import 'register.dart';
import 'animations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Family Map'),
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

  _showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }
}