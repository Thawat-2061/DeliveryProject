// To parse this JSON data, do
//
//     final riderGetResponse = riderGetResponseFromJson(jsonString);

import 'dart:convert';

List<RiderGetResponse> riderGetResponseFromJson(String str) =>
    List<RiderGetResponse>.from(
        json.decode(str).map((x) => RiderGetResponse.fromJson(x)));

String riderGetResponseToJson(List<RiderGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RiderGetResponse {
  int riderId;
  String username;
  String email;
  String password;
  String phone;
  String image;
  String vehicleRegistration;

  RiderGetResponse({
    required this.riderId,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.image,
    required this.vehicleRegistration,
  });

  factory RiderGetResponse.fromJson(Map<String, dynamic> json) =>
      RiderGetResponse(
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
