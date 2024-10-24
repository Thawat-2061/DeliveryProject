import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider/config/config.dart';
import 'package:rider/model/response/GetResponseUser.dart';
import 'package:rider/model/response/SenderGetResponse.dart';
import 'package:rider/pages/rider.dart';
import 'package:rider/pages/ridergps.dart';
import 'package:rider/pages/riprofile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class RiderviewPage extends StatefulWidget {
  const RiderviewPage({super.key});

  @override
  State<RiderviewPage> createState() => _RiderviewPageState();
}

class _RiderviewPageState extends State<RiderviewPage> {
  MapController mapController = MapController();
  var db = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _subscription;

  final FirebaseFirestore db2 = FirebaseFirestore.instance;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<DocumentSnapshot>? _statusStream;

  LatLng sen = LatLng(0, 0); // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng re = LatLng(0, 0); // จุดปลายทาง (ตัวอย่างพิกัด)

  // LatLng newana = LatLng(
  //     16.246825669508297, 103.25199289277295); // จุดปลายทาง (ตัวอย่างพิกัด
  LatLng ri = LatLng(0, 0); // ตัวแปรสำหรับเก็บตำแหน่งปัจจุบัน
  double riderLat = 0;
  double riderLong = 0;
  var riderId;

  final PanelController _panelController = PanelController();
//----------------------------------------------------------------------------------------------------
  List<GetResponseUser> GetResponsesUserReceiver = [];
  List<GetResponseUser> GetResponsesUserSender = [];

  List<SenderGetResponse> SenderGetResponses = [];

  String url = '';
  String status = '';
  var orderId;

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
  }

  var receiverId;
  var senderId;
  var senderImage;
  var receiverImage;
  var riderImage;
//-----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Column(
        children: [
          Expanded(
            child: SlidingUpPanel(
              controller: _panelController,
              maxHeight: 400, // ความสูงสูงสุดตอนดึงขึ้น
              panel: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF171716), borderRadius: radius),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: 50,
                          height: 7,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                144, 158, 158, 158), // สีพื้นหลังของ Container
                            borderRadius:
                                BorderRadius.circular(10), // ทำให้ขอบโค้ง
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: GetResponsesUserReceiver.asMap()
                            .entries
                            .map((entry) {
                          var user = entry
                              .value; // ข้อมูลแต่ละ entry ที่ได้จากฐานข้อมูลหรือ API
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Receiver name: ${user.username}',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Phone number: ${user.phone}',
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
                                        'Address receiver: ${user.address}', // Fixed typo 'มหาวิทยาลับ' to 'มหาวิทยาลัย'
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
                            ],
                          );
                        }).toList(), // แปลง map เป็น list ของ widgets
                      ),
                      Column(
                        children:
                            GetResponsesUserSender.asMap().entries.map((entry) {
                          var user = entry
                              .value; // ข้อมูลแต่ละ entry ที่ได้จากฐานข้อมูลหรือ API
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Sender name: ${user.username}',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Phone number: ${user.phone}',
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
                                        'Address receiver: ${user.address}', // Fixed typo 'มหาวิทยาลับ' to 'มหาวิทยาลัย'
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
                            ],
                          );
                        }).toList(), // แปลง map เป็น list ของ widgets
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 50),
                        child: Row(
                          children: [
                            Text(
                              'เดินทางด้วยมอเตอร์ไซค์',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFECC838),
                              ),
                            ),
                            Image.asset(
                              'assets/images/cyc.png', // แสดงภาพจาก assets
                              width: 100, // กำหนดความกว้างของภาพ
                              height: 50, // กำหนดความสูงของภาพ
                            ),
                          ],
                        ),
                      ),
                    ],
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
                            color: const Color.fromARGB(
                                144, 158, 158, 158), // สีพื้นหลังของ Container
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
                  Expanded(
                    child: Container(
                      width: double.infinity, // ขนาดความกว้างที่ต้องการ
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: re,
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
                                point: re,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // สีพื้นหลัง
                                    shape: BoxShape.circle, // ทำให้ขอบเป็นวงกลม
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
                                point: sen, // จุดปลายทาง
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // สีพื้นหลัง
                                    shape: BoxShape.circle, // ทำให้ขอบเป็นวงกลม
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
                                points: [re, ri], // ลิสต์ของจุดเส้นทาง
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
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // จัดตำแหน่งปุ่ม
              children: [
                ElevatedButton(
                  onPressed: () {
                    // เพิ่มการทำงานที่ต้องการสำหรับปุ่ม 1
                    Get.offAll(() => const RiderPage());

                    log('Button 1 tapped');
                  },
                  child: Text(
                    'ไม่รับงาน',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18), // สีข้อความเป็นสีขาว
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 194, 192, 192), // สีพื้นหลังเป็นสีเขียว
                    shadowColor: Colors.black, // สีเงา
                    elevation: 5, // ขนาดของเงา
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14), // ทำให้ขอบปุ่มโค้ง
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // แสดง dialog ยืนยันการรับงาน
                      _showConfirmationDialog(context);
                    },
                    child: Text(
                      'รับงาน',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18), // สีข้อความเป็นสีขาว
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF67B562), // สีพื้นหลังเป็นสีเขียว
                      shadowColor: Colors.black, // สีเงา
                      elevation: 5, // ขนาดของเงา
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14), // ทำให้ขอบปุ่มโค้ง
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
//------------------------------------------------------------------------------------------------------------------------

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

  // void locationNow() async {
  //   var postion = await _determinePosition();
  //   log('${postion.latitude} ${postion.longitude}');
  //   latLng = LatLng(postion.latitude, postion.longitude);
  //   mapController.move(latLng, mapController.camera.zoom);
  //   setState(() {});
  // }
//------------------------------------------------------------------------------------------------------------------------

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16), // ทำให้มุมของ dialog โค้งมน
          ),
          title: Text(
            'Confirm job acceptance',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // ขนาดตัวอักษร
                color: Colors.white),
          ),
          content: Row(
            children: [
              Icon(Icons.question_mark_rounded,
                  color: Colors.amber), // เพิ่มไอคอนเตือน
              SizedBox(width: 10), // ช่องว่างระหว่างไอคอนและข้อความ
              Expanded(
                child: Text(
                  'Are you sure you want to take this job?',
                  style: TextStyle(
                      fontSize: 16, color: Colors.grey), // ขนาดตัวอักษร
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // ปิด dialog
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white), // สีข้อความเป็นสีแดง
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        status = 'ไรเดอร์รับงาน';
                      });
                      startRealtimeGet();
                      bowljob();
                      // ปิด dialog และไปที่หน้าถัดไป

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('You have received this job!')),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF67B562), // สีพื้นหลังของ Container
                        borderRadius: BorderRadius.circular(
                            24.0), // กำหนดความโค้งของ Container
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // เพิ่มระยะห่างภายใน Container
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.white), // สีข้อความเป็นสีขาว
                      ),
                    )),
              ],
            ),
          ],
        );
      },
    );
  }

//------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------

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
//------------------------------------------------------------------------------------------------------------------------

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
          re = LatLng(
              user.customerLat, user.customerLong); // ใช้ข้อมูล GPS จาก API
          sen = LatLng(
              user.senderLat, user.senderLong); // จุดปลายทาง (ตัวอย่างพิกัด)

          mapController.move(re, mapController.camera.zoom);
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
//------------------------------------------------------------------------------------------------------------------------

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

        db.collection('RealLocation').doc(riderId).set(data);
        // log('Password changed successfully!');
        // final storage = GetStorage();
        // await storage.write('UserPassword', passCtl.text.toString());
        // await getUserDataFromStorage();
        // await Get.to(() => const ProfilePage()); // Navigate to the next page

        // Check if the widget is still mounted before navigating
        // if (!context.mounted) return;
        Navigator.of(context).pop(); // ปิด dialog
        Get.offAll(() => const RiderGPSPage()); // เปลี่ยนไปที่หน้าถัดไป

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status Changed successfully!')),
        );
      } else if (response.statusCode == 409) {
        // log('Username already exists');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('มีคนรับงานแล้ว'), // ข้อความที่จะแสดง
            duration: Duration(seconds: 3), // ระยะเวลาที่จะแสดง Snackbar
          ),
        );
      } else {
        log('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('An error occurred: $e'); // Log any errors that occur during the request
    }
  }

  void startRealtimeGet() {
    final docRef = db.collection("RealLocation").doc('riderLocation');
    _subscription = docRef.snapshots().listen(
      (event) {
        var data = event.data();
        Get.snackbar(
            "Data Updated", "Timestamp: ${data!['createAt'].toString()}");
        Get.snackbar(
          "Start Real-Time", // หัวข้อ
          "This is a simple message without a title.", // ข้อความที่ต้องการแสดง
          snackPosition: SnackPosition.BOTTOM, // ตำแหน่งของ snackbar
          duration: Duration(seconds: 5), // ระยะเวลาในการแสดง snackbar
        );
        log("current data: ${event.data()}");
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  void startRealtimeLocationUpdates(String riderId) async {
    try {
      // Check for location permission first
      await _checkLocationPermission();

      // Start listening to location changes if permission is granted
      _listenToLocationChanges(riderId);

      // Start listening to the status in Firestore
      _listenToStatusChanges(riderId);
    } catch (e) {
      log("Error: $e");
    }
  }

  // Method to check for location permission
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
  }

  // Method to listen to location changes and update Firestore
  void _listenToLocationChanges(String riderId) {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy:
            LocationAccuracy.high, // Use high accuracy for real-time tracking
        distanceFilter: 10, // Update when user moves 10 meters
      ),
    ).listen((Position position) async {
      // Log the current position
      log('Current position: ${position.latitude}, ${position.longitude}');

      // Send location to Firestore, using riderId as document ID
      final docRef = db.collection("RealLocation").doc(riderId);
      await docRef.set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'createAt': FieldValue.serverTimestamp(),
      });

      // Optionally display the update in the app
      Get.snackbar(
        "Location Updated",
        "Lat: ${position.latitude}, Lng: ${position.longitude}",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    });
  }

  // Method to listen to status changes in Firestore
  void _listenToStatusChanges(String riderId) {
    final statusDocRef = db
        .collection("YourCollection")
        .doc(riderId); // Use riderId to check status

    _statusStream = statusDocRef.snapshots().listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        if (data != null && data['status'] == 'ส่งสำเร็จ') {
          // If status is 'ส่งสำเร็จ', stop location updates
          stopRealtimeLocationUpdates();
          Get.snackbar(
            "Status Update",
            "Location updates stopped due to successful send.",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
        }
      }
    });
  }

  // Method to stop listening to location changes when no longer needed
  void stopRealtimeLocationUpdates() {
    _positionStream?.cancel();
    _statusStream?.cancel(); // Cancel the status stream as well
  }
}

  // void stopRealtimeGet() {
  //   _subscription?.cancel(); // ยกเลิกการฟังการเปลี่ยนแปลง
  //   log("Stopped listening to real-time updates.");
  // }

