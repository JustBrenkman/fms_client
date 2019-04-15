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
  final String personId;

  LoginResponse({this.authToken, this.success, this.message, this.personId});

  LoginResponse.fromJson(Map<String, dynamic> json)
      : authToken = json['authToken'] ?? "",
        success = json['success'] ?? false,
        message = json['message'] ?? "",
        personId = json['personId'] ?? "";
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
        descendant = json['descendant'] ?? null,
        personId = json['personId'] ?? null,
        latitude = json['latitude'] ?? null,
        longitude = json['longitude'] ?? null,
        country = json['country'] ?? null,
        city = json['city'] ?? null,
        eventType = json['eventType'] ?? null,
        year = json['year'] ?? null;
}

class EventsResponse {
  List<Event> data;
  bool success;
  String message;

  EventsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
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
    success = json['success'] ?? false;
    message = json['message'] ?? "";
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
      : id = json['id'] ?? "",
        descendant = json['descendant']  ?? null,
        firstName = json['firstName'] ?? null,
        lastName = json['lastName'] ?? null,
        gender = json['gender'] ?? null,
        fatherID = json['fatherID'] ?? null,
        motherID = json['motherID'] ?? null,
        spouseID = json['spouseID'] ?? null;
}
