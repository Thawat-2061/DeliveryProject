import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rider/config/config.dart';
import 'package:rider/model/response/GetResponseUser.dart';
import 'package:rider/model/response/RiderGetRes.dart';
import 'package:rider/pages/addOrder.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/sender.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MapController mapController = MapController();

  String url = '';
  var riderId;
  var senderId;

  List<dynamic> riderData = [];
  List<GetResponseUser> GetResponsesUser = [];

  List<RiderGetResponse> RiderGetResponses = [];

  LatLng latLng = LatLng(13.7378, 100.5504); // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng destinationLatLng = LatLng(
      16.246825669508297, 103.25199289277295); // จุดปลายทาง (ตัวอย่างพิกัด)
  //-----------------------------------------------------------
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => const SenderPage());
        break;
      case 1:
        Get.to(() => const ReceiverPage());
        break;
      case 2:
        Get.to(() => const ProfilePage());
        break;

      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();
    getRiderMet();
  }

//-----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SlidingUpPanel(
        panel: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 227, 131, 102),
              borderRadius: radius),
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
                      borderRadius: BorderRadius.circular(10), // ทำให้ขอบโค้ง
                    ),
                  ),
                ),
                Column(
                  children: RiderGetResponses.asMap().entries.map((entry) {
                    var rider = entry
                        .value; // ข้อมูลแต่ละ entry ที่ได้จากฐานข้อมูลหรือ API

                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // กำหนดให้เป็นวงกลม
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5), // สีของเงา
                              spreadRadius: 5, // ขยายขนาดเงา
                              blurRadius: 9, // ทำให้เงาเบลอ
                              offset: Offset(0, 3), // ตำแหน่งของเงา
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            rider.image,
                            width: 150.0, // กำหนดความกว้างของวงกลม
                            height: 150.0, // กำหนดความสูงของวงกลม
                            fit: BoxFit.cover, // ปรับขนาดภาพให้พอดีกับวงกลม
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Column(
                      children: RiderGetResponses.asMap().entries.map((entry) {
                        var rider = entry.value;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Rider name: ${rider.username}',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    'Phone number: ${rider.phone}',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    'Car Registration: ${rider.vehicleRegistration}',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Status Order:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ' กำลังส่งสินค้า',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: const Color.fromARGB(
                                            255, 238, 74, 25),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    'Receiver name: ลุงสมยศ พจมารทรายทอง',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Sender name: Aumza55+',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        collapsed: Container(
          decoration: BoxDecoration(
              color: Colors.deepOrangeAccent, borderRadius: radius),
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
                    borderRadius: BorderRadius.circular(10), // ทำให้ขอบโค้ง
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
                    initialCenter: latLng,
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
                          point: latLng,
                          width: 40,
                          height: 40,
                          child:
                              Icon(Icons.motorcycle_sharp, color: Colors.red),
                        ),
                        Marker(
                          point: destinationLatLng, // จุดปลายทาง
                          width: 40,
                          height: 40,
                          child: Icon(Icons.location_pin, color: Colors.blue),
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [
                            latLng,
                            destinationLatLng
                          ], // ลิสต์ของจุดเส้นทาง
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color(0xFF171716), // สีพื้นหลังของ BottomNavigationBar
        selectedItemColor:
            const Color.fromARGB(255, 240, 65, 42), // สีของไอคอนที่ถูกเลือก
        unselectedItemColor: Colors.grey, // สีของไอคอนที่ไม่ถูกเลือก
        currentIndex: _selectedIndex, // กำหนด index ของไอคอนที่ถูกเลือก
        onTap: _onItemTapped,
        showSelectedLabels: true, // แสดงข้อความของไอคอนที่เลือก
        showUnselectedLabels: true, // แสดงข้อความของไอคอนที่ไม่เลือก
        selectedLabelStyle: TextStyle(
          fontSize: 14, // กำหนดขนาดตัวอักษรเมื่อเลือก
          fontWeight: FontWeight.bold, // ทำให้ข้อความตัวหนาเมื่อถูกเลือก
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14, // กำหนดขนาดตัวอักษรเมื่อไม่เลือกให้เท่ากัน
          fontWeight:
              FontWeight.normal, // ไม่ทำให้ข้อความตัวหนาเมื่อไม่ถูกเลือก
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.unarchive, size: 30), // ไอคอนของรายการ
            label: 'Sender', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive, size: 30), // ไอคอนของรายการ
            label: 'Receiver', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/profile.png', // ระบุพาธของรูปภาพ
              width: 30, // กำหนดความกว้างของรูปภาพ
              height: 30, // กำหนดความสูงของรูปภาพ
            ),
            label: 'Profile', // ข้อความของรายการ
          ),
        ],
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
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

  Future<void> getUserDataFromStorage() async {
    final storage = GetStorage();

    final riderId = storage.read('RiderID');
    final senderId = storage.read('SenderID');
    // final userEmail = storage.read('Email');
    // final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.riderId = riderId;
      this.senderId = senderId;
      // this.userEmail = userEmail;
      // this.userImage = userImage;
      // log(userId);
    });
  }

  void getRiderMet() async {
    try {
      final response = await http.post(
        Uri.parse("$url/profile/rider"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({"RiderID": riderId}),
      );
      if (response.statusCode == 200) {
        // เมื่อดึงข้อมูลสำเร็จให้ใช้ setState
        setState(() {
          RiderGetResponses = riderGetResponseFromJson(
              response.body); // แปลง JSON และอัปเดตตัวแปร riders
        });
      } else {
        // จัดการกรณีเกิดข้อผิดพลาด
        // setState(() {
        // });
        throw Exception('Failed to load riders');
      }
      log(response.body);
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> fetchUsers() async {
    // แสดง dialog โหลดข้อมูล

    try {
      final res = await http.get(
        Uri.parse("$url/profile/user/$senderId"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        // ตรวจสอบว่า API ส่งกลับสถานะ 200 หรือไม่
        setState(() {
          GetResponsesUser = getResponseUserFromJson(res.body);
        });
      } else {
        log("Failed to load users: ${res.statusCode}");
      }

      final data = json.decode(res.body);
      // log(res.body);
    } catch (e) {
      log("Error: $e");
    } finally {
      // ปิด Dialog หลังจากโหลดข้อมูลเสร็จ
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
}
