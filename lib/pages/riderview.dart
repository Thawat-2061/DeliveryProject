import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider/pages/rider.dart';
import 'package:rider/pages/ridergps.dart';
import 'package:rider/pages/riprofile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';

class RiderviewPage extends StatefulWidget {
  const RiderviewPage({super.key});

  @override
  State<RiderviewPage> createState() => _RiderviewPageState();
}

class _RiderviewPageState extends State<RiderviewPage> {
  MapController mapController = MapController();

  LatLng latLng = LatLng(13.7378, 100.5504); // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng destinationLatLng = LatLng(
      16.246825669508297, 103.25199289277295); // จุดปลายทาง (ตัวอย่างพิกัด)
  final PanelController _panelController = PanelController();

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
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 20),
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
                            padding: const EdgeInsets.only(left: 30, top: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Receiver name:',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 5),
                            child: Row(
                              children: [
                                Text(
                                  'ลุงสมยศ พจมารทรายทอง',
                                  style: TextStyle(fontSize: 16),
                                )
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
                            padding: const EdgeInsets.only(left: 30, top: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Phone number:',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 5),
                            child: Row(
                              children: [
                                Text(
                                  '0999999999',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
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
                      )
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
                                child: Icon(Icons.motorcycle_sharp,
                                    color: Colors.red),
                              ),
                              Marker(
                                point: destinationLatLng, // จุดปลายทาง
                                width: 40,
                                height: 40,
                                child: Icon(Icons.location_pin,
                                    color: Colors.blue),
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
                    Get.to(() => const RiderPage());

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
              Icon(Icons.question_mark_rounded, color: Colors.amber), // เพิ่มไอคอนเตือน
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
                      // ปิด dialog และไปที่หน้าถัดไป
                      Navigator.of(context).pop(); // ปิด dialog
                      Get.to(() => const RiderGPSPage()); // เปลี่ยนไปที่หน้าถัดไป
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('You have received this job!')),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Color(0xFF67B562), // สีพื้นหลังของ Container
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

}