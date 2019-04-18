import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }
  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

Future<String> getuserName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String jwt = preferences.getString("auth_token") ?? "";
  return parseJwt(jwt)['sub'];
}

Future<int> getExpirationDate() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String jwt = preferences.getString("auth_token") ?? "";
  return parseJwt(jwt)['exp'];
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

class ServerProxy {
  String serverHost;
  String serverPort;

  ServerProxy({this.serverHost, this.serverPort});

  static ServerProxy _instance;

  static Future<ServerProxy> getInstance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (_instance == null)
      _instance = new ServerProxy(serverHost: pref.getString("server_host") ?? "localhost", serverPort: pref.getString("server_port") ?? "80");

    return _instance;
  }

  Future<Map<String, dynamic>> send(String url, Map<String, dynamic> body) async {
    Map<String, dynamic> returnVal;
    try {
      await http.post("http://" + serverHost + ":" + serverPort + url, body: body.toString()).then((response) {returnVal = jsonDecode(response.body);});
    } catch (SocketException) {
      returnVal = {'success': false, 'message': 'Sever error, could not connect'};
    }
    return returnVal;
  }

  Future<Map<String, dynamic>> sendGetAuth(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String auth_token = preferences.getString("auth_token");
    Map<String, dynamic> returnVal;
    try {
      await http.get("http://" + serverHost + ":" + serverPort + url, headers: {'auth_token': auth_token}).then((response) {returnVal = jsonDecode(response.body);});
    } catch (SocketException) {
      returnVal = {'success': false, 'message': 'Sever error, could not connect'};
    }
    return returnVal;
  }

  Future<Map<String, dynamic>> sendWithAuth(String url, Map<String, dynamic> body) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String auth_token = preferences.getString("auth_token");
    Map<String, dynamic> returnVal;
    try {
      await http.post("http://" + serverHost + ":" + serverPort + url, body: body.toString(), headers: {'auth_token': auth_token}).then((response) {returnVal = jsonDecode(response.body);});
    } catch (SocketException) {
      returnVal = {'success': false, 'message': 'Sever error, could not connect'};
    }
    return returnVal;
  }
}