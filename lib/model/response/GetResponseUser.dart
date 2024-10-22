// To parse this JSON data, do
//
//     final getResponseUser = getResponseUserFromJson(jsonString);

import 'dart:convert';

List<GetResponseUser> getResponseUserFromJson(String str) => List<GetResponseUser>.from(json.decode(str).map((x) => GetResponseUser.fromJson(x)));

String getResponseUserToJson(List<GetResponseUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetResponseUser {
    int userId;
    String username;
    String email;
    String password;
    String phone;
    String image;
    String address;
    double gpsLatitude;
    double gpsLongitude;

    GetResponseUser({
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

    factory GetResponseUser.fromJson(Map<String, dynamic> json) => GetResponseUser(
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
