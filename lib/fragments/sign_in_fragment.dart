import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fms_client/redux/app_data.dart';
import 'package:fms_client/redux/fms_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fms_client/redux/server.dart';

class SignInFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInFragmentState();
}

class SignInFragmentState extends State<SignInFragment> {
  final _formKey = GlobalKey<FormState>();
  final _serverHost = TextEditingController();
  final _serverPort = TextEditingController();
  final _userName = TextEditingController();
  final _password = TextEditingController();

  FocusNode _serverHostFN;
  FocusNode _serverPortFN;
  FocusNode _userNameFN;
  FocusNode _passwordFN;

  bool loading = false;
  bool canLogin = false;

  @override
  void initState() {
    _serverHostFN = FocusNode();
    _serverPortFN = FocusNode();
    _userNameFN = FocusNode();
    _passwordFN = FocusNode();

    setUp();
    super.initState();
    _disableButton();
  }

  @override
  void dispose() {
    _serverHostFN.dispose();
    _serverPortFN.dispose();
    _userNameFN.dispose();
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
          child: ListView(
            children: <Widget>[
              _title(),
              _serverInformation(),
              _serverHostField(),
              _serverPortField(),
              _personalInformation(),
              _userNameField(),
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
            onPressed: loading ? null : () {
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
        enabled: !loading,
        textInputAction: TextInputAction.next,
        focusNode: _serverHostFN,
        keyboardType: TextInputType.number,
        onEditingComplete: _disableButton,
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
        enabled: !loading,
        controller: _serverPort,
        focusNode: _serverPortFN,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        onEditingComplete: _disableButton,
        validator: (value) {
          if (value.isEmpty || !isNumeric(value))
            return 'Please fill in server host';
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: "Server Port"),
        onFieldSubmitted: (focus) =>
            FocusScope.of(context).requestFocus(_userNameFN),
      ),
    );
  }

  Widget _userNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        enabled: !loading,
        controller: _userName,
        focusNode: _userNameFN,
        onEditingComplete: _disableButton,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: "userName"),
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
        enabled: !loading,
        controller: _password,
        focusNode: _passwordFN,
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: () {
          _disableButton();
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        validator: (value) {
          if (value.isEmpty) return "Please enter a password";
//          if (value.length < 8) return "Password must be 8 or more characters";
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
            onPressed: loading || !canLogin ? null : () {
              if (_formKey.currentState.validate()) {
                Fluttertoast.showToast(msg: 'Signing in');
                _login();
              } else {
                Fluttertoast.showToast(
                    msg:
                        "Unable to sign in. Please check to make sure information is correct.");
              }
            },
            child: loading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),) : Text(
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

  _login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("server_host", _serverHost.text);
    await prefs.setString("server_port", _serverPort.text);
    await prefs.setString("userName", _userName.text);
    await prefs.setString("password", _password.text);
    setState(() {
      loading = true;
    });
    LoginRequest loginRequest = LoginRequest(
      userName: _userName.text,
      password: _password.text,
    );
    ServerProxy serverProxy = await ServerProxy.getInstance();
    serverProxy.send("/user/login", loginRequest.toJson()).then((result) {
      LoginResponse response = LoginResponse.fromJson(result);
        if (response.success) {
          Fluttertoast.showToast(msg: "Successfully logged you in :)");
          prefs.setString("auth_token", response.authToken);
          DataCache.getInstance().setPersonRootId(response.personID);
          Navigator.pushNamedAndRemoveUntil(context, "/mymap", (_) => false);
        } else
          Fluttertoast.showToast(msg: response.message);
      setState(() {
        loading = false;
      });
    });
  }

  void setUp() async {
    final prefs = await SharedPreferences.getInstance();
    _serverHost.text = prefs.getString("server_host") ?? "";
    _serverPort.text = await prefs.get("server_port") ?? "";
    _password.text = prefs.getString("password") ?? "";
    _userName.text = prefs.getString("userName") ?? "";
    _disableButton();
  }

  void _disableButton() {
    if (_userName.text.isNotEmpty && _serverHost.text.isNotEmpty && _serverPort.text.isNotEmpty && _password.text.isNotEmpty)
      setState(() {
        canLogin = true;
      });
    else
      setState(() {
        canLogin = false;
      });
  }
}
