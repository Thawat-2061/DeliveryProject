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
  int orderId;
  int senderId;
  int receiverId;
  dynamic riderId;
  String name;
  String detail;
  String status;
  String image;
  String senderPhone;
  String senderName;
  String customerPhone;
  String customerName;
  String senderImage;
  String customerImage;
  double senderLAt;
  double senderLong;
  double customerLAt;
  double customerLong;

  RiderGetResponse({
    required this.orderId,
    required this.senderId,
    required this.receiverId,
    required this.riderId,
    required this.name,
    required this.detail,
    required this.status,
    required this.image,
    required this.senderPhone,
    required this.senderName,
    required this.customerPhone,
    required this.customerName,
    required this.senderImage,
    required this.customerImage,
    required this.senderLAt,
    required this.senderLong,
    required this.customerLAt,
    required this.customerLong,
  });

  factory RiderGetResponse.fromJson(Map<String, dynamic> json) =>
      RiderGetResponse(
        orderId: json["OrderID"],
        senderId: json["SenderID"],
        receiverId: json["ReceiverID"],
        riderId: json["RiderID"],
        name: json["Name"],
        detail: json["Detail"],
        status: json["Status"],
        image: json["Image"],
        senderPhone: json["SenderPhone"],
        senderName: json["SenderName"],
        customerPhone: json["CustomerPhone"],
        customerName: json["CustomerName"],
        senderImage: json["SenderImage"],
        customerImage: json["CustomerImage"],
        senderLAt: json["SenderLAt"]?.toDouble(),
        senderLong: json["SenderLong"]?.toDouble(),
        customerLAt: json["CustomerLAt"]?.toDouble(),
        customerLong: json["CustomerLong"]?.toDouble(),
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
        "SenderPhone": senderPhone,
        "SenderName": senderName,
        "CustomerPhone": customerPhone,
        "CustomerName": customerName,
        "SenderImage": senderImage,
        "CustomerImage": customerImage,
        "SenderLAt": senderLAt,
        "SenderLong": senderLong,
        "CustomerLAt": customerLAt,
        "CustomerLong": customerLong,
      };
}
