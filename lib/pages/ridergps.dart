import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider/config/config.dart';
import 'package:rider/model/response/GetResponseUser.dart';
import 'package:rider/model/response/SenderGetResponse.dart';
import 'package:rider/pages/rider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class RiderGPSPage extends StatefulWidget {
  const RiderGPSPage({super.key});

  @override
  State<RiderGPSPage> createState() => _RiderGPSPageState();
}

class _RiderGPSPageState extends State<RiderGPSPage> {
  MapController mapController = MapController();
  var db = FirebaseFirestore.instance;

  final ImagePicker picker = ImagePicker();
  File? image; // ตัวแปรเพื่อเก็บภาพที่เลือก

  LatLng latLng = LatLng(13.7378, 100.5504); // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng destinationLatLng = LatLng(
      16.246825669508297, 103.25199289277295); // จุดปลายทาง (ตัวอย่างพิกัด)

  LatLng sen = LatLng(0, 0); // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng re = LatLng(0, 0); // จุดปลายทาง (ตัวอย่างพิกัด)
  LatLng ri = LatLng(0, 0); // ตัวแปรสำหรับเก็บตำแหน่งปัจจุบัน
  double riderLat = 0;
  double riderLong = 0;
  String url = '';
  String status = '';

  List<GetResponseUser> GetResponsesUserReceiver = [];
  List<GetResponseUser> GetResponsesUserSender = [];
  List<SenderGetResponse> SenderGetResponses = [];

  var receiverId;
  var senderId;
  var senderImage;
  var receiverImage;
  var riderImage;
  var orderId;
  var riderId;
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();
    fetchUsersReceiver();
    fetchUserSender();
    fetchSender();
    _getCurrentLocation(); // เรียกฟังก์ชันเพื่อดึงตำแหน่งปัจจุบัน

    // เรียกฟังก์ชันเพื่อดึงตำแหน่งปัจจุบัน
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: WillPopScope(
        onWillPop: () async {
          // ถ้า status เป็น 'ส่งสำเร็จ' ให้อนุญาตให้ย้อนกลับได้
          if (status == 'ส่งสำเร็จ') {
            return true;
          } else {
            // คืนค่า false เพื่อป้องกันการย้อนกลับถ้า status ไม่ใช่ 'ส่งสำเร็จ'
            return false;
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SlidingUpPanel(
                controller: _panelController,
                maxHeight: 300, // ความสูงสูงสุดตอนดึงขึ้น
                panel: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF171716), borderRadius: radius),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: 50,
                              height: 7,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(144, 158, 158,
                                    158), // สีพื้นหลังของ Container
                                borderRadius:
                                    BorderRadius.circular(10), // ทำให้ขอบโค้ง
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      'Address receiver:',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 5, right: 30),
                                child: Row(
                                  children: [
                                    Flexible(
                                      // Use Flexible to wrap long text
                                      child: Text(
                                        '199/96 ขามเรียง มหาวิทยาลัย มหาสารคาม 44150', // Fixed typo 'มหาวิทยาลับ' to 'มหาวิทยาลัย'
                                        style: TextStyle(fontSize: 16),
                                        softWrap:
                                            true, // Allows text to wrap to the next line
                                        overflow: TextOverflow
                                            .visible, // Ensures the text doesn't overflow
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // จัดเรียงกลาง
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      elevation: 4, // เพิ่มเงาให้กับการ์ด
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // มุมโค้งของการ์ด
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // เพิ่มฟังก์ชันเมื่อกดที่การ์ด
                                          log('Contact Center tapped');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 20), // ระยะห่างภายใน
                                          child: Row(
                                            children: [
                                              Icon(Icons.headset_mic,
                                                  color: Colors.grey), // ไอคอน
                                              SizedBox(
                                                  width:
                                                      8), // ระยะห่างระหว่างไอคอนและข้อความ
                                              Text(
                                                'ติดต่อศูนย์', // ข้อความ
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          log('Chat tapped');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Row(
                                            children: [
                                              Icon(Icons.chat,
                                                  color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                'แชท',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          log('Call tapped');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Row(
                                            children: [
                                              Icon(Icons.phone,
                                                  color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                'โทร',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // จัดเรียงกลาง
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      elevation: 4, // เพิ่มเงาให้กับการ์ด
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // มุมโค้งของการ์ด
                                      ),
                                      child: InkWell(
                                        onTap:
                                            _pickImage, // เรียกใช้งานฟังก์ชันนี้เมื่อผู้ใช้แตะที่ InkWell
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            ClipOval(
                                              child: InkWell(
                                                onTap: () {
                                                  if (image != null) {
                                                    _showImageOptions(
                                                        context); // ฟังก์ชันที่เรียกเมนูตัวเลือก
                                                  } else {
                                                    _pickImage(); // ถ้าไม่มีรูปให้เรียกฟังก์ชันเลือกภาพ
                                                  }
                                                },
                                                child: image != null
                                                    ? Image.file(
                                                        image!,
                                                        width: 180.0,
                                                        height: 180.0,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(
                                                        width: 180.0,
                                                        height: 180.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.grey[
                                                              300], // พื้นหลังสีเทา
                                                        ),
                                                        child: Icon(
                                                          Icons.camera_alt,
                                                          color:
                                                              Colors.grey[800],
                                                          size: 50,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors
                                                      .orangeAccent, // สีพื้นหลังปุ่มกล้อง
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                collapsed: GestureDetector(
                  onTap: () {
                    if (_panelController.isPanelOpen) {
                      _panelController.close();
                    } else {
                      _panelController.open();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 32, 32, 31),
                        borderRadius: radius),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Container(
                            width: 50,
                            height: 7,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(144, 158, 158,
                                  158), // สีพื้นหลังของ Container
                              borderRadius:
                                  BorderRadius.circular(10), // ทำให้ขอบโค้ง
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Rider Detail",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                minHeight:
                    40, // ความสูงตอนที่ยังไม่ดึงขึ้น (สามารถปรับเป็นค่าที่ต้องการได้)
                body: Column(
                  children: [
                    FilledButton(
                        onPressed: () async {
                          var postion = await _determinePosition();
                          log('${postion.latitude} ${postion.longitude}');

                          latLng = LatLng(postion.latitude, postion.longitude);
                          mapController.move(latLng, mapController.camera.zoom);

                          setState(() {});
                        },
                        child: const Text('Get Location')),
                    Expanded(
                      child: Container(
                        width: double.infinity, // ขนาดความกว้างที่ต้องการ
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: sen,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              maxNativeZoom: 19,
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: sen,
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white, // สีพื้นหลัง
                                      shape:
                                          BoxShape.circle, // ทำให้ขอบเป็นวงกลม
                                      border: Border.all(
                                          color: Colors.red,
                                          width: 2), // ขอบสีแดง
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        receiverImage, // แสดงรูป receiverImage แทน Icon
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Marker(
                                  point: re, // จุดปลายทาง
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white, // สีพื้นหลัง
                                      shape:
                                          BoxShape.circle, // ทำให้ขอบเป็นวงกลม
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: 2), // ขอบสีน้ำเงิน
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        senderImage, // แสดงรูป senderImage แทน Icon
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Marker(
                                  point: ri, // ใช้ตำแหน่งปัจจุบัน
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.green, width: 2),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        riderImage, // แสดงรูป senderImage แทน Icon
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [sen, ri], // ลิสต์ของจุดเส้นทาง
                                  color: Colors.blue,
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                borderRadius: radius,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40, top: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8), // สีของเงา
                      blurRadius: 7, // ความเบลอของเงา
                      offset: Offset(0, 3), // ตำแหน่งของเงา (x, y)
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('ยืนยันการทำงาน'),
                          content: Text('คุณต้องการดำเนินการต่อหรือไม่?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // ปิด dialog เมื่อกด Cancel
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // ปิด dialog เมื่อกด Confirm

                                // ดำเนินการต่อเมื่อกด Confirm
                                if (status == '' && image != null) {
                                  editOrderImage();
                                  setState(() {
                                    status = 'กำลังเดินทาง';
                                    image = null;
                                  });
                                } else if (status == 'กำลังเดินทาง' &&
                                    image != null) {
                                  editOrderImage();
                                  setState(() {
                                    status = 'ส่งสำเร็จ';
                                    image = null;
                                  });
                                } else {
                                  log('ใส่รูปก่อนยืนยัน');
                                }
                                // log('Button tapped');
                              },
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    _getStatusText(status),
                    style: TextStyle(
                      fontSize: 18, // ขนาดตัวอักษร
                      color: Colors.black, // สีข้อความ
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(status),
                    minimumSize: Size(double.infinity, 50), // ขนาดขั้นต่ำ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // ความโค้งของมุม
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void locationNow() async {
    var postion = await _determinePosition();
    log('${postion.latitude} ${postion.longitude}');
    latLng = LatLng(postion.latitude, postion.longitude);
    mapController.move(latLng, mapController.camera.zoom);
    setState(() {});
  }

  Future<void> GetApiEndpoint() async {
    Configguration.getConfig().then(
      (value) {
        log('MainUserGet API ');
        // log(value['apiEndpoint']);
        setState(() {
          url = value['apiEndpoint'];
        });
      },
    ).catchError((err) {
      log(err.toString());
    });
  }
//------------------------------------------------------------------------------------------------------------------------

  Future<void> getUserDataFromStorage() async {
    final storage = GetStorage();

    final receiverId = storage.read('ReceiverID');
    final senderId = storage.read('SenderID');
    final senderImage = storage.read('SenderImage');
    final receiverImage = storage.read('ReceiverImage');

    final riderImage = storage.read('RiderImage');
    final orderId = storage.read('OrderID');
    final riderId = storage.read('RiderID');

    // final userUsername = storage.read('Username');
    // final userEmail = storage.read('Email');
    // final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.receiverId = receiverId;
      this.senderId = senderId;
      this.senderImage = senderImage;
      this.receiverImage = receiverImage;

      this.riderImage = riderImage;
      this.orderId = orderId;
      this.riderId = riderId;

      // this.userUsername = userUsername;
      // this.userEmail = userEmail;
      // this.userImage = userImage;
      // log('sender: $riderImage');
      log('sender: $senderId');
      log('image: $riderImage');

      log('recevei: $receiverId');
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        ri = LatLng(position.latitude,
            position.longitude); // เซ็ตตำแหน่งที่อยู่ปัจจุบัน
        riderLat = position.latitude;
        riderLong = position.longitude;
      });
    } catch (e) {
      // จัดการกรณีเกิดข้อผิดพลาด เช่น การไม่สามารถเข้าถึงตำแหน่งได้
      print(e);
    }
  }

  Future<void> fetchUsersReceiver() async {
    // แสดง dialog โหลดข้อมูล

    try {
      final res = await http.get(
        Uri.parse("$url/profile/user/$receiverId"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        setState(() {
          GetResponsesUserReceiver = getResponseUserFromJson(res.body);

          //  var user = GetResponsesUser.first; // สมมติว่าใช้ผู้ใช้งานคนแรก
          //   latLng = LatLng(user.gpsLatitude, user.gpsLongitude); // ใช้ข้อมูล GPS จาก API
          //   mapController.move(latLng,mapController.camera.zoom);
        });
      } else {
        log("Failed to load users: ${res.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      // ปิด Dialog หลังจากโหลดข้อมูลเสร็จ
    }
  }
//------------------------------------------------------------------------------------------------------------------------

  Future<void> fetchUserSender() async {
    // แสดง dialog โหลดข้อมูล
    _showLoadingDialog();

    try {
      final res = await http.get(
        Uri.parse("$url/profile/user/$senderId"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        setState(() {
          GetResponsesUserSender = getResponseUserFromJson(res.body);

          //  var user = GetResponsesUser.first; // สมมติว่าใช้ผู้ใช้งานคนแรก
          //   latLng = LatLng(user.gpsLatitude, user.gpsLongitude); // ใช้ข้อมูล GPS จาก API
          //   mapController.move(latLng,mapController.camera.zoom);
        });
      } else {
        log("Failed to load users: ${res.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      // ปิด Dialog หลังจากโหลดข้อมูลเสร็จ
      Navigator.of(context).pop();
    }
  }

//------------------------------------------------------------------------------------------------------------------------

  Future<void> fetchSender() async {
    try {
      final res = await http.get(
        Uri.parse("$url/user/show/$senderId"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        // ตรวจสอบว่า API ส่งกลับสถานะ 200 หรือไม่
        setState(() {
          SenderGetResponses = senderGetResponseFromJson(res.body);
          // อัพเดทพิกัดแผนที่จากข้อมูลใน API
          var user = SenderGetResponses.first; // สมมติว่าใช้ผู้ใช้งานคนแรก
          sen = LatLng(
              user.customerLat, user.customerLong); // ใช้ข้อมูล GPS จาก API
          re = LatLng(
              user.senderLat, user.senderLong); // จุดปลายทาง (ตัวอย่างพิกัด)

          mapController.move(sen, mapController.camera.zoom);
        });
        // log('aaaaaaaa: $receiverId');
      } else {
        log("Failed to load users: ${res.statusCode}");
      }

      final data = json.decode(res.body);

      // log(res.body);
    } catch (e) {
      log("Error: $e");
    }
  }

  void _showLoadingDialog() {
    // โลหด
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด dialog โดยคลิกที่ด้านนอก
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // แสดงวงกลมหมุน
              SizedBox(height: 15),
              Text("Loading...", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  void bowljob() async {
    try {
      // Send PUT request to the API
      // log('Sending PUT request...');
      final response = await http.put(
        Uri.parse("$url/status/update"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(
            {"OrderID": orderId, "RiderID": riderId, "Status": status}),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = {
          'latitude': riderLat,
          'longitude': riderLong,
          'Status': status,
          'createAt': DateTime.timestamp()
        };

        db.collection('RealLocation').doc('RiderID: $riderId').set(data);
        // log('Password changed successfully!');
        // final storage = GetStorage();
        // await storage.write('UserPassword', passCtl.text.toString());
        // await getUserDataFromStorage();
        // await Get.to(() => const ProfilePage()); // Navigate to the next page

        // Check if the widget is still mounted before navigating
        // if (!context.mounted) return;
        Navigator.of(context).pop(); // ปิด dialog
        Get.to(() => const RiderGPSPage()); // เปลี่ยนไปที่หน้าถัดไป

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status Changed successfully!')),
        );
      } else if (response.statusCode == 409) {
        log('Username already exists');
      } else {
        log('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('An error occurred: $e'); // Log any errors that occur during the request
    }
  }

  Future<void> _pickImage() async {
    // แสดงตัวเลือกให้ผู้ใช้เลือกระหว่างกล้องและแกลอรี่
    showModalBottomSheet(
      context: context, // ใช้ BuildContext ที่ถูกต้องจาก Flutter
      builder: (BuildContext modalContext) {
        // เปลี่ยนชื่อที่นี่
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(modalContext).pop(); // ปิด modal
                  await _selectImage(ImageSource.camera); // เลือกภาพจากกล้อง
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(modalContext).pop(); // ปิด modal
                  await _selectImage(ImageSource.gallery); // เลือกภาพจากแกลอรี่
                },
              ),
            ],
          ),
        );
      },
    );
  }

// ฟังก์ชันสำหรับเลือกภาพจากแหล่งต่าง ๆ
  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      // เรียกใช้งานฟังก์ชันอัปโหลดไฟล์หลังเลือกภาพ
    }
  }

  Future<void> _uploadFile() async {
    if (image == null) {
      print('No file selected!');
      return;
    }
    // setState(() {
    //   status = 'กำลังเดินทาง';
    // });

    try {
      // สร้าง MultipartRequest โดยใช้ $url
      var request =
          http.MultipartRequest('POST', Uri.parse("$url/upload/upstatus"));
      // String fileName = path.basename(image!.path);

      // เพิ่มไฟล์ไปยัง request
      request.files.add(await http.MultipartFile.fromPath(
        'file', // ชื่อฟิลด์ที่เซิร์ฟเวอร์คาดหวัง
        image!.path,
        // filename: fileName, // ตั้งชื่อไฟล์ตามที่เซิร์ฟเวอร์ต้องการ
      ));

      // ส่ง request
      final response = await request.send();

      // รับข้อมูลที่ตอบกลับ
      final responseData = await http.Response.fromStream(response);
      print('Response body: ${responseData.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        log(data.toString()); // แสดงข้อมูลที่ได้รับ

        // ตรวจสอบว่า 'url' มีอยู่ใน data หรือไม่
        if (data.containsKey('url')) {
          final res = await http.post(
            Uri.parse("$url/upload/imageUP"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: jsonEncode({
              "OrderID": orderId,
              "Image": data['url'].toString(),
              "Status": status
            }),
          );

          if (res.statusCode == 200) {
            log("Upload Firebase");
            final storage = GetStorage();
            await storage.write('Image', data['url'].toString() ?? '');
          }
        } else {
          print('Error: URL not found in response');
        }

        print('File uploaded successfully: $data');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while uploading file: $e');
    }
  }

  void editOrderImage() async {
    await _uploadFile();
    if (status == 'ส่งสำเร็จ') {
      Get.offAll(const RiderPage());
    }
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('ดูภาพเต็ม'),
              onTap: () {
                Navigator.of(context).pop();
                _viewFullImage(); // ฟังก์ชันดูภาพเต็มจอ
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('เปลี่ยนภาพ'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(); // ฟังก์ชันเลือกภาพใหม่
              },
            ),
          ],
        );
      },
    );
  }

  void _viewFullImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.file(
            image!,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'รอไรเดอร์':
        return Colors.grey; // สีเทาสำหรับสถานะ "รอไรเดอร์"
      case '':
        return Colors
            .deepOrangeAccent; // สีส้มสำหรับสถานะ "ไรเดอร์รับงาน" และ "กำลังเดินทาง"
      case 'กำลังเดินทาง':
        return Colors
            .yellowAccent; // สีส้มสำหรับสถานะ "ไรเดอร์รับงาน" และ "กำลังเดินทาง"
      case 'ส่งสำเร็จ':
        return Color.fromARGB(255, 67, 233, 78); // สีเขียวสำหรับสถานะ "สำเร็จ"
      default:
        return Colors.white; // สีขาวสำหรับสถานะอื่น ๆ (ถ้ามี)
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'รอไรเดอร์':
        return 'ไรเดอร์รับงานแล้ว';
      case '':
        return 'ไรเดอร์รับสินค้าแล้วกำลังส่งสินค้า';
      case 'กำลังเดินทาง':
        return 'สินค้าส่งสำเร็จแล้ว';
      case 'ส่งสำเร็จ':
        return '';
      default:
        return 'สถานะไม่ทราบ';
    }
  }
}
