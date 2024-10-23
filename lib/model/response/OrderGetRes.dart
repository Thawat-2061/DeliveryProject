// To parse this JSON data, do
//
//     final orderGetResponse = orderGetResponseFromJson(jsonString);

import 'dart:convert';

List<OrderGetResponse> orderGetResponseFromJson(String str) =>
    List<OrderGetResponse>.from(
        json.decode(str).map((x) => OrderGetResponse.fromJson(x)));

String orderGetResponseToJson(List<OrderGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderGetResponse {
  int orderId;
  int senderId;
  int receiverId;
  dynamic riderId;
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
  double senderLat;
  double senderLong;

  OrderGetResponse({
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

  factory OrderGetResponse.fromJson(Map<String, dynamic> json) =>
      OrderGetResponse(
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
        senderLat: json["SenderLat"]?.toDouble(),
        senderLong: json["SenderLong"]?.toDouble(),
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
