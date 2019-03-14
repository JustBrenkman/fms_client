class RegisterRequest {
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  RegisterRequest(
      {this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.gender});

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

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class LoginResponse {
  final String authToken;
  final bool success;
  final String message;

  LoginResponse({this.authToken, this.success, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json)
      : authToken = json['authToken'],
        success = json['success'],
        message = json['message'];
}

class Event {
  String id;
  String descendant;
  String personId;
  double latitude;
  double longitude;
  String country;
  String city;
  String eventType;
  int year;

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        descendant = json['descendant'],
        personId = json['personId'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        country = json['country'],
        city = json['city'],
        eventType = json['eventType'],
        year = json['year'];
}

class EventsResponse {
  List<Event> data;
  bool success;
  String message;

  EventsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = new List();
    List<dynamic> list = json['data'] as List<dynamic>;
    list.forEach((map) => data.add(Event.fromJson(map)));
  }
}

class PersonsResponse {
  List<Person> data;
  bool success;
  String message;

  PersonsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = new List();
    List<dynamic> list = json['data'] as List<dynamic>;
    list.forEach((map) => data.add(Person.fromJson(map)));
  }
}

class Person {
  String id;
  String descendant;
  String firstName;
  String lastName;
  String gender;
  String fatherID;
  String motherID;
  String spouseID;

  Person.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        descendant = json['descendant'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        gender = json['gender'],
        fatherID = json['fatherID'],
        motherID = json['motherID'],
        spouseID = json['spouseID'];
}
