import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'fms_requests.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}


enum Gender {male, female}

class RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  final _serverHost = TextEditingController();
  final _serverPort = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();

  FocusNode _serverHostFN;
  FocusNode _serverPortFN;
  FocusNode _usernameFN;
  FocusNode _passwordFN;
  FocusNode _firstNameFN;
  FocusNode _lastNameFN;
  FocusNode _emailFN;

  Gender _gender = Gender.male;


  @override
  void initState() {
    _serverHostFN = FocusNode();
    _serverPortFN = FocusNode();
    _usernameFN = FocusNode();
    _passwordFN = FocusNode();
    _firstNameFN = FocusNode();
    _lastNameFN = FocusNode();
    _emailFN = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _serverHostFN.dispose();
    _serverPortFN.dispose();
    _usernameFN.dispose();
    _passwordFN.dispose();
    _firstNameFN.dispose();
    _lastNameFN.dispose();
    _emailFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            children: <Widget>[
              _title(),
              _serverInformation(),
              _serverHostField(),
              _serverPortField(),
              _personalInformation(),
              _usernameField(),
              _passwordField(),
              _firstNameField(),
              _lastNameField(),
              _emailField(),
              _genderField(),
              _registerButton(),
              _backButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: 16
        ),
        child: Text(
          "Register",
          style: TextStyle(fontSize: 48, color: Colors.blueGrey),
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
        onFieldSubmitted: (focus) => FocusScope.of(context).requestFocus(_serverPortFN),
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
        onFieldSubmitted: (focus) => FocusScope.of(context).requestFocus(_usernameFN),
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
            hintText: "Username"
        ),
        validator: (value) {
          if (value.isEmpty)
            return 'Not good';
        },
        onFieldSubmitted: (focus) => FocusScope.of(context).requestFocus(_passwordFN),
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
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty)
            return "Please enter a password";
          if (value.length < 8)
            return "Password must be 8 or more characters";
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "Password"
        ),
        onFieldSubmitted: (focus) => FocusScope.of(context).requestFocus(_firstNameFN),
      ),
    );
  }

  Widget _firstNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _firstName,
        focusNode: _firstNameFN,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty)
            return "Please enter your first name";
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "First Name"
        ),
        onFieldSubmitted: (focus) => FocusScope.of(context).requestFocus(_lastNameFN),
      ),
    );
  }

  Widget _lastNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _lastName,
        focusNode: _lastNameFN,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "Last Name"
        ),
        validator: (value) {
          if (value.isEmpty)
            return "Please enter your last name";
        },
        onFieldSubmitted: (focus) => FocusScope.of(context).requestFocus(_emailFN),
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _email,
        focusNode: _emailFN,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "Email"
        ),
        validator: (value) {
          if (value.isEmpty)
            return "Please enter your email";

        },
      ),
    );
  }

  Widget _genderField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
          value: Gender.male,
          groupValue: _gender,
        ),
        Text("Male"),
        Radio(
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
          value: Gender.female,
          groupValue: _gender,
        ),
        Text("Female"),
      ],
    );
  }

  Widget _registerButton() {
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
                Fluttertoast.showToast(msg: "Registering");
                _register();
              } else {
                Fluttertoast.showToast(msg: "Unable to register. Please check to make sure information is correct.");
              }
            },
            child: Text("Register", style: TextStyle(color: Colors.white),),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
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

  bool isEmail(String value) {
    RegExp regExp = RegExp("^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*");
    return regExp.hasMatch(value);
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  bool isNotHost(String value) {
    RegExp regExp = RegExp("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)", multiLine: false);
    return regExp.hasMatch(value);
  }

  _register() {
    RegisterRequest registerRequest = RegisterRequest(
        username: _username.text,
        password: _password.text,
        email: _email.text,
        firstName: _firstName.text,
        lastName: _lastName.text,
        gender: (_gender == Gender.male) ? "m" : "f"
    );
    print(registerRequest);
    http.post("http://" + _serverHost.text + ":" + _serverPort.text + "/user/register", body: registerRequest.toJson().toString()).then(
            (result) {
              LoginResponse response = LoginResponse.fromJson(jsonDecode(result.body));
              if (response.success)
                Fluttertoast.showToast(msg: "Successfully registered you :)");
              else {
                Fluttertoast.showToast(msg: response.message);
              }
            }
    );
  }
}