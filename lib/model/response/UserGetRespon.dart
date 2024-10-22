// To parse this JSON data, do
//
//     final userGetRespon = userGetResponFromJson(jsonString);

import 'dart:convert';

List<UserGetRespon> userGetResponFromJson(String str) => List<UserGetRespon>.from(json.decode(str).map((x) => UserGetRespon.fromJson(x)));

String userGetResponToJson(List<UserGetRespon> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGetRespon {
    int userId;
    String username;
    String email;
    String password;
    String phone;
    String image;
    String address;
    double gpsLatitude;
    double gpsLongitude;

    UserGetRespon({
        required this.userId,
        required this.username,
        required this.email,
        required this.password,
        required this.phone,
        required this.image,
        required this.address,
        required this.gpsLatitude,
        required this.gpsLongitude,
    });

    factory UserGetRespon.fromJson(Map<String, dynamic> json) => UserGetRespon(
        userId: json["UserID"],
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
        "UserID": userId,
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
