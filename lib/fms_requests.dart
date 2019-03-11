import 'package:shared_preferences/shared_preferences.dart';


class RegisterRequest {
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  RegisterRequest({this.username, this.password, this.email, this.firstName, this.lastName, this.gender});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender
  };
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({this.username, this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password
  };
}

class LoginResponse {
  final String authToken;
  final bool success;
  final String message;

  LoginResponse({this.authToken, this.success, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json):
        authToken = json['authToken'],
        success = json['success'],
        message = json['message']
  ;
}