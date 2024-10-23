// To parse this JSON data, do
//
//     final riderPostResponse = riderPostResponseFromJson(jsonString);

import 'dart:convert';

List<RiderPostResponse> riderPostResponseFromJson(String str) =>
    List<RiderPostResponse>.from(
        json.decode(str).map((x) => RiderPostResponse.fromJson(x)));

String riderPostResponseToJson(List<RiderPostResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RiderPostResponse {
  int riderId;
  String username;
  String email;
  String password;
  String phone;
  String image;
  String vehicleRegistration;

  RiderPostResponse({
    required this.riderId,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.image,
    required this.vehicleRegistration,
  });

  factory RiderPostResponse.fromJson(Map<String, dynamic> json) =>
      RiderPostResponse(
        riderId: json["RiderID"],
        username: json["Username"],
        email: json["Email"],
        password: json["Password"],
        phone: json["Phone"],
        image: json["Image"],
        vehicleRegistration: json["VehicleRegistration"],
      );

  Map<String, dynamic> toJson() => {
        "RiderID": riderId,
        "Username": username,
        "Email": email,
        "Password": password,
        "Phone": phone,
        "Image": image,
        "VehicleRegistration": vehicleRegistration,
      };
}
