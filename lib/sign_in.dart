import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'fms_requests.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverHost = TextEditingController();
  final _serverPort = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  FocusNode _serverHostFN;
  FocusNode _serverPortFN;
  FocusNode _usernameFN;
  FocusNode _passwordFN;

  @override
  void initState() {
    _serverHostFN = FocusNode();
    _serverPortFN = FocusNode();
    _usernameFN = FocusNode();
    _passwordFN = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _serverHostFN.dispose();
    _serverPortFN.dispose();
    _usernameFN.dispose();
    _passwordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      appBar: AppBar(title: Text("Sign In"),),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _title(),
              _serverInformation(),
              _serverHostField(),
              _serverPortField(),
              _personalInformation(),
              _usernameField(),
              _passwordField(),
              _signinButton(),
              _backButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: SizedBox(
          height: 40,
          child: OutlineButton(
            color: Colors.transparent,
            borderSide: BorderSide(color: Colors.red),
            highlightedBorderColor: Colors.red,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.red),),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 64, bottom: 16),
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 48, color: Colors.blueGrey),
        ),
      ),
    );
  }

  Widget _serverHostField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _serverHost,
        textInputAction: TextInputAction.next,
        focusNode: _serverHostFN,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty || !isNotHost(value))
            return 'Please fill in server host eg 192.168.0.1';
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: "Server Host"),
        onFieldSubmitted: (focus) =>
            FocusScope.of(context).requestFocus(_serverPortFN),
      ),
    );
  }

  Widget _serverPortField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _serverPort,
        focusNode: _serverPortFN,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty || !isNumeric(value))
            return 'Please fill in server host';
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: "Server Port"),
        onFieldSubmitted: (focus) =>
            FocusScope.of(context).requestFocus(_usernameFN),
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: _username,
        focusNode: _usernameFN,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "Username"),
        validator: (value) {
          if (value.isEmpty) return 'Not good';
        },
        onFieldSubmitted: (focus) =>
            FocusScope.of(context).requestFocus(_passwordFN),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _password,
        focusNode: _passwordFN,
        obscureText: true,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value.isEmpty) return "Please enter a password";
          if (value.length < 8) return "Password must be 8 or more characters";
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "Password"),
      ),
    );
  }

  Widget _personalInformation() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Personal information",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget _serverInformation() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Server information",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget _signinButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: SizedBox(
          height: 40,
          child: RaisedButton(
            color: Colors.blue,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Fluttertoast.showToast(msg: 'Signing in');
                _login();
              } else {
                Fluttertoast.showToast(
                    msg:
                        "Unable to sign in. Please check to make sure information is correct.");
              }
            },
            child: Text(
              "Sign In",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  bool isNotHost(String value) {
    RegExp regExp = RegExp(
        "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
        multiLine: false);
    return regExp.hasMatch(value);
  }

  _login() {
    LoginRequest loginRequest = LoginRequest(
      username: _username.text,
      password: _password.text,
    );
    http
        .post(
            "http://" +
                _serverHost.text +
                ":" +
                _serverPort.text +
                "/user/login",
            body: loginRequest.toJson().toString())
        .then((result) {
      LoginResponse response = LoginResponse.fromJson(jsonDecode(result.body));
      if (response.success)
        Fluttertoast.showToast(msg: "Successfully loggef you in :)");
      else {
        Fluttertoast.showToast(msg: response.message);
      }
    });
  }
}
