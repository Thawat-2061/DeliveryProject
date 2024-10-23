// To parse this JSON data, do
//
//     final senderGetResponse = senderGetResponseFromJson(jsonString);

import 'dart:convert';

List<SenderGetResponse> senderGetResponseFromJson(String str) =>
    List<SenderGetResponse>.from(
        json.decode(str).map((x) => SenderGetResponse.fromJson(x)));

String senderGetResponseToJson(List<SenderGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SenderGetResponse {
  int orderId;
  int senderId;
  int receiverId;
  int? riderId;
  String name;
  String detail;
  String status;
  String image;
  String customerName;
  String customerPhone;
  double customerLat;
  double customerLong;
  String senderName;
  String senderPhone;
  int senderLat;
  int senderLong;

  SenderGetResponse({
    required this.orderId,
    required this.senderId,
    required this.receiverId,
    required this.riderId,
    required this.name,
    required this.detail,
    required this.status,
    required this.image,
    required this.customerName,
    required this.customerPhone,
    required this.customerLat,
    required this.customerLong,
    required this.senderName,
    required this.senderPhone,
    required this.senderLat,
    required this.senderLong,
  });

  factory SenderGetResponse.fromJson(Map<String, dynamic> json) =>
      SenderGetResponse(
        orderId: json["OrderID"],
        senderId: json["SenderID"],
        receiverId: json["ReceiverID"],
        riderId: json["RiderID"],
        name: json["Name"],
        detail: json["Detail"],
        status: json["Status"],
        image: json["Image"],
        customerName: json["CustomerName"],
        customerPhone: json["CustomerPhone"],
        customerLat: json["CustomerLat"]?.toDouble(),
        customerLong: json["CustomerLong"]?.toDouble(),
        senderName: json["SenderName"],
        senderPhone: json["SenderPhone"],
        senderLat: json["SenderLat"],
        senderLong: json["SenderLong"],
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "SenderID": senderId,
        "ReceiverID": receiverId,
        "RiderID": riderId,
        "Name": name,
        "Detail": detail,
        "Status": status,
        "Image": image,
        "CustomerName": customerName,
        "CustomerPhone": customerPhone,
        "CustomerLat": customerLat,
        "CustomerLong": customerLong,
        "SenderName": senderName,
        "SenderPhone": senderPhone,
        "SenderLat": senderLat,
        "SenderLong": senderLong,
      };
}
