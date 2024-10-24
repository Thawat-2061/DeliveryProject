// To parse this JSON data, do
//
//     final receiverGetResponse = receiverGetResponseFromJson(jsonString);

import 'dart:convert';

List<ReceiverGetResponse> receiverGetResponseFromJson(String str) => List<ReceiverGetResponse>.from(json.decode(str).map((x) => ReceiverGetResponse.fromJson(x)));

String receiverGetResponseToJson(List<ReceiverGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiverGetResponse {
<<<<<<< HEAD
  int orderId;
  int senderId;
  int receiverId;
  dynamic riderId;
  String name;
  String detail;
  String status;
  String image;
  String senderName;
  String phone;
  double senderLat;
  double senderLong;
  String senderImage;
  String receiverImage;
=======
    int orderId;
    int senderId;
    int receiverId;
    dynamic riderId;
    String name;
    String detail;
    String status;
    String image;
    String senderName;
    String phone;
    double senderLat;
    double senderLong;
    String senderImage;
    String receiverImage;
>>>>>>> e3dbd0c2176ef2f8eef748e2dbb181fc72b84ad0

    ReceiverGetResponse({
        required this.orderId,
        required this.senderId,
        required this.receiverId,
        required this.riderId,
        required this.name,
        required this.detail,
        required this.status,
        required this.image,
        required this.senderName,
        required this.phone,
        required this.senderLat,
        required this.senderLong,
        required this.senderImage,
        required this.receiverImage,
    });

    factory ReceiverGetResponse.fromJson(Map<String, dynamic> json) => ReceiverGetResponse(
        orderId: json["OrderID"],
        senderId: json["SenderID"],
        receiverId: json["ReceiverID"],
        riderId: json["RiderID"],
        name: json["Name"],
        detail: json["Detail"],
        status: json["Status"],
        image: json["Image"],
        senderName: json["SenderName"],
        phone: json["Phone"],
        senderLat: json["SenderLat"]?.toDouble(),
        senderLong: json["SenderLong"]?.toDouble(),
        senderImage: json["SenderImage"],
        receiverImage: json["ReceiverImage"],
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
        "SenderName": senderName,
        "Phone": phone,
        "SenderLat": senderLat,
        "SenderLong": senderLong,
        "SenderImage": senderImage,
        "ReceiverImage": receiverImage,
    };
}
