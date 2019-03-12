import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<String> getUserName() async {
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