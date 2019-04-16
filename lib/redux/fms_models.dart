class RegisterRequest {
  final String userName;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  RegisterRequest(
      {this.userName,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.gender});

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender
      };
}

class LoginRequest {
  final String userName;
  final String password;

  LoginRequest({this.userName, this.password});

  Map<String, dynamic> toJson() => {'userName': userName, 'password': password};
}

class LoginResponse {
  final String authToken;
  final bool success;
  final String message;
  final String personID;

  LoginResponse({this.authToken, this.success, this.message, this.personID});

  LoginResponse.fromJson(Map<String, dynamic> json)
      : authToken = json['authToken'] ?? "",
        success = json['success'] ?? false,
        message = json['message'] ?? "",
        personID = json['personId'] ?? "";
}

class Event {
  String id;
  String descendant;
  String personID;
  double latitude;
  double longitude;
  String country;
  String city;
  String eventType;
  int year;

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        descendant = json['descendant'] ?? null,
        personID = json['personID'] ?? null,
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
  String personID;
  String descendant;
  String firstName;
  String lastName;
  String gender;
  String father;
  String mother;
  String spouse;

  Person.fromJson(Map<String, dynamic> json)
      : personID = json['personID'] ?? "",
        descendant = json['descendant']  ?? null,
        firstName = json['firstName'] ?? null,
        lastName = json['lastName'] ?? null,
        gender = json['gender'] ?? null,
        father = json['father'] ?? null,
        mother = json['mother'] ?? null,
        spouse = json['spouse'] ?? null;
}
