// To parse this JSON data, do
//
//     final riderGetResponse = riderGetResponseFromJson(jsonString);

import 'dart:convert';

List<RiderGetResponse> riderGetResponseFromJson(String str) => List<RiderGetResponse>.from(json.decode(str).map((x) => RiderGetResponse.fromJson(x)));

String riderGetResponseToJson(List<RiderGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    });

    factory RiderGetResponse.fromJson(Map<String, dynamic> json) => RiderGetResponse(
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
    };
}
