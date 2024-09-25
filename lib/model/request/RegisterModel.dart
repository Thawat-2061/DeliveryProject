// To parse this JSON data, do
//
//     final userRegisterModel = userRegisterModelFromJson(jsonString);

import 'dart:convert';

List<UserRegisterModel> userRegisterModelFromJson(String str) =>
    List<UserRegisterModel>.from(
        json.decode(str).map((x) => UserRegisterModel.fromJson(x)));

String userRegisterModelToJson(List<UserRegisterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserRegisterModel {
  String username;
  String email;
  String password;
  String phone;
  String image;
  String address;
  double gpsLatitude;
  double gpsLongitude;

  UserRegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.image,
    required this.address,
    required this.gpsLatitude,
    required this.gpsLongitude,
  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) =>
      UserRegisterModel(
        username: json["Username"],
        email: json["Email"],
        password: json["Password"],
        phone: json["Phone"],
        image: json["Image"],
        address: json["Address"],
        gpsLatitude: json["GPS_Latitude"]?.toDouble(),
        gpsLongitude: json["GPS_Longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Username": username,
        "Email": email,
        "Password": password,
        "Phone": phone,
        "Image": image,
        "Address": address,
        "GPS_Latitude": gpsLatitude,
        "GPS_Longitude": gpsLongitude,
      };
}
